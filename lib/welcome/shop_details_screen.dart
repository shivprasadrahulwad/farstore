import 'package:farstore/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShopDetailsScreen extends StatefulWidget {
  static const String routeName = '/shop-details';
  const ShopDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ShopDetailsScreen> createState() => _ShopDetailsScreenState();
}

class _ShopDetailsScreenState extends State<ShopDetailsScreen> {
  // Controllers for form fields
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _shopIdController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _shopNameController.dispose();
    _mobileNumberController.dispose();
    _shopIdController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // Validation methods
  String? validateShopName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter shop name';
    }
    return null;
  }

  String? validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter mobile number';
    }
    if (value.length != 10) {
      return 'Mobile number must be 10 digits';
    }
    return null;
  }

  String? validateShopId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter store email';
    }
    return null;
  }

  String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter shop address';
    }
    return null;
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      // Handle form submission
      print('Form is valid');
      // Add your submission logic here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            Text(
                              "Friday, 11 Oct 24",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                fontFamily: 'Regular',
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.store_outlined,
                              size: 25,
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                fontFamily: 'SemiBold',
                              ),
                            ),
                            Text(
                              "Let's give us your Shop Info!",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                fontFamily: 'Regular',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'SHOP DETAILS',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.grey,
                            fontFamily: 'Regular',
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          controller: _shopNameController,
                          hintText: "Store name ( appears on app)",
                          prefixWidget: Padding(
                            padding: const EdgeInsets.only(right: 10, top: 3),
                            child: Image.asset(
                              'assets/images/store-alt.png',
                              width: 20,
                              height: 20,
                            ),
                          ),
                          validator: validateShopName,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: _mobileNumberController,
                          hintText: "Store phone",
                          prefixWidget: Padding(
                            padding: const EdgeInsets.only(right: 10, top: 3),
                            child: Image.asset(
                              'assets/images/phone-flip.png',
                              width: 20,
                              height: 20,
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          validator: validateMobile,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: _shopIdController,
                          hintText: "Store email",
                          prefixWidget: Padding(
                            padding: const EdgeInsets.only(right: 10, top: 3),
                            child: Image.asset(
                              'assets/images/envelope.png',
                              width: 20,
                              height: 20,
                            ),
                          ),
                          validator: validateShopId,
                        ),
                        const SizedBox(height: 20),
                        const SizedBox(height: 20),
                        const Text(
                          'OWNER DETAILS',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.grey,
                            fontFamily: 'Regular',
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          controller: _shopNameController,
                          hintText: "First name",
                          prefixWidget: Padding(
                            padding: const EdgeInsets.only(right: 10, top: 3),
                            child: Image.asset(
                              'assets/images/store-alt.png',
                              width: 20,
                              height: 20,
                            ),
                          ),
                          validator: validateShopName,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: _shopIdController,
                          hintText: "Last name",
                          prefixWidget: Padding(
                            padding: const EdgeInsets.only(right: 10, top: 3),
                            child: Image.asset(
                              'assets/images/envelope.png',
                              width: 20,
                              height: 20,
                            ),
                          ),
                          validator: validateShopId,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: GestureDetector(
                onTap: _handleSubmit,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'SemiBold',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
