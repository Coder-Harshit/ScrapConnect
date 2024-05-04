import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // return const Placeholder();
    return WillPopScope(
      onWillPop: () async {
        // Show a confirmation dialog when the back button is pressed
        bool? confirm = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Confirm Exit"),
              content: Text("Do you want to exit the app?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Stay in the app
                  },
                  child: Text("No"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Exit the app
                  },
                  child: Text("Yes"),
                ),
              ],
            );
          },
        );
        return confirm ?? false; // If confirm is null, default to false
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  "Scrap Connect",
                  style: Theme.of(context).primaryTextTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              Image(
                image: AssetImage('assets/images/Logo.png'),
                width: 300,
              ),
              Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Unlock the ",
                        style: TextStyle(
                          fontFamily: 'Comic',
                          fontStyle:
                              FontStyle.italic, // Use the custom font family
                          // fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      TextSpan(
                        text: "VALUE",
                        style: TextStyle(
                          fontFamily: 'FiraCode',
                          // fontStyle:
                          // FontStyle.italic, // Use the custom font family
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.amberAccent,
                        ),
                      ),
                      TextSpan(
                        text: " in your ",
                        style: TextStyle(
                          fontFamily: 'Comic',
                          fontStyle:
                              FontStyle.italic, // Use the custom font family
                          // fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      TextSpan(
                        text: "SCRAP",
                        style: TextStyle(
                          fontFamily: 'FiraCode',
                          // fontStyle:
                          // FontStyle.italic, // Use the custom font family
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.amberAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(143, 94, 223, 1.0),
                    foregroundColor: Colors.white,
                    elevation: 10.0,
                    padding:
                        EdgeInsets.symmetric(horizontal: 35, vertical: 13.5)),
                child: Text(
                  "Get Started",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.5,
                  ),
                ),
              )
            ],
          ),
        ),
        // ),
      ),
    );
  }
}
