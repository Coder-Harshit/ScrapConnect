import 'package:flutter/material.dart';
import 'package:scrap_connect/screens/signup_screen.dart';
import 'package:scrap_connect/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

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

      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        print('User is null after successful login');
      }
    } catch (e) {
      print('Login error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(12.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "LOGIN",
                      style: Theme.of(context)
                          .primaryTextTheme
                          .headlineLarge
                          ?.merge(
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

                    // Email Column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
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
                        SizedBox(height: 5),
                        TextField(
                          controller: emailController,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'FiraCode',
                          ),
                          decoration: InputDecoration(
                            hintText: 'sampleuser@gmail.com',
                            suffixIcon:
                                Icon(Icons.mail, color: Colors.grey[200]),
                            // hintStyle: TextStyle(color: Colors.white),
                            hintStyle: TextStyle(color: Colors.grey[350]),
                            contentPadding: EdgeInsets.all(20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Color.fromRGBO(143, 94, 223, 1.0),
                          ),
                        ),
                      ],
                    ),

                    // Password Column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
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
                        SizedBox(height: 5),
                        TextField(
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
                            suffixIcon:
                                Icon(Icons.lock, color: Colors.grey[200]),
                            hintStyle: TextStyle(color: Colors.grey[350]),
                            // hintStyle: TextStyle(color: Colors.white),
                            contentPadding: EdgeInsets.all(20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Color.fromRGBO(143, 94, 223, 1.0),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 50),

                    // Login Button
                    ElevatedButton(
                      onPressed: () {
                        _signInWithEmailAndPassword(
                            emailController.text, password);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(143, 94, 223, 1.0),
                        foregroundColor: Colors.white,
                        elevation: 10.0,
                        padding: EdgeInsets.symmetric(
                            horizontal: 35, vertical: 13.5),
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

                    // Divider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Divider(color: Colors.white54),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'OR',
                            style: TextStyle(
                                fontSize: 18.0, color: Colors.white54),
                          ),
                        ),
                        Expanded(
                          child: Divider(color: Colors.white54),
                        ),
                      ],
                    ),

                    // Login with Google Button
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(143, 94, 223, 1.0),
                        foregroundColor: Colors.white,
                        elevation: 10.0,
                        padding: EdgeInsets.symmetric(
                            horizontal: 35, vertical: 13.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/Search_GSA.original.png',
                              width: 24),
                          SizedBox(width: 10),
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

                    // Don't have an account Text
                    Center(
                      child: Text(
                        "Don't have an Account",
                        style:
                            Theme.of(context).primaryTextTheme.bodyLarge?.merge(
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

                    // SignUp Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(143, 94, 223, 1.0),
                        foregroundColor: Colors.white,
                        elevation: 10.0,
                        padding: EdgeInsets.symmetric(
                            horizontal: 35, vertical: 13.5),
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
          ],
        ),
      ),
    );
  }
}
