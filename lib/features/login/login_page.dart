import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/login_auth.dart';
import '../../services/snackbar_service.dart';
import '../../theme/theme_view_model.dart';
import '../home_page.dart';

// ignore: constant_identifier_names
enum FormType { LOGIN, REGISTER }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // state variables
  late String _email, _password, _firstName, _lastName;
  String _pageTitle = 'Account Login';
  FormType _formType = FormType.LOGIN;
  bool _loading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  bool validate() {
    final form = formKey.currentState!;
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  Future<void> submit(BuildContext context) async {
    if (validate()) {
      try {
        setState(() {
          _loading = true;
        });
        //final auth = Provider.of(context).auth;
        if (_formType == FormType.LOGIN) {
          // Login user using firebase API
          await AuthService().loginUser(email: _email, password: _password);
        } else {
          // Create New User user using firebase API
          await AuthService().createUser(
            email: _email,
            firstName: _firstName,
            lastName: _lastName,
            password: _password,
          );
        }

        setState(() {
          _loading = false;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            settings: const RouteSettings(name: 'HomePage'),
            builder: (BuildContext context) => const HomePage(),
          ),
        );
      } catch (e) {
        SnackbarService.showErrorMessage(e.toString());
      } finally {}
    }
  }

  void switchFormState(String state) {
    formKey.currentState!.reset();

    if (state == 'register') {
      setState(() {
        _formType = FormType.REGISTER;
        _pageTitle = 'Account Registration';
      });
    } else {
      setState(() {
        _formType = FormType.LOGIN;
        _pageTitle = 'Account Login';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_pageTitle),
        actions: [
          IconButton(
            icon: context.watch<ThemeViewModel>().isDarkMode
                ? const Icon(Icons.light_mode)
                : const Icon(Icons.mode_night),
            onPressed: () {
              context.read<ThemeViewModel>().toggleTheme();
            },
          ),
        ],
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children:
                  buildInputs(_formType) +
                  [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 30,
                      ),
                      child: Column(children: buildButtons(context)),
                    ),
                  ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildInputs(FormType formType) {
    final base = <Widget>[
      TextFormField(
        decoration: const InputDecoration(labelText: 'Email'),
        onSaved: (value) => _email = value!,
      ),
      TextFormField(
        //validator: PasswordValidator.validate,
        decoration: const InputDecoration(labelText: 'Password'),
        obscureText: true,
        onSaved: (value) => _password = value!,
      ),
    ];

    if (formType == FormType.REGISTER) {
      return base +
          <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'First Name'),
              onSaved: (value) => _firstName = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'LastName'),
              onSaved: (value) => _lastName = value!,
            ),
          ];
    } else {
      return base;
    }
  }

  List<Widget> buildButtons(BuildContext context) {
    if (_formType == FormType.LOGIN) {
      return [
        ElevatedButton(
          key: const Key('login'),
          child: const Align(child: Text('Login')),
          onPressed: () => submit(context),
        ),
        ElevatedButton(
          key: const Key('goto-register'),
          child: const Align(child: Text('Register Account')),
          onPressed: () {
            switchFormState('register');
          },
        ),
      ];
    } else {
      return [
        ElevatedButton(
          key: const Key('create-account'),
          child: const Align(child: Text('Create Account')),
          onPressed: () => submit(context),
        ),
        ElevatedButton(
          key: const Key('go-back'),
          child: const Align(child: Text('Back')),
          onPressed: () {
            switchFormState('login');
          },
        ),
      ];
    }
  }
}
