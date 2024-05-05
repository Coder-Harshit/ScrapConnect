import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scrap_connect/screens/appointments_screen.dart';
import 'package:scrap_connect/screens/splash_screen.dart';
import 'package:scrap_connect/screens/tender_screen.dart'; // Import your login screen file

void _logout(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut(); // Sign out the current user
    Navigator.pushAndRemoveUntil(
      // Navigate to the login screen after logout
      context,
      MaterialPageRoute(builder: (context) => SplashScreen()),
      (route) => false,
    );
  } catch (e) {
    print('Logout error: $e'); // Handle logout errors
  }
}

class UserPage extends StatelessWidget {
  final String username;
  UserPage({required this.username});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              _logout(context); // Pass the context to the logout function
            },
            child: Text(
              // "Logout",
              AppLocalizations.of(context)!.logout,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.5,
                fontFamily: 'MonaSans',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AppointmentsScreen(currentUserName: username),
                ),
              );
            },
            child: Text(
              // "Booked Appointments",
              AppLocalizations.of(context)!.bookedAppointments,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.5,
                fontFamily: 'MonaSans',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TenderForm(userId: username),
                ),
              );
            },
            child: Text(
              // "Tender",
              AppLocalizations.of(context)!.tender,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.5,
                fontFamily: 'MonaSans',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
