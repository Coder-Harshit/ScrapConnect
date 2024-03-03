import 'package:flutter/material.dart';
import 'package:scrap_connect/screens/login_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // return const Placeholder();
    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 93, 39, 179),
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(12.5),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                Text(
                  "SIGN UP",
                  style:
                      Theme.of(context).primaryTextTheme.headlineLarge?.merge(
                            TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'EnvyCode',
                              shadows: [
                                Shadow(
                                  color: const Color.fromARGB(200, 0, 0, 0),
                                  offset: Offset(1.5, 1.5),
                                  blurRadius: 15.0,
                                ),
                              ],
                            ),
                          ),
                ),

                //username COLUMN
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Text(
                        "Username",
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headlineSmall
                            ?.merge(
                              TextStyle(
                                fontFamily: 'Comic',
                              ),
                            ),
                      ),
                    ),
                    SizedBox(height: 2),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            // color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextField(
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'FiraCode',
                        ),
                        decoration: InputDecoration(
                          hintText: 'sampleuser',
                          suffixIcon: Icon(
                            Icons.account_circle_rounded,
                            color: Colors.grey,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.white,
                            // color: Colors.indigo[50],
                          ),
                          contentPadding: EdgeInsets.all(20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Color.fromRGBO(143, 94, 223, 1.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.5),
                  ],
                ),

                //EMAIL COLUMN
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Text(
                        "Email",
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headlineSmall
                            ?.merge(
                              TextStyle(
                                fontFamily: 'Comic',
                              ),
                            ),
                      ),
                    ),
                    SizedBox(height: 2),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            // color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextField(
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'FiraCode',
                        ),
                        decoration: InputDecoration(
                          hintText: 'sampleuser@gmail.com',
                          suffixIcon: Icon(
                            Icons.mail,
                            color: Colors.grey,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.white,
                            // color: Colors.indigo[50],
                          ),
                          contentPadding: EdgeInsets.all(20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Color.fromRGBO(143, 94, 223, 1.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.5),
                  ],
                ),

                //PASSWORD COLUMN
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Text(
                        "Password",
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headlineSmall
                            ?.merge(
                              TextStyle(
                                fontFamily: 'Comic',
                              ),
                            ),
                      ),
                    ),
                    SizedBox(height: 2),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            // color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextField(
                        obscureText: true,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'FiraCode',
                        ),
                        decoration: InputDecoration(
                          hintText: 'password',
                          suffixIcon: Icon(
                            Icons.lock,
                            color: Colors.grey,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.white,
                            // color: Colors.indigo[50],
                          ),
                          contentPadding: EdgeInsets.all(20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Color.fromRGBO(143, 94, 223, 1.0),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 40),

                //signup
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(143, 94, 223, 1.0),
                    foregroundColor: Colors.white,
                    elevation: 10.0,
                    padding:
                        EdgeInsets.symmetric(horizontal: 35, vertical: 13.5),
                  ),
                  child: Text(
                    "Signup",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.5,
                      fontFamily: 'MonaSans',
                    ),
                  ),
                ),

                SizedBox(height: 8),

                //divider
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.white54, // Color of the line
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.white54, // Color of the line
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8),

                //loginWithGoogle
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(143, 94, 223, 1.0),
                    foregroundColor: Colors.white,
                    elevation: 10.0,
                    padding:
                        EdgeInsets.symmetric(horizontal: 35, vertical: 13.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/Search_GSA.original.png',
                        width: 24,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Signup with GOOGLE",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.5,
                          fontFamily: 'MonaSans',
                        ),
                      ),
                    ],
                  ),
                ),

                // SizedBox(height: 10),

                //donthaveAccTEXT
                Center(
                  child: Text(
                    "Already have an Account?",
                    style: Theme.of(context).primaryTextTheme.bodyLarge?.merge(
                          TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17.5,
                            fontFamily: 'MonaSans',
                            letterSpacing: 0.75,
                            wordSpacing: 2,
                          ),
                        ),
                  ),
                ),

                //signup
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
                        EdgeInsets.symmetric(horizontal: 35, vertical: 13.5),
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.5,
                      fontFamily: 'MonaSans',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
