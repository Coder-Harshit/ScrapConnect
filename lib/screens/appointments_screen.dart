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

  String mailID = '';
  @override
  void initState() {
    super.initState();
    _fetchDealerNames();
    _fetchUserEmail(); // Call the method to fetch user email
  }

  void _fetchUserEmail() async {
    try {
      // Fetch the user document from Firestore based on email
      QuerySnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .where('username', isEqualTo: widget.currentUserName)
          .get();

      // Check if any documents are returned
      if (userSnapshot.docs.isNotEmpty) {
        // Get the first document (assuming email is unique)
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
            if (_selectedStatus != 'All') {
              _appointments = _appointments.where((appointment) {
                String status = _getAppointmentStatus(appointment['status']);
                return status == _selectedStatus;
              }).toList();
            }

            return ListView.builder(
              itemCount: _appointments.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> appointment = _appointments[index];
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
                  subtitle: Text(
                      // 'Dealer Name: $dealerName - Status: $status - $appointmentType'),
                      'Dealer Name: $dealerName \nStatus: $status \n$appointmentType'),
                  trailing: Text(status),
                );
              },
            );
          }
        },
      ),
    );
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
}
