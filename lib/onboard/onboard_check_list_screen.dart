import 'package:farstore/constants/global_variables.dart';
import 'package:flutter/material.dart';

class OnboardCheckListScreen extends StatefulWidget {
  @override
  _OnboardCheckListScreenState createState() => _OnboardCheckListScreenState();
}

class _OnboardCheckListScreenState extends State<OnboardCheckListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Bar (below AppBar)
            Container(
              height: 4,
              color: Colors.blueAccent,
              child: LinearProgressIndicator(
                value: 0.5, // Set progress value between 0.0 and 1.0
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
            const SizedBox(height: 20),
            // Image Section
            Center(
                child: Image.asset(
              'assets/images/offer.png',
              width: 180,
              height: 180,
              fit: BoxFit.cover,
            )),
            const SizedBox(height: 20),
            // Text Sections
            const Center(
              child: Text(
                'Setting up',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Center(
              child: Text(
                'your shop account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Follow these steps to complete your shop setup',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 30),
            // Gesture Detector Section
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: GlobalVariables.greyBlueBackgroundColor),
                    padding:
                        const EdgeInsets.all(8), // Adjust padding as needed
                    child: const Icon(
                      Icons.notes_outlined,
                      color: GlobalVariables.greyBlueColor,
                      size: 15,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Address book",
                    style: TextStyle(
                      fontFamily: 'Medium',
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    padding:
                        const EdgeInsets.all(8), // Adjust padding as needed
                    child: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: GlobalVariables.greyBlueColor,
                      size: 15,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: GlobalVariables.greyBlueBackgroundColor),
                    padding:
                        const EdgeInsets.all(8), // Adjust padding as needed
                    child: const Icon(
                      Icons.notes_outlined,
                      color: GlobalVariables.greyBlueColor,
                      size: 15,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Address book",
                    style: TextStyle(
                      fontFamily: 'Medium',
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    padding:
                        const EdgeInsets.all(8), // Adjust padding as needed
                    child: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: GlobalVariables.greyBlueColor,
                      size: 15,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: GlobalVariables.greyBlueBackgroundColor),
                    padding:
                        const EdgeInsets.all(8), // Adjust padding as needed
                    child: const Icon(
                      Icons.notes_outlined,
                      color: GlobalVariables.greyBlueColor,
                      size: 15,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Address book",
                    style: TextStyle(
                      fontFamily: 'Medium',
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    padding:
                        const EdgeInsets.all(8), // Adjust padding as needed
                    child: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: GlobalVariables.greyBlueColor,
                      size: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
