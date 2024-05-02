import 'package:cloud_firestore/cloud_firestore.dart';

class ExtractAppointments {
  // Function to fetch appointments for the current user
  static Future<List<Map<String, dynamic>>> getAppointmentsForCurrentUser(
      String currentUserName, String mailID) async {
    print("===>");
    print(mailID);
    // Initialize Firestore
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Query appointments collection for documents where userName is equal to currentUserName
      QuerySnapshot querySnapshot = await firestore
          .collection('Appointments')
          // .where('userName', isEqualTo: currentUserName)
          .where('email', isEqualTo: mailID)
          .get();
      // print(querySnapshot.docs.last.data());
      // Extract appointment data from documents
      List<Map<String, dynamic>> appointments = [];
      querySnapshot.docs.forEach((doc) {
        // Convert each document data to a Map and add it to the list
        Map<String, dynamic>? appointmentData =
            doc.data() as Map<String, dynamic>?; // Explicit cast
        if (appointmentData != null) {
          appointments.add(appointmentData);
        }
      });

      return appointments;
    } catch (e) {
      // Handle any errors that occur during the process
      print('Error fetching appointments: $e');
      return [];
    }
  }
}
