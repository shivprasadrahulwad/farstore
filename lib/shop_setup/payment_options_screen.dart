import 'package:farstore/models/deliveryType.dart';
import 'package:farstore/shop_setup/shop_setup_screen.dart';
import 'package:farstore/widgets/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class PaymentOptionScreen extends StatefulWidget {
  static const String routeName = '/payment';
  const PaymentOptionScreen({Key? key}) : super(key: key);

  @override
  State<PaymentOptionScreen> createState() => _PaymentOptionScreenState();
}

class _PaymentOptionScreenState extends State<PaymentOptionScreen> {
  DeliveryType? _selectedDeliveryType;
  final Box<DeliveryType> _box = Hive.box<DeliveryType>('deliveryType');

  @override
  void initState() {
    super.initState();
    _selectedDeliveryType = _box.get('selectedDeliveryType') ?? DeliveryType.cashOnDelivery;
    _saveDeliveryType(_selectedDeliveryType!);
  }

  void _saveDeliveryType(DeliveryType type) {
    _box.put('selectedDeliveryType', type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => NavigationMenu()
              ),
            );
          },
        ),
        title: const Text(
          'Delivery',
          style: TextStyle(
            fontFamily: 'Regular',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Manual Payment Method",
                  style: TextStyle(
                    fontFamily: 'Regular',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Payments that are made outside your online store. When a customer selects a manual payment method such as cash on delivery, you'll need to approve their order before it can be fulfilled.",
                  style: TextStyle(
                    fontFamily: 'Regular',
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(color: Colors.grey),
                const Text(
                  'Select Delivery Type',
                  style: TextStyle(
                    fontFamily: 'Regular',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ...DeliveryType.allTypes.map((type) {
                  return RadioListTile<DeliveryType>(
                    title: Text(type.name),
                    value: type,
                    groupValue: _selectedDeliveryType,
                    onChanged: (DeliveryType? value) {
                      setState(() {
                        _selectedDeliveryType = value;
                        _saveDeliveryType(value!);
                      });
                    },
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
