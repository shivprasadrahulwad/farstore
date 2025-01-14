import 'package:farstore/widgets/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SubscriptionBasicPlanScreen extends StatefulWidget {
  const SubscriptionBasicPlanScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionBasicPlanScreen> createState() =>
      _SubscriptionBasicPlanScreenState();
}

class _SubscriptionBasicPlanScreenState
    extends State<SubscriptionBasicPlanScreen> {
  bool showPlanDetails = false;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final after30Days = today.add(const Duration(days: 30));
    final dateFormatter = DateFormat('MMM dd, yyyy');

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => NavigationMenu()),
                );
              },
              child: const Icon(Icons.arrow_back_ios, size: 24),
            ),
            const SizedBox(height: 16),
            const Text(
              'ShopEz',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Basic ShopEz Plan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                GestureDetector(
                  onTap: () {
                    // Change plan logic
                  },
                  child: const Text(
                    'Change Plan',
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'You can change or cancel your plan at any time. Price excludes additional taxes.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // Timeline Widget with Visualization
            Stack(
              children: [
                // Timeline Line
                Positioned(
                  left: 20,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 4,
                    color: Colors.grey.shade300,
                  ),
                ),
                Column(
                  children: [
                    _buildTimelineStep(
                      'Today',
                      'Free',
                      'Free Trial',
                      Colors.green,
                      isFirst: true,
                    ),
                    const SizedBox(height: 24),
                    _buildTimelineStep(
                      dateFormatter.format(today),
                      '₹100',
                      'Billed every 30 days',
                      Colors.blue,
                      extraInfo: 'Basic',
                    ),
                    const SizedBox(height: 24),
                    _buildTimelineStep(
                      dateFormatter.format(after30Days),
                      '₹2000',
                      'Billed every 30 days',
                      Colors.orange,
                      extraInfo: 'Ongoing Plan',
                      isLast: true,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 32),
            const Divider(color: Colors.grey),

            GestureDetector(
              onTap: () {
                setState(() {
                  showPlanDetails = !showPlanDetails;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Plan Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Icon(
                    showPlanDetails
                        ? Icons.arrow_drop_up_sharp
                        : Icons.arrow_drop_down_sharp,
                    size: 24,
                  ),
                ],
              ),
            ),

            if (showPlanDetails)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  'The Basic ShopEz Plan includes access to essential features and services tailored to your shopping experience. Upgrade anytime to unlock premium benefits!',
                  style: TextStyle(fontSize: 14),
                ),
              ),

            // Total and Pricing Section
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '₹100 + tax',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Subscription action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Continue Subscription',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildTimelineStep(
    String date,
    String price,
    String billingInfo,
    Color color, {
    String extraInfo = '',
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline Dot
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                spreadRadius: 1,
                blurRadius: 3,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        if (extraInfo.isNotEmpty)
                          Text(
                            extraInfo,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          price,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        Text(
                          billingInfo,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
