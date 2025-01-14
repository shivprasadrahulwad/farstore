import 'package:farstore/constants/global_variables.dart';
import 'package:farstore/features/admin/screens/add_product_screen.dart';
import 'package:farstore/shop_setup/categories_setup_screen.dart';
import 'package:farstore/welcome/shop_details_screen.dart';
import 'package:farstore/widgets/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class SetupGuideWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: GlobalVariables.blueTextColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Get ready to sell',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Use this guide to get your store up and running',
                      style: TextStyle(
                        fontSize: 14,
                        color: GlobalVariables.greyTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: LinearProgressIndicator(
              value: 0.1,
              backgroundColor: Colors.grey[300],
              valueColor:
                  const AlwaysStoppedAnimation<Color>(GlobalVariables.blueTextColor),
              minHeight: 5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '0 of 5 tasks complete',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTaskRow(
                    'Add your store details', context, const ShopDetailsScreen()),
                const Divider(
                  color: Colors.grey,
                ),
                buildTaskRow('Create your first collection', context,
                    const CategoriesSetupScreen()),
                const Divider(
                  color: Colors.grey,
                ),
                buildTaskRow(
                    'Add your first product', context, const AddProductScreen()),
                const Divider(
                  color: Colors.grey,
                ),
                buildTaskRow(
                    'Share your products', context, const NavigationMenu()),
                const Divider(
                  color: Colors.grey,
                ),
                buildTaskRow('Configure your sales channel', context,
                    const NavigationMenu()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTaskRow(
      String taskTitle, BuildContext context, Widget nextScreen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          DottedBorder(
            borderType: BorderType.Circle,
            color: Colors.grey,
            strokeWidth: 2,
            dashPattern: [5, 5],
            child: const CircleAvatar(
              radius: 10,
              backgroundColor: Colors.transparent,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            taskTitle,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              // Navigate to the respective screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => nextScreen),
              );
            },
            child: const Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.grey,
              size: 15,
            ),
          ),
        ],
      ),
    );
  }
}
