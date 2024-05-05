import 'package:flutter/material.dart';
import 'package:scrap_connect/main.dart';
import 'login_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              title: Text(
                // "Confirm Exit",
                AppLocalizations.of(context)!.confirmExit,
              ),
              content: Text(
                // "Do you want to exit the app?",
                AppLocalizations.of(context)!.exitMessage,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Stay in the app
                  },
                  child: Text(
                    AppLocalizations.of(context)!.no,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Exit the app
                  },
                  child: Text(
                    AppLocalizations.of(context)!.yes,
                  ),
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
                  // AppLocalizations.of(context)!.scrapConnect,

                  style: Theme.of(context).primaryTextTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Show language selection dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title:
                            Text(AppLocalizations.of(context)!.changeLanguage),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Change language to Hindi
                                MyApp.setLocale(
                                    context, const Locale('hi', ''));
                                Navigator.pop(context); // Close dialog
                              },
                              child: Text(AppLocalizations.of(context)!.hindi),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Change language to English
                                MyApp.setLocale(
                                    context, const Locale('en', ''));
                                Navigator.pop(context); // Close dialog
                              },
                              child:
                                  Text(AppLocalizations.of(context)!.english),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Change button color
                  foregroundColor: Colors.black, // Change text color
                ),
                child: Text(AppLocalizations.of(context)!.language),
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
                        text: AppLocalizations.of(context)!.unlock,
                        style: TextStyle(
                          fontFamily: 'Comic',
                          fontStyle:
                              FontStyle.italic, // Use the custom font family
                          // fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      TextSpan(
                        text: AppLocalizations.of(context)!.value,
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
                        text: AppLocalizations.of(context)!.iny,
                        style: TextStyle(
                          fontFamily: 'Comic',
                          fontStyle:
                              FontStyle.italic, // Use the custom font family
                          // fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      TextSpan(
                        text: AppLocalizations.of(context)!.scr,
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
                  AppLocalizations.of(context)!.getstart,
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
