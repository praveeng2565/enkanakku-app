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
  const MyApp({super.key, this.initialTheme});

  final String? initialTheme;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeViewModel(initialTheme ?? 'light'),
        ),
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
                  return MaterialPageRoute(
                    settings: const RouteSettings(name: '/'),
                    builder: (_) => const LaunchPage(),
                  );
                case '/Login':
                  return MaterialPageRoute(
                    settings: const RouteSettings(name: '/Login'),
                    builder: (_) => const LoginPage(),
                  );
                case '/Home':
                  return MaterialPageRoute(
                    settings: const RouteSettings(name: '/Home'),
                    builder: (_) => const HomePage(),
                  );
                case '/AddExpense':
                  return MaterialPageRoute(
                    settings: const RouteSettings(name: '/AddExpense'),

                    builder: (_) => const AddExpense(),
                  );
                case '/EditExpense':
                  final args = settings.arguments! as Map<String, dynamic>;
                  return MaterialPageRoute(
                    settings: const RouteSettings(name: '/EditExpense'),
                    builder: (_) => EditExpense(
                      userExpense: args['userExpense'],
                      index: args['index'],
                    ),
                  );
                default:
                  return MaterialPageRoute(
                    settings: const RouteSettings(name: '/ComingSoon'),
                    builder: (_) => const ComingSoon(),
                  );
              }
            },
          );
        },
      ),
    );
  }
}
