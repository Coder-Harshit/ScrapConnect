import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // return const Placeholder();
    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 93, 39, 179),
      // backgroundColor: LinearGradient(colors: ),
      backgroundColor: Theme.of(context).primaryColor,
      // body: Container(
      //   decoration: BoxDecoration(
      //     gradient: LinearGradient(
      //       colors: [Color(0xFF0A2342), Color(0xFF22816E)],
      //       begin: Alignment.topLeft,
      //       end: Alignment.bottomRight,
      //     ),
      //   ),
      // child: SafeArea(
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

                // "Unlock the value\nin your scrap",
                // style: Theme.of(context).primaryTextTheme.headlineSmall,
                // textAlign: TextAlign.center,
              ),
            ),
            // FloatingActionButton.extended(
            //   onPressed: () {},
            //   label: Text("Get Started"),
            // )
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
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
    );
  }
}
