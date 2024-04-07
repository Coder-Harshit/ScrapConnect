// import 'package:flutter/gestures.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.username});

  final String username;
  @override
  Widget build(BuildContext context) {
    // return const Placeholder();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        // backgroundColor: Theme.of(context).primaryColor,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Greetings, $username!",
                  style: Theme.of(context).primaryTextTheme.labelLarge?.merge(
                        TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                ),
              ]),
        ),
      ),
    );
  }
}
