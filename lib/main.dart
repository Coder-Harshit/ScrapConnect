import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:scrap_connect/screens/home_screen.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'utils/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// sample cahnge

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter bindings are initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale; // Default to English
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      // theme: ThemeData(
      //     useMaterial3: true,
      //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple)),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale, // Set the locale dynamically
      home: SplashScreen(),

      // home: HomeScreen(
      //   username: 'harshit',
      // ),
    );
  }
}
