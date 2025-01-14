import 'package:flutter/material.dart';

class EmailOnboardingScreen extends StatefulWidget {
  const EmailOnboardingScreen({Key? key}) : super(key: key);

  @override
  _EmailOnboardingScreenState createState() => _EmailOnboardingScreenState();
}

class _EmailOnboardingScreenState extends State<EmailOnboardingScreen> {
  final TextEditingController _emailController = TextEditingController();
  String? _emailError;

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    return emailRegExp.hasMatch(email);
  }

  void validateAndProceed() {
    final email = _emailController.text.trim();
    
    if (email.isEmpty) {
      setState(() {
        _emailError = 'Please enter an email address';
      });
      return;
    }

    if (!isValidEmail(email)) {
      setState(() {
        _emailError = 'Please enter a valid email address';
      });
      return;
    }

    setState(() {
      _emailError = null;
    });

    // Proceed with sign up logic here
    print('Valid email: $email');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ShopEz Title
              const Text(
                'shopEz',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // Subheading 1
              const Text(
                'Bring your ideas to life for ₹20/month',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              // Subheading 2
              const Text(
                'The future of business is yours to shape. Sign up for free and enjoy first month for just ₹20',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 40),

              // Email Input and CTA Button
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: _emailError != null ? Colors.red : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your email address',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (_) {
                          if (_emailError != null) {
                            setState(() {
                              _emailError = null;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: ElevatedButton(
                        onPressed: validateAndProceed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                        ),
                        child: const Text(
                          'Start Free Trial',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_emailError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                  child: Text(
                    _emailError!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Terms Text
              Text(
                'Try shopEz for 3 days, no credit card required. By entering your email, you agree to receive marketing emails from shopEz',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}