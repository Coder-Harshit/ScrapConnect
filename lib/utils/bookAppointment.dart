import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package

// Function to book appointment
Future<void> bookAppointment(
    BuildContext context, String dealerId, String username) async {
  DateTime? selectedDateTime;

  // Function to show date picker
  Future<void> _selectDateTime() async {
    final DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDateTime != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        selectedDateTime = DateTime(
          pickedDateTime.year,
          pickedDateTime.month,
          pickedDateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      }
    }
  }

  // Show date and time picker
  await _selectDateTime();

  if (selectedDateTime != null) {
    try {
      // Check if the appointment already exists for the same user and date & time
      QuerySnapshot<Map<String, dynamic>> existingAppointments =
          await FirebaseFirestore.instance
              .collection('Appointments')
              .where('dealerId', isEqualTo: dealerId)
              .where('userName', isEqualTo: username)
              .where('appointmentDateTime', isEqualTo: selectedDateTime)
              .get();

      if (existingAppointments.docs.isEmpty) {
        // Create a new appointment document
        await FirebaseFirestore.instance.collection('Appointments').add({
          'dealerId': dealerId, // ID of the dealer
          'userName': username, // Username of the user
          'appointmentDateTime':
              selectedDateTime, // Date & time of the appointment
          'timestamp':
              FieldValue.serverTimestamp(), // Timestamp for the appointment
          'status': 'pending',
        });

        // Show success message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Appointment Booked'),
            content: Text('Your appointment has been booked successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Show error message if appointment already exists
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Appointment Already Booked'),
            content: Text(
                'An appointment already exists for the same user and date & time.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Error booking appointment: $e');
      // Show error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to book appointment. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
