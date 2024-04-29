// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import '../utils/extractingAppointments.dart';

class AppointmentsScreen extends StatelessWidget {
  final String currentUserName;

  AppointmentsScreen({required this.currentUserName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future:
            ExtractAppointments.getAppointmentsForCurrentUser(currentUserName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>> appointments = snapshot.data ?? [];

            List<Map<String, dynamic>> upcomingAppointments = [];
            List<Map<String, dynamic>> pastAppointments = [];

            // Separate appointments into upcoming and past
            DateTime now = DateTime.now();
            appointments.forEach((appointment) {
              Timestamp appointmentDateTime =
                  appointment['appointmentDateTime'];
              DateTime dateTime = appointmentDateTime.toDate();
              if (dateTime.isAfter(now)) {
                upcomingAppointments.add(appointment);
              } else {
                pastAppointments.add(appointment);
              }
            });

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (upcomingAppointments.isNotEmpty) ...[
                  Text(
                    'Upcoming Appointments',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: upcomingAppointments.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> appointment =
                            upcomingAppointments[index];
                        Timestamp appointmentDateTime =
                            appointment['appointmentDateTime'];
                        String formattedDateTime = DateFormat('MMM d, y H:mm a')
                            .format(appointmentDateTime.toDate());
                        return ListTile(
                          title: Text(formattedDateTime),
                          subtitle:
                              Text('Dealer ID: ${appointment['dealerId']}'),
                          // Add more details as needed
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                ],
                if (pastAppointments.isNotEmpty) ...[
                  Text(
                    'Past Appointments',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: pastAppointments.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> appointment =
                            pastAppointments[index];
                        Timestamp appointmentDateTime =
                            appointment['appointmentDateTime'];
                        String formattedDateTime = DateFormat('MMM d, y H:mm a')
                            .format(appointmentDateTime.toDate());
                        return ListTile(
                          title: Text(formattedDateTime),
                          subtitle:
                              Text('Dealer ID: ${appointment['dealerId']}'),
                          // Add more details as needed
                        );
                      },
                    ),
                  ),
                ],
                if (upcomingAppointments.isEmpty &&
                    pastAppointments.isEmpty) ...[
                  Center(child: Text('No appointments found.')),
                ],
              ],
            );
          }
        },
      ),
    );
  }
}
