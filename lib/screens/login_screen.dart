import 'package:flutter/material.dart';
import 'package:scrap_connect/screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scrap_connect/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();

  String password = '';

  Future<void> _signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // You can handle the successful login here
      print('User signed in: ${userCredential.user!.uid}');
      if (userCredential.user != null) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  HomeScreen(), // Replace HomeScreen with your actual screen
            ),
          );
        }
      } else {
        // Handle null user case
        print('User is null after successful login');
      }
    } catch (e) {
      // Handle login errors
      print('Login error: $e');
    }
  }

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
            // padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                Text(
                  "LOGIN",
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
                        controller: emailController,
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
                        onChanged: (value) {
                          password = value;
                        },
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

                SizedBox(height: 5),

                //login
                ElevatedButton(
                  onPressed: () {
                    _signInWithEmailAndPassword(emailController.text, password);
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

                SizedBox(height: 5),

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
                        "Login with GOOGLE",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.5,
                          fontFamily: 'MonaSans',
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 100),

                //donthaveAccTEXT
                Center(
                  child: Text(
                    "Don't have an Account",
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpScreen(),
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
                    "SignUp",
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
