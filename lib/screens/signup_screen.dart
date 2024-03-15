import 'package:flutter/material.dart';
import 'package:scrap_connect/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  Future<void> _signUpWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Save additional user information to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'username': username,
        // Add more fields as needed
      });

      // Navigate to the login screen after successful signup
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } catch (e) {
      // Handle signup errors
      print('Signup error: $e');
      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign up failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(12.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                            spreadRadius: 5,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextField(
                        controller: usernameController,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'FiraCode',
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter your username',
                          suffixIcon: Icon(
                            Icons.account_circle_rounded,
                            color: Colors.grey[200],
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey[350],
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
                            spreadRadius: 5,
                            blurRadius: 5,
                            offset: Offset(0, 3),
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
                          hintText: 'Enter your email',
                          suffixIcon: Icon(
                            Icons.mail,
                            color: Colors.grey[200],
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey[350],
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
                            spreadRadius: 5,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'FiraCode',
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          suffixIcon: Icon(
                            Icons.lock,
                            color: Colors.grey[200],
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey[350],
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
                    SizedBox(height: 40),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    _signUpWithEmailAndPassword(emailController.text,
                        passwordController.text, usernameController.text);
                  },
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
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.white54,
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
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () {
                    // Implement sign up with Google
                  },
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
                      SizedBox(width: 10),
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
                SizedBox(height: 110),
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
