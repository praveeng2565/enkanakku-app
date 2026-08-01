import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/login_auth.dart';
import '../../services/snackbar_service.dart';
import '../../theme/theme_view_model.dart';
import '../../utils/common.dart';
import '../../utils/enum.dart';
import '../dashboard/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late bool loginObscure;
  late PageType pageType;

  @override
  void initState() {
    super.initState();
    loginObscure = true;
    pageType = PageType.login;
    _name = TextEditingController(text: 'Praveen Keerthana');
    _email = TextEditingController(text: 'lifeledgerappdev@gmail.com');
    _password = TextEditingController(text: 'TestPassword@2026()');
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2347D9),
      // extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'lib/utils/images/login_1.png',
                fit: BoxFit.cover,
                scale: 0.94,
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: context.watch<ThemeViewModel>().isDark
                    ? const Icon(Icons.light_mode, color: Colors.yellow)
                    : const Icon(Icons.mode_night, color: Colors.yellow),
                onPressed: () {
                  context.read<ThemeViewModel>().changeTheme(
                    context.read<ThemeViewModel>().isDark
                        ? ThemeMode.light
                        : ThemeMode.dark,
                  );
                },
              ),
            ),
            loginUI(context),
          ],
        ),
      ),
    );
  }

  Widget loginUI(BuildContext context) {
    final isLoginPage = pageType == PageType.login;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                isLoginPage ? 'Login' : 'Sign Up',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (!isLoginPage) const SizedBox(height: 24),
              if (!isLoginPage)
                authTextField(
                  controller: _name,
                  label: 'Name',
                  hint: 'Enter your full name',
                  icon: Icons.person,
                ),
              SizedBox(height: isLoginPage ? 24 : 18),
              authTextField(
                controller: _email,
                label: 'Email',
                hint: 'Enter your email',
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 18),
              authTextField(
                controller: _password,
                label: 'Password',
                hint: 'Enter your password',
                icon: Icons.lock_outline,
                obscure: loginObscure,
                suffixIcon: IconButton(
                  icon: Icon(
                    loginObscure ? Icons.visibility_off : Icons.visibility,
                    size: 18,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      loginObscure = !loginObscure;
                    });
                  },
                ),
              ),
              if (isLoginPage)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Forgot Password?'),
                  ),
                ),
              if (!isLoginPage) const SizedBox(height: 18),
              SizedBox(
                width: 180,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2347D9),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    hideKeyboard();
                    await validateLogin(context);
                  },
                  child: Text(isLoginPage ? 'Login' : 'Sign Up'),
                ),
              ),
              const SizedBox(height: 16),
              const Text('OR'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Align(
                    child: TextButton(
                      onPressed: () {
                        pageType = isLoginPage
                            ? PageType.signUp
                            : PageType.login;
                        setState(() {});
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isLoginPage
                                ? 'Dont have an account? '
                                : 'Already have an account? ',
                          ),
                          Text(
                            isLoginPage ? 'Sign Up' : 'LogIn',
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                  /* ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.g_mobiledata),
                    label: const Text('Google'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.facebook),
                    label: const Text('Facebook'),
                  ), */
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> validateLogin(BuildContext context) async {
    final isLoginPage = pageType == PageType.login;
    if (!isLoginPage && _name.text.isEmpty) {
      SnackbarService.showErrorMessage('Name cannot be empty');
      return;
    }
    if (_email.text.isEmpty) {
      SnackbarService.showErrorMessage('Email cannot be empty');
      return;
    }
    if (_password.text.isEmpty) {
      SnackbarService.showErrorMessage('Password cannot be empty');
      return;
    }
    showProgressCircle(context);
    late bool status;
    if (isLoginPage) {
      status = await AuthService()
          .loginUser(email: _email.text, password: _password.text)
          .catchError((error) {
            removeProgressCircle(context);
            SnackbarService.showErrorMessage(error);
            return false;
          });
    } else {
      // Create New User user using firebase API
      status = await AuthService()
          .createUser(
            name: _name.text,
            email: _email.text,
            password: _password.text,
          )
          .catchError((error) {
            removeProgressCircle(context);
            SnackbarService.showErrorMessage(error);
            return false;
          });
    }
    if (!status) {
      return;
    }
    removeProgressCircle(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        settings: const RouteSettings(name: 'HomePage'),
        builder: (BuildContext context) => const HomePage(),
      ),
    );
  }
}

Widget authTextField({
  required TextEditingController controller,
  required String label,
  required String hint,
  required IconData icon,
  bool obscure = false,
  Widget? suffixIcon,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 8),
      TextField(
        obscureText: obscure,
        controller: controller,
        style: const TextStyle(fontSize: 14, color: Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, size: 18, color: Colors.black),
          suffixIcon: suffixIcon,
          hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF6B6B6B)),
          filled: true,
          fillColor: const Color(0xFFD9D9D9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    ],
  );
}
