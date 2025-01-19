import 'package:farstore/features/admin/newAccount/services/account_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Main content in ScrollView
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ShopEz Logo Text
                    const Text(
                      'shopEz',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 24),

                    // Create Account Text
                    const Text(
                      'Create a shopEz account',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Free Trial Text
                    const Text(
                      'One last step before starting your free trial.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Sign up options
                    _buildSignUpButton(
                      icon: Icons.email_outlined,
                      text: 'Sign up with email',
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),

                    _buildSignUpButton(
                      icon: Icons.apple,
                      text: 'Sign up with Apple',
                      onTap: () async {
                        try {
                          final userCredential =
                              await AuthService.signInWithApple();
                          if (userCredential != null) {
                            // Successfully signed in
                            print(
                                'Successfully signed in: ${userCredential.user?.email}');
                            // Navigate or update UI
                          }
                        } on FirebaseAuthException catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Firebase Auth Error: ${e.message}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } on PlatformException catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Platform Error: ${e.message}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Unexpected error: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildSignUpButton(
                      icon: Icons.facebook,
                      text: 'Sign up with Facebook',
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),

                    // _buildSignUpButton(
                    //   icon: Icons.g_mobiledata,
                    //   text: 'Sign up with Google',
                    //   onTap: () {
                    //     AuthService.signInWithGoogle();
                    //   },
                    // ),
                    _buildSignUpButton(
                      icon: Icons.g_mobiledata,
                      text: 'Sign up with Google',
                      onTap: () async {
                        try {
                          final userCredential =
                              await AuthService.signInWithGoogle();

                          if (userCredential != null) {
                            // Successfully signed in
                            print(
                                'Successfully signed in: ${userCredential.user?.email}');
                            // Navigate or update UI
                          }
                        } on FirebaseAuthException catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Firebase Auth Error: ${e.message}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } on PlatformException catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Platform Error: ${e.message}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Unexpected error: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 32),

                    // OR Divider
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(thickness: 1),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(thickness: 1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Already have account
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have a shopEz account? ',
                          style: TextStyle(fontSize: 16),
                        ),
                        GestureDetector(
                            onTap: () {},
                            child: const Row(
                              children: [
                                Text(
                                  'Log in',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 20,
                                  color: Colors.blue,
                                )
                              ],
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Bottom fixed content
            Container(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Terms and Conditions
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      children: [
                        const TextSpan(
                          text: 'By proceeding, you agree to the ',
                        ),
                        TextSpan(
                          text: 'Terms and Conditions',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Footer
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     TextButton(
                  //       onPressed: () {},
                  //       child: const Text('Help'),
                  //     ),
                  //     TextButton(
                  //       onPressed: () {},
                  //       child: const Text('Privacy'),
                  //     ),
                  //     TextButton(
                  //       onPressed: () {},
                  //       child: const Text('Terms'),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
