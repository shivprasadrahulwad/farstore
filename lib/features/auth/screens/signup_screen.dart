import 'package:farstore/constants/global_variables.dart';
import 'package:farstore/features/auth/services/auth_services.dart';
import 'package:flutter/material.dart';


class SignUpScreen extends StatefulWidget {
  static const String routeName = '/signup';
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _signUpFormKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
  }

  void signUpUser() {
    authService.signUpUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.greyBackgroundCOlor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              // Wrap your content with a Form widget
              key: _signUpFormKey, // Assign the form key
              child: ListView(
                shrinkWrap: true,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 20.0, bottom: 8.0),
                    child: Text(
                      "Welcome...",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  TextFormField(
                    controller: _nameController, // Bind the controller
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController, // Bind the controller
                    decoration: const InputDecoration(labelText: 'Email ID'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Email ID';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController, // Bind the controller
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }

                      if (value.length < 6) {
                        return 'Password should be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      // Validate form before submission
                      if (_signUpFormKey.currentState!.validate()) {
                        signUpUser();
                      }
                    },
                    child: const Text('SignUP'),
                  ),
                  const SizedBox(height: 12),
                  const Text('Or signup with', textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          // Implement Apple login
                        },
                        icon: const Icon(Icons.apple),
                      ),
                      // IconButton(
                      //   onPressed: () {
                      //     // Implement Google login
                      //   },
                      //   icon: Icon(Icons.google),
                      // ),
                      IconButton(
                        onPressed: () {
                          // Implement Facebook login
                        },
                        icon: const Icon(Icons.facebook),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
