import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/auth/launch_page.dart';
import 'features/auth/user_view_model.dart';
import 'features/expenses/add_expense.dart';
import 'services/snackbar_service.dart';
import 'theme/app_theme.dart';
import 'theme/theme_view_model.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
      ],
      child: Consumer<ThemeViewModel>(
        builder: (context, themeVM, child) {
          return MaterialApp(
            scaffoldMessengerKey: SnackbarService.messengerKey,
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeVM.themeMode,
            initialRoute: '/',
            routes: {
              '/': (context) => const LaunchPage(),
              '/AddExpense': (context) => const AddExpense(),
            },
          );
        },
      ),
    );
  }
}
