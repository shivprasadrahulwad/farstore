import 'package:farstore/models/orderSettings.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';


class OrderCancellationPolicyScreen extends StatefulWidget {
  const OrderCancellationPolicyScreen({Key? key}) : super(key: key);

  @override
  State<OrderCancellationPolicyScreen> createState() =>
      _OrderCancellationPolicyScreenState();
}

class _OrderCancellationPolicyScreenState
    extends State<OrderCancellationPolicyScreen> {
  final TextEditingController _policyController = TextEditingController();
  late Box<OrderSettings> orderSettingsBox;

  @override
  void initState() {
    super.initState();
    _initializeBox();
  }

  Future<void> _initializeBox() async {
  try {
    // Ensure the box is open before accessing it
    if (!Hive.isBoxOpen('orderSettings')) {
      await Hive.openBox<OrderSettings>('orderSettings');
    }

    orderSettingsBox = Hive.box<OrderSettings>('orderSettings');
    _loadPolicy();
  } catch (e) {
    print('Error initializing box: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error loading settings')),
    );
  }
}


  void _loadPolicy() {
  try {
    OrderSettings? orderSettings = orderSettingsBox.get('currentSettings');
    if (orderSettings != null && orderSettings.cancellationPolicy != null) {
      setState(() {
        _policyController.text = orderSettings.cancellationPolicy!;
      });
      print('Loaded policy: ${orderSettings.cancellationPolicy}');
    } else {
      print('No cancellation policy found in Hive. Key: currentSettings');
    }
  } catch (e) {
    print('Error loading policy: $e');
  }
}


  Future<void> _savePolicy() async {
  try {
    OrderSettings? existingSettings = orderSettingsBox.get('currentSettings');
    OrderSettings newSettings;

    if (existingSettings != null) {
      newSettings = existingSettings.copyWith(
        cancellationPolicy: _policyController.text,
      );
    } else {
      newSettings = OrderSettings(
        cancellationPolicy: _policyController.text,
        // Default values for other fields...
      );
    }

    await orderSettingsBox.put('currentSettings', newSettings);

    print('Saved policy: ${newSettings.cancellationPolicy}');
    print('Full OrderSettings object: ${newSettings.toMap()}');

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order cancellation policy saved')),
      );
    }
  } catch (e) {
    print('Error saving policy: $e');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving policy')),
      );
    }
  }
}


 @override
  void dispose() {
    _policyController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 20,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _savePolicy,
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Order Cancellation Policy',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _policyController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Order cancellation policy',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Add your store\'s order cancellation policy here. This will be visible to customers during the checkout process.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
