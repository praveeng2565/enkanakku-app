import 'dart:ui';

import 'package:enkanakku_app/features/home_page.dart';
import 'package:enkanakku_app/features/login/login_page.dart';
import 'package:enkanakku_app/repositories/user_view_model.dart';
import 'package:enkanakku_app/services/login_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    print("drawing Main Page");

    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserViewModel())],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.teal),
        initialRoute: "/",
        home: FutureBuilder<User?>(
          future: AuthService().getUser,
          builder: (context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              print(
                "drawing main: target screen" +
                    snapshot.connectionState.toString(),
              );
              final bool loggedIn = snapshot.hasData;
              return loggedIn ? HomePage() : LoginPage();
            } else {
              print(
                "drawing main: loading circle" +
                    snapshot.connectionState.toString(),
              );
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
