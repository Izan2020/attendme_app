import 'package:attendme_app/presentation/interface/widgets/buttons.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const routePath = '/login_screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailField = TextEditingController();
  final TextEditingController _passwordField = TextEditingController();
  double _opacityLogin = 0;

  @override
  void initState() {
    Future.microtask(() {
      setState(() {
        _opacityLogin = 1;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Login'),
      ),
      body: AnimatedOpacity(
        opacity: _opacityLogin,
        duration: const Duration(milliseconds: 300),
        child: SafeArea(
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _emailField,
                    decoration: const InputDecoration(label: Text('Email')),
                  ),
                  const SizedBox(
                    height: 42,
                  ),
                  TextField(
                    controller: _passwordField,
                    obscureText: true,
                    decoration: const InputDecoration(label: Text('Password')),
                  ),
                  const SizedBox(
                    height: 42,
                  ),
                  PrimaryButton(title: 'Login', onTap: () {})
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
