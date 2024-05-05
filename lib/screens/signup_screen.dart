import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scrap_connect/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scrap_connect/utils/generateCitiesByState.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  bool _obscureText = true;

  // final SignUpWithGoogle _signUpWithGoogle = SignUpWithGoogle();

  Future<void> _signUpWithEmailAndPassword(
    String email,
    String password,
    String username,
    String city,
    String contact,
    String landmark,
    String state,
  ) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      int parsedContact = int.parse(contact);
      // Save additional user information to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'username': username,
        'city': city,
        'contact': parsedContact,
        'landmark': landmark,
        'state': state,
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
          // content: Text('Sign up failed'),

          content: Text('Sign up failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

// Add a list of states and cities
  List<String> states = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
    'Andaman and Nicobar Islands',
    'Chandigarh',
    'Dadra and Nagar Haveli and Daman and Diu',
    'Delhi',
    'Lakshadweep',
    'Puducherry'
  ]; // Add your states

  Map<String, List<String>> citiesByState = generateCitiesByState();

  String selectedState = 'Rajasthan'; // Default selected state
  String selectedCity = 'Kota'; // Default selected city

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
                        keyboardType: TextInputType.emailAddress,
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

//

                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // State dropdown
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Text(
                        "State",
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headlineSmall
                            ?.merge(
                              TextStyle(
                                fontFamily: 'Comic',
                                color: Colors.white,
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
                      child: DropdownButtonFormField<String>(
                        value: selectedState,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedState = newValue!;
                            // Reset selected city when state changes
                            selectedCity = citiesByState[selectedState]![0];
                          });
                        },
                        items: states.map((String state) {
                          return DropdownMenuItem<String>(
                            value: state,
                            child: SizedBox(
                              width: 150,
                              child: Text(
                                state,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: selectedState == state
                                      ? Colors.amber
                                      : Colors.black,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        decoration: InputDecoration(
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
// City dropdown
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Text(
                        "City",
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headlineSmall
                            ?.merge(
                              TextStyle(
                                fontFamily: 'Comic',
                                color: Colors.white,
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
                      child: DropdownButtonFormField<String>(
                        value: selectedCity,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCity = newValue!;
                          });
                        },
                        items: citiesByState[selectedState]!.map((String city) {
                          return DropdownMenuItem<String>(
                            value: city,
                            child: SizedBox(
                              width: 150,
                              child: Text(
                                city,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: selectedCity == city
                                      ? Colors.amber
                                      : Colors.black,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        decoration: InputDecoration(
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
                        "Landmark",
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
                        controller: landmarkController,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'FiraCode',
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter your landmark',
                          suffixIcon: Icon(
                            Icons.token_rounded,
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
                        "Contact Number",
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
                        controller: contactController,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'FiraCode',
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter your Contact Number',
                          suffixIcon: Icon(
                            Icons.phone,
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
                        obscureText: _obscureText,
                        // obscureText: true,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'FiraCode',
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText =
                                    !_obscureText; // Toggle the boolean value
                              });
                            },
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey[200],
                            ),
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
                    _signUpWithEmailAndPassword(
                      emailController.text,
                      passwordController.text,
                      usernameController.text,
                      // cityController.text,
                      selectedCity,
                      contactController.text,
                      landmarkController.text,
                      // stateController.text,
                      selectedState,
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
                    "Signup",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.5,
                      fontFamily: 'MonaSans',
                    ),
                  ),
                ),
                // SizedBox(height: 5),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Expanded(
                //       child: Divider(
                //         color: Colors.white54,
                //       ),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
                //       child: Text(
                //         'OR',
                //         style: TextStyle(
                //           fontSize: 18.0,
                //           color: Colors.white54,
                //         ),
                //       ),
                //     ),
                //     Expanded(
                //       child: Divider(
                //         color: Colors.white54,
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(height: 5),
                // ElevatedButton(
                //   onPressed: () {
                //     // // Implement sign up with Google
                //     // final user = await _signUpWithGoogle.signUpWithGoogle();
                //     // if (user != null) {
                //     //   print("XOXOXOXOXOXOXOXOXOXOOX");
                //     // } else {
                //     //   print("===>this");
                //     // }
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Color.fromRGBO(143, 94, 223, 1.0),
                //     foregroundColor: Colors.white,
                //     elevation: 10.0,
                //     padding:
                //         EdgeInsets.symmetric(horizontal: 35, vertical: 13.5),
                //   ),
                // child: Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Image.asset(
                //       'assets/images/Search_GSA.original.png',
                //       width: 24,
                //     ),
                //     SizedBox(width: 10),
                //     Text(
                //       "Signup with GOOGLE",
                //       style: TextStyle(
                //         fontWeight: FontWeight.bold,
                //         fontSize: 18.5,
                //         fontFamily: 'MonaSans',
                //       ),
                // ),
                // ],
                // ),
                // ),
                SizedBox(height: 200),
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
