import 'package:flutter/material.dart';

class WaitPopup extends StatelessWidget {
  final VoidCallback onClose;

  const WaitPopup({Key? key, required this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ShopEz text
            Text(
              'ShopEz',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 16),

            // Heading text
            Text(
              'Heading back to ShopEz',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),

            // Subheading text
            Text(
              'this will only take a moment...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            SizedBox(height: 24),

            // Loading indicator
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}