import 'package:farstore/widgets/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class SubscriptionPlanScreen extends StatefulWidget {
  const SubscriptionPlanScreen({Key? key}) : super(key: key);

  @override
  _SubscriptionPlanScreenState createState() => _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends State<SubscriptionPlanScreen> {
  // Currently selected plan index
  int _selectedPlanIndex = -1;

  // Plan details
  final List<Map<String, dynamic>> _plans = [
    {
      'title': 'Basic Plan',
      'description': 'For solo enterpreneurs',
      'price': '1,900',
      'promoPrice': '100',
      'features': [
        'Limited access to core features',
        'Basic analytics',
        '24/7 chat support',
      ],
      'isMostPopular': true,
      'cardRate': '2% 3rd-party payment providers'
    },
    {
      'title': 'Standard Plan',
      'description': 'Perfect for small teams',
      'price': '7,400',
      'promoPrice': '100',
      'features': [
        'Advanced features',
        '5 additional staff accounts',
        'Comprehensive analytics',
        '24/7 chat support',
        'Priority support',
      ],
      'isMostPopular': false,
      'cardRate': '1% 3rd-party payment providers'
    },
    {
      'title': 'Premium Plan',
      'description': 'As your business scales',
      'price': '30,500',
      'promoPrice': '100',
      'features': [
        'All features unlocked',
        'Advanced analytics',
        '24/7 chat support',
        '10 additional staff accounts',
        'Custom integrations',
        'Enterprise-level security'
      ],
      'isMostPopular': false,
      'cardRate': '0.6% 3rd-party payment providers'
    },
    {
      'title': 'Plus Plan',
      'description': 'Unlimited power for professionals',
      'price': '1,75,500',
      'promoPrice': '100',
      'features': [
        'All features unlocked',
        'Advanced analytics',
        '24/7 dedicated support',
        'Custom integrations',
        '15 additional staff accounts',
        'Enterprise-level security'
      ],
      'isMostPopular': false,
      'cardRate': '0.6% 3rd-party payment providers'
    }
  ];

  // Calculate the date 30 days from now
  String _calculateCancelDate() {
    final DateTime now = DateTime.now();
    final DateTime cancelDate = now.add(const Duration(days: 30));
    return DateFormat('MMMM d').format(cancelDate);
  }

  // Build individual plan card
  Widget _buildPlanCard(int index) {
    final plan = _plans[index];
    final bool isSelected = _selectedPlanIndex == index;
    final bool isMostPopular = plan['isMostPopular'];

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedPlanIndex = index;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.only(
              top: isMostPopular ? 25 : 10, 
              bottom: 10
            ),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isSelected
                    ? [Colors.blue.shade600, Colors.blue.shade100]
                    : [Colors.white, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? Colors.blue.shade200
                      : Colors.grey.shade300,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
              border: Border.all(
                color: isSelected ? Colors.blue.shade700 : Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Plan Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      plan['title'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle, color: Colors.white)
                  ],
                ),
                const SizedBox(height: 10),

                // Plan Description
                Text(
                  plan['description'],
                  style: TextStyle(
                    color: isSelected ? Colors.white70 : Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 15),

                // Price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${plan['price']}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '/ month',
                      style: TextStyle(
                        color: isSelected ? Colors.white70 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20, thickness: 1),
                const Text(
                  'Card rates starting at ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.check_circle_outline,size: 16,color: isSelected ? Colors.white : Colors.blue.shade600,),
                    SizedBox(width: 8,),
                    Text(
                  '${plan['cardRate']}',
                  style: TextStyle(
                    color: isSelected ? Colors.white70 : Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Standout features',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 10),

                // Features
                ...List.generate(
                  (plan['features'] as List).length, 
                  (featureIndex) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: isSelected ? Colors.white : Colors.blue.shade600,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          plan['features'][featureIndex],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Most Popular Badge
        if (isMostPopular)
          Positioned(
            top: 8,
            left: -200,
            right: 0,
            child: Center(
              child: Container(
                width: 110,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.lightGreen.shade200,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Text(
                  'Most Popular',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.green.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () {
                  Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NavigationMenu()),
                      );
                }
              ),
              title: const Text(
                'Select a Plan',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              elevation: 0,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Cancel before ${_calculateCancelDate()} and you won\'t be charged. You can change your plan at any time.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blue.shade800,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildPlanCard(index),
                  childCount: _plans.length,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: _selectedPlanIndex != -1 
                    ? () {
                        // Handle plan selection
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Selected ${_plans[_selectedPlanIndex]['title']} plan'
                            ),
                          ),
                        );
                      } 
                    : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    _selectedPlanIndex != -1 
                      ? 'Continue with ${_plans[_selectedPlanIndex]['title']}' 
                      : 'Select a Plan',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}