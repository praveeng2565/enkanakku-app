import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/auth/launch_page.dart';
import 'features/auth/login_page.dart';
import 'features/auth/user_view_model.dart';
import 'features/expenses/add_expense.dart';
import 'features/expenses/edit_expense.dart';
import 'features/home/home_page.dart';
import 'features/home/home_view_model.dart';
import 'services/snackbar_service.dart';
import 'theme/app_theme.dart';
import 'theme/theme_view_model.dart';
import 'utils/coming_soon.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
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
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/':
                  return MaterialPageRoute(builder: (_) => const LaunchPage());
                case '/Login':
                  return MaterialPageRoute(builder: (_) => const LoginPage());
                case '/Home':
                  return MaterialPageRoute(builder: (_) => const HomePage());
                case '/AddExpense':
                  return MaterialPageRoute(builder: (_) => const AddExpense());
                case '/EditExpense':
                  final args = settings.arguments! as Map<String, dynamic>;
                  return MaterialPageRoute(
                    builder: (_) => EditExpense(
                      userExpense: args['userExpense'],
                      index: args['index'],
                    ),
                  );
                default:
                  return MaterialPageRoute(builder: (_) => const ComingSoon());
              }
            },
          );
        },
      ),
    );
  }
}
