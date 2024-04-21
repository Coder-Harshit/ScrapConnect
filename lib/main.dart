import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:scrap_connect/screens/home_screen.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'utils/theme.dart';

// sample cahnge

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter bindings are initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      // theme: ThemeData(
      //     useMaterial3: true,
      //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple)),
      home: SplashScreen(),
      // home: HomeScreen(
      // username: 'harshit',
      // ),
    );
  }
}
