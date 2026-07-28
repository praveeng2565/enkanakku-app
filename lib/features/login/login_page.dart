import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/login_auth.dart';
import '../../services/snackbar_service.dart';
import '../../theme/theme_view_model.dart';
import '../../utils/common.dart';
import '../home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _loginEmail;
  late final TextEditingController _loginPassword;

  bool loginObscure = true;

  @override
  void initState() {
    super.initState();
    _loginEmail = TextEditingController(text: 'lifeledgerappdev@gmail.com');
    _loginPassword = TextEditingController(text: 'Qwerty@2025()');
  }

  @override
  void dispose() {
    _loginEmail.dispose();
    _loginPassword.dispose();
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
                icon: context.watch<ThemeViewModel>().isDarkMode
                    ? const Icon(Icons.light_mode, color: Colors.yellow)
                    : const Icon(Icons.mode_night, color: Colors.yellow),
                onPressed: () {
                  context.read<ThemeViewModel>().toggleTheme();
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
              const Text(
                'Login',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              authTextField(
                controller: _loginEmail,
                label: 'Email',
                hint: 'Enter your email',
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 18),
              authTextField(
                controller: _loginPassword,
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

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Forgot Password?'),
                ),
              ),
              SizedBox(
                width: 180,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2347D9),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    await validateLogin(context);
                  },
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(height: 16),
              const Text('OR'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.g_mobiledata),
                    label: const Text('Google'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.facebook),
                    label: const Text('Facebook'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> validateLogin(BuildContext context) async {
    if (_loginEmail.text.isEmpty) {
      SnackbarService.showErrorMessage('Email cannot be empty');
      return;
    }
    if (_loginPassword.text.isEmpty) {
      SnackbarService.showErrorMessage('Password cannot be empty');
      return;
    }
    showProgressCircle(context);
    if (_loginEmail.text.isNotEmpty && _loginPassword.text.isNotEmpty) {
      await AuthService()
          .loginUser(email: _loginEmail.text, password: _loginPassword.text)
          .catchError((error) {
            removeProgressCircle(context);
            SnackbarService.showErrorMessage(error.toString());
          });
    } else {
      // Create New User user using firebase API
      // await AuthService().createUser(
      //   email: _email,
      //   firstName: _firstName,
      //   lastName: _lastName,
      //   password: _password,
      // );
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
