import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/home_page.dart';
import 'features/login/login_page.dart';
import 'repositories/user_view_model.dart';
import 'services/login_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  const fatalError = true;
  // Non-async exceptions
  FlutterError.onError = (errorDetails) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    }
  };
  // Async exceptions
  PlatformDispatcher.instance.onError = (error, stack) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
    return true;
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print('drawing Main Page');

    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserViewModel())],
      child: MaterialApp(
        theme: ThemeData(
          // Define the default brightness and colors.
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.purple,
            // TRY THIS: Change to "Brightness.light"
            //           and see that all colors change
            //           to better contrast a light background.
            brightness: Brightness.dark,
          ),

          // Define the default `TextTheme`. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
            // TRY THIS: Change one of the GoogleFonts
            //           to "lato", "poppins", or "lora".
            //           The title uses "titleLarge"
            //           and the middle text uses "bodyMedium".
            // titleLarge: GoogleFonts.oswald(
            //   fontSize: 30,
            //   fontStyle: FontStyle.italic,
            // ),
            // bodyMedium: GoogleFonts.merriweather(),
            // displaySmall: GoogleFonts.pacifico(),
          ),
        ),
        initialRoute: '/',
        home: FutureBuilder<User?>(
          future: AuthService().getUser,
          builder: (context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final bool loggedIn = snapshot.hasData;
              return loggedIn ? const HomePage() : const LoginPage();
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
