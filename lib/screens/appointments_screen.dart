import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/extractingAppointments.dart';

class AppointmentsScreen extends StatefulWidget {
  final String currentUserName;

  AppointmentsScreen({required this.currentUserName});

  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  String _selectedStatus = 'All';
  late List<Map<String, dynamic>> _appointments;
  Map<String, String> _dealerNames = {};
  List<Map<String, dynamic>> _pastApprovedAppointments = [];

  String mailID = '';

  @override
  void initState() {
    super.initState();
    _fetchDealerNames();
    _fetchUserEmail();
  }

  void _fetchUserEmail() async {
    try {
      QuerySnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .where('username', isEqualTo: widget.currentUserName)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        mailID = userSnapshot.docs.first.data()['email'] ?? '';
        print(mailID.toString());
      } else {
        print('No user found with email: ${widget.currentUserName}');
      }
    } catch (e) {
      print("Error fetching user email: $e");
    }
  }

  void _fetchDealerNames() async {
    QuerySnapshot<Map<String, dynamic>> dealerSnapshot =
        await FirebaseFirestore.instance.collection('Kabadi_walas').get();

    dealerSnapshot.docs.forEach((doc) {
      _dealerNames[doc['ID'].toString()] = doc['Name'];
    });

    print(_dealerNames);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              setState(() {
                _selectedStatus = value.toString();
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                value: 'All',
                child: Text('All'),
              ),
              PopupMenuItem(
                value: 'Pending',
                child: Text('Pending'),
              ),
              PopupMenuItem(
                value: 'Declined',
                child: Text('Declined'),
              ),
              PopupMenuItem(
                value: 'Approved',
                child: Text('Approved'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: ExtractAppointments.getAppointmentsForCurrentUser(
            widget.currentUserName, mailID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            _appointments = snapshot.data ?? [];

            // Filter appointments based on selected status
            List<Map<String, dynamic>> filteredAppointments =
                _filterAppointments(_appointments);

            // Separate past approved appointments
            _pastApprovedAppointments = _appointments.where((appointment) {
              String status = _getAppointmentStatus(appointment['status']);
              String appointmentType =
                  _getAppointmentType(appointment['appointmentDateTime']);
              return status == 'Approved' && appointmentType == 'Past';
            }).toList();

            return ListView.builder(
              itemCount: filteredAppointments.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> appointment = filteredAppointments[index];
                Timestamp appointmentDateTime =
                    appointment['appointmentDateTime'];
                String formattedDateTime = DateFormat('MMM d, y H:mm a')
                    .format(appointmentDateTime.toDate());

                String status = _getAppointmentStatus(appointment['status']);
                String appointmentType =
                    _getAppointmentType(appointmentDateTime);

                String dealerId = appointment['dealerId'];
                String dealerName = _dealerNames[dealerId] ?? 'Unknown';

                return ListTile(
                  title: Text(formattedDateTime),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dealer Name: $dealerName'),
                      Text('Status: $status'),
                      Text('$appointmentType'),
                    ],
                  ),
                  trailing: Text(status),
                  onTap: () {
                    if (appointmentType == 'Past' && status == 'Approved') {
                      _showAppointmentDetailsDialog(appointment);
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  List<Map<String, dynamic>> _filterAppointments(
      List<Map<String, dynamic>> appointments) {
    if (_selectedStatus == 'All') {
      return appointments;
    } else {
      return appointments
          .where((appointment) =>
              _getAppointmentStatus(appointment['status']) == _selectedStatus)
          .toList();
    }
  }

  String _getAppointmentStatus(String status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'declined':
        return 'Declined';
      case 'approved':
        return 'Approved';
      default:
        return 'Unknown';
    }
  }

  String _getAppointmentType(Timestamp appointmentDateTime) {
    DateTime now = DateTime.now();
    DateTime dateTime = appointmentDateTime.toDate();
    return dateTime.isAfter(now) ? 'Upcoming' : 'Past';
  }

  void _showAppointmentDetailsDialog(Map<String, dynamic> appointment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Appointment Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  'Date and Time: ${DateFormat('MMM d, y H:mm a').format(appointment['appointmentDateTime'].toDate())}',
                ),
              ),
              Flexible(
                child: Text(
                  'Dealer Name: ${_dealerNames[appointment['dealerId']]}',
                ),
              ),
              Flexible(
                child: Text(
                  'Status: ${_getAppointmentStatus(appointment['status'])}',
                ),
              ),
              Flexible(
                child: Text(
                  '${_getAppointmentType(appointment['appointmentDateTime'])}',
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text('Rate this appointment: '),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    child: RatingWidget(
                      onChanged: (double rating) {
                        _updateDealerRating(appointment['dealerId'], rating);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

void _updateDealerRating(String dealerId, double rating) async {
  try {
    // Parse dealerId to an integer, providing a default value of 0 if parsing fails
    int dealerIdAsInt = int.tryParse(dealerId) ?? 0;

    QuerySnapshot<Map<String, dynamic>> dealerSnapshot = await FirebaseFirestore
        .instance
        .collection('Kabadi_walas')
        .where('ID', isEqualTo: dealerIdAsInt)
        .get();

    if (dealerSnapshot.docs.isNotEmpty) {
      // Get the first document since ID should be unique
      DocumentSnapshot<Map<String, dynamic>> dealerDocument =
          dealerSnapshot.docs.first;

      double currentRating = (dealerDocument.data()?['Rating'] ?? 0).toDouble();
      int numberOfRatings = dealerDocument.data()?['Number_of_Ratings'] ?? 0;

      double newRating =
          ((currentRating * numberOfRatings) + rating) / (numberOfRatings + 1);

      await dealerDocument.reference.update({
        'Rating': newRating,
        'Number_of_Ratings': numberOfRatings + 1,
      });

      // Optionally, you can show a confirmation message or update the UI
    } else {
      print('Dealer with ID $dealerIdAsInt not found.');
    }
  } catch (e) {
    print("Error updating dealer rating: $e");
  }
}

class RatingWidget extends StatefulWidget {
  final ValueChanged<double> onChanged;

  RatingWidget({required this.onChanged});

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        return IconButton(
          onPressed: () {
            setState(() {
              _rating = index + 1;
              widget.onChanged(_rating);
            });
          },
          icon: Icon(
            index < _rating ? Icons.star : Icons.star_border,
            color: Colors.orange,
          ),
        );
      }),
    );
  }
}
