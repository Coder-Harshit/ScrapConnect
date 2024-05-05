import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../utils/extractingAppointments.dart';

class AppointmentsScreen extends StatefulWidget {
  final String currentUserName;

  AppointmentsScreen({required this.currentUserName});

  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  void refreshAppointments() {
    setState(() {});
  }

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
        title: Text(
          // 'Appointments',
          AppLocalizations.of(context)!.appTitle,
        ),
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
                child: Text(
                  // 'All',
                  AppLocalizations.of(context)!.allStatus,
                ),
              ),
              PopupMenuItem(
                value: 'Pending',
                child: Text(
                  // 'Pending'
                  AppLocalizations.of(context)!.pendingStatus,
                ),
              ),
              PopupMenuItem(
                value: 'Declined',
                child: Text(
                  // 'Declined'
                  AppLocalizations.of(context)!.declinedStatus,
                ),
              ),
              PopupMenuItem(
                value: 'Approved',
                child: Text(
                  // 'Approved'
                  AppLocalizations.of(context)!.approvedStatus,
                ),
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
                      Text(
                        // 'Dealer Name: $dealerName',
                        AppLocalizations.of(context)!.dealerName(dealerName),
                      ),
                      Text(
                        // 'Status: $status'
                        AppLocalizations.of(context)!.status(status),
                      ),
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

  // void _markAppointmentAsRated(Map<String, dynamic> appointment) async {
  //   try {
  //     Timestamp timestamp = appointment['timestamp'];
  //     if (timestamp != null) {
  //       QuerySnapshot<Map<String, dynamic>> appointmentSnapshot =
  //           await FirebaseFirestore.instance
  //               .collection('appointments')
  //               .where('timestamp', isEqualTo: timestamp)
  //               .limit(1)
  //               .get();
  //       if (appointmentSnapshot.docs.isNotEmpty) {
  //         DocumentSnapshot<Map<String, dynamic>> appointmentDocument =
  //             appointmentSnapshot.docs.first;
  //         await appointmentDocument.reference.update({'rated': true});
  //         print('Appointment marked as rated.');
  //       } else {
  //         print('Error: Appointment not found.');
  //       }
  //     } else {
  //       print('Error: Timestamp not found.');
  //     }
  //   } catch (e) {
  //     print('Error marking appointment as rated: $e');
  //   }
  // }

  void _showAppointmentDetailsDialog(Map<String, dynamic> appointment) {
    bool isRated = appointment['rated'] ?? false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            // 'Appointment Details',
            AppLocalizations.of(context)!.appointmentDetails,
          ),
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
                    child: Text(
                      // 'Rate this appointment: ',
                      AppLocalizations.of(context)!.rateAppointment,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    child: isRated
                        ? Text(
                            // 'Already Rated',
                            AppLocalizations.of(context)!.alreadyRated,
                          )
                        : RatingWidget(
                            onChanged: (double rating) {
                              setState(() {
                                appointment['rated'] = true;
                              });
                              _updateDealerRating(
                                appointment['dealerId'],
                                rating,
                                appointment,
                                refreshAppointments,
                              );

                              // Mark the appointment as rated
                              // _markAppointmentAsRated(appointment);
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
              child: Text(
                // 'Close'
                AppLocalizations.of(context)!.closeButton,
              ),
            ),
          ],
        );
      },
    );
  }
}

void _updateDealerRating(String dealerId, double rating,
    Map<String, dynamic> appointment, Function refreshCallback) async {
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
      QuerySnapshot<Map<String, dynamic>> appointmentSnapshot =
          await FirebaseFirestore.instance
              .collection('Appointments')
              .where('dealerId', isEqualTo: dealerId)
              .where('appointmentDateTime',
                  isEqualTo: appointment['appointmentDateTime'])
              .get();

      // print("=====>>>>>");
      // print(appointmentSnapshot.docs.toString());
      if (appointmentSnapshot.docs.isNotEmpty) {
        // Get the document reference of the first document (assuming dealerId and timestamp uniquely identify an appointment)
        DocumentReference appointmentRef =
            appointmentSnapshot.docs.first.reference;

        // Update the 'rated' field in the appointment document
        await appointmentRef.update({'rated': true});

        // Optionally, you can show a confirmation message or update the UI

        // Reload appointments after rating
        refreshCallback();
      } else {
        print('Appointment not found.');
      }
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
            if (_rating != 0) {
              // If already rated, do nothing
              print("Appointment already rated");
              return;
            }
            setState(() {
              _rating = index + 1;
            });
            widget.onChanged(_rating);
          },
          icon: _rating >= index + 1
              ? Icon(
                  Icons.star,
                  color: Colors.orange,
                )
              : Icon(
                  Icons.star_border,
                  color: Colors.orange,
                ),
        );
      }),
    );
  }
}
