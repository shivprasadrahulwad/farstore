import 'package:flutter/material.dart';
import 'package:farstore/models/coupon.dart';
import 'package:farstore/widgets/custom_check_box.dart';
import 'package:farstore/widgets/custom_dropdown_field.dart';
import 'package:farstore/widgets/custom_radio_button.dart';
import 'package:farstore/widgets/custom_text_field.dart';
import 'package:farstore/widgets/navigation_menu.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class CreateCouponScreen extends StatefulWidget {
  const CreateCouponScreen({Key? key}) : super(key: key);

  @override
  _CreateCouponScreenState createState() => _CreateCouponScreenState();
}

class _CreateCouponScreenState extends State<CreateCouponScreen> {
  // Controllers
  final TextEditingController couponCodeController = TextEditingController();
  final TextEditingController percentOffController = TextEditingController();
  final TextEditingController purchaseValueController = TextEditingController();
  final TextEditingController customLimitController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  DateTime? currentTime;
  bool isChecked1 = false;
  bool isChecked2 = false;

  // State variables
  String selectedValue = 'Percentage';
  String? selectedOption = 'Option 1';
  Map<String, bool> _selectedOptions = {
    ' Limit number of times this discount can be used in total': false,
    ' Limit to one use per customer': false,
  };

  // Function to handle checkbox changes
  void _onCheckboxChanged(String option, bool? value) {
    setState(() {
      _selectedOptions[option] = value!;
    });
  }

  Future<void> _saveCoupon() async {
    // Validate required fields
    if (couponCodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a coupon code')),
      );
      return;
    }

    // Validate off value based on selected category
    double? offValue;
    try {
      offValue = double.parse(percentOffController.text);
      if (offValue <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${selectedValue} must be greater than 0')),
        );
        return;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid ${selectedValue} value')),
      );
      return;
    }

    // Validate minimum purchase amount if Option 2 is selected
    double? minimumPurchase;
    if (selectedOption == 'Option 2') {
      try {
        minimumPurchase = double.parse(purchaseValueController.text);
        if (minimumPurchase <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('Minimum purchase amount must be greater than 0')),
          );
          return;
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid minimum purchase amount')),
        );
        return;
      }
    }

    // Validate custom limit if checked
    int? customLimit;
    bool hasCustomLimit = _selectedOptions[
            ' Limit number of times this discount can be used in total'] ??
        false;
    if (hasCustomLimit) {
      try {
        customLimit = int.parse(customLimitController.text);
        if (customLimit <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Custom limit must be greater than 0')),
          );
          return;
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid custom limit')),
        );
        return;
      }
    }

    // Prepare start and end dates/times
    String? formattedStartDate =
        startDate != null ? DateFormat('yyyy-MM-dd').format(startDate!) : null;
    String? formattedEndDate = endDate != null && isChecked1
        ? DateFormat('yyyy-MM-dd').format(endDate!)
        : null;

    // Calculate time in minutes
    int? startTimeInMinutes =
        startTime != null ? startTime!.hour * 60 + startTime!.minute : null;
    int? endTimeInMinutes = endTime != null && isChecked1
        ? endTime!.hour * 60 + endTime!.minute
        : null;

    // Create Coupon object
    final coupon = Coupon(
      couponCode: couponCodeController.text,
      off: offValue,
      price: minimumPurchase,
      customLimit: customLimit,
      limit: _selectedOptions[' Limit to one use per customer'] ?? false,
      startDate: formattedStartDate,
      endDate: formattedEndDate,
      startTimeMinutes: startTimeInMinutes,
      endTimeMinutes: endTimeInMinutes,
    );

    try {
      // Open Hive box
      final couponBox = await Hive.openBox<Coupon>('coupons');

      // Save coupon
      await couponBox.put(couponCodeController.text, coupon);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Coupon ${couponCodeController.text} created successfully')),
      );

      // Optional: Clear form after saving
      _clearForm();
    } catch (e) {
      // Handle any errors during saving
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving coupon: $e')),
      );
    }
  }

  void _clearForm() {
    couponCodeController.clear();
    percentOffController.clear();
    purchaseValueController.clear();
    customLimitController.clear();

    setState(() {
      startDate = null;
      endDate = null;
      startTime = null;
      endTime = null;
      selectedValue = 'Percentage';
      selectedOption = 'Option 1';
      isChecked1 = false;
      _selectedOptions = {
        ' Limit number of times this discount can be used in total': false,
        ' Limit to one use per customer': false,
      };
    });
  }

  String _formatDate(DateTime? date, String placeholder) {
    return date != null ? DateFormat('dd MMM, EEE').format(date) : placeholder;
  }

  String _formatTime(TimeOfDay? time, String placeholder) {
    return time != null ? time.format(context) : placeholder;
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? (startDate ?? DateTime.now()),
      firstDate: startDate ?? DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedStartTime = await showTimePicker(
      context: context,
      initialTime: startTime ?? TimeOfDay.now(),
    );
    if (pickedStartTime != null && pickedStartTime != startTime) {
      setState(() {
        startTime = pickedStartTime;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? pickedEndTime = await showTimePicker(
      context: context,
      initialTime: endTime ?? TimeOfDay.now(),
    );
    if (pickedEndTime != null && pickedEndTime != endTime) {
      setState(() {
        endTime = pickedEndTime;
      });
    }
  }

  // Custom radio tile builder
  Widget _buildCustomRadioTile(String title, String optionValue) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = optionValue;
        });
      },
      child: Row(
        children: [
          CustomRadioButton(
            isSelected: selectedOption == optionValue,
            onChanged: (bool value) {
              setState(() {
                selectedOption = optionValue;
              });
            },
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector({
    required String placeholder,
    required VoidCallback onTap,
    DateTime? date,
    TimeOfDay? time,
    bool isTime = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Text(
              isTime
                  ? _formatTime(time, placeholder)
                  : _formatDate(date, placeholder),
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Create Coupon',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (() {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NavigationMenu(),
              ),
            );
          }),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Coupon Details Container
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: couponCodeController,
                        hintText: 'Coupon Code',
                        maxLines: 1,
                        prefixWidget: Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Image.asset(
                            'assets/images/envelope.png',
                            width: 20,
                            height: 20,
                          ),
                        ),
                        fillColor: Colors.white,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      CustomDropdownField(
                        hintText: 'Category',
                        value: selectedValue,
                        items: ['Percentage', 'Fixed Amount'],
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValue = newValue!;
                          });
                          print('Selected Value: $newValue');
                        },
                        placeholderText: 'Select a category',
                        isEnabled: true,
                      ),
                      if (selectedValue == 'Percentage')
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: CustomTextField(
                            controller: percentOffController,
                            hintText: '${selectedValue}',
                            maxLines: 1,
                            prefixWidget: Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Image.asset(
                                'assets/images/envelope.png',
                                width: 20,
                                height: 20,
                              ),
                            ),
                            fillColor: Colors.white,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      const SizedBox(height: 10),
                      if (selectedValue == 'Fixed Amount')
                        CustomTextField(
                          controller: percentOffController,
                          hintText: '${selectedValue}',
                          maxLines: 1,
                          prefixWidget: Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Image.asset(
                              'assets/images/envelope.png',
                              width: 20,
                              height: 20,
                            ),
                          ),
                          fillColor: Colors.white,
                          style: const TextStyle(fontSize: 16),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Minimum Purchase Requirement Container
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Minimum purchase requirement:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildCustomRadioTile(
                          ' No minimum requirements', 'Option 1'),
                      const SizedBox(height: 10),
                      _buildCustomRadioTile(
                          ' Minimum purchase amount (₹)', 'Option 2'),
                      const SizedBox(height: 10),
                      if (selectedOption == 'Option 2')
                        CustomTextField(
                          controller: purchaseValueController,
                          hintText: 'Minimum purchase value',
                          maxLines: 1,
                          prefixWidget: Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Image.asset(
                              'assets/images/envelope.png',
                              width: 20,
                              height: 20,
                            ),
                          ),
                          fillColor: Colors.white,
                          style: const TextStyle(fontSize: 16),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Maximum Discount Uses Container
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Maximum discount uses',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ..._selectedOptions.keys.map((option) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CustomCheckbox(
                                    isSelected: _selectedOptions[option]!,
                                    onChanged: (value) =>
                                        _onCheckboxChanged(option, value),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      option,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                              if (option ==
                                      ' Limit number of times this discount can be used in total' &&
                                  _selectedOptions[option] == true)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: CustomTextField(
                                    controller: customLimitController,
                                    hintText: 'Number of times',
                                    maxLines: 1,
                                    prefixWidget: Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: Image.asset(
                                        'assets/images/envelope.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                    fillColor: Colors.white,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('Start Date'),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            // _clearDateTime();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 15,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Clear',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                color: Colors.black, // Set the border color
                                width: 2.0, // Set the border width
                              ),
                              // Do not specify a color or set it to null to avoid filling the container
                            ),
                            child: Row(
                              children: [
                                const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Icon(Icons.calendar_month_outlined)),
                                _buildDateSelector(
                                  date: startDate,
                                  onTap: () => _selectStartDate(context),
                                  placeholder: 'From',
                                ),
                              ],
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                color: Colors.black, // Set the border color
                                width: 2.0, // Set the border width
                              ),
                              // Do not specify a color or set it to null to avoid filling the container
                            ),
                            child: Row(
                              children: [
                                const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Icon(Icons.alarm)),
                                _buildDateSelector(
                                  time: startTime,
                                  onTap: () => _selectStartTime(context),
                                  placeholder: 'Start Time',
                                  isTime: true,
                                ),
                              ],
                            )),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Checkbox(
                        value: isChecked1,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(3), // Set radius to 10
                        ),
                        activeColor: Colors.green, // Green color when selected
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked1 = value ?? false;
                          });
                        },
                      ),
                      const Text('Set end date'),
                    ]),
                    const SizedBox(
                      height: 10,
                    ),
                    if (isChecked1)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          // const Icon(Icons.alarm),
                          Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                  color: Colors.black, // Set the border color
                                  width: 2.0, // Set the border width
                                ),
                                // Do not specify a color or set it to null to avoid filling the container
                              ),
                              child: Row(
                                children: [
                                  const Padding(
                                      padding: EdgeInsets.all(10),
                                      child:
                                          Icon(Icons.calendar_month_outlined)),
                                  _buildDateSelector(
                                    date: endDate,
                                    onTap: () => _selectEndDate(context),
                                    placeholder: 'To',
                                  ),
                                ],
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                  color: Colors.black, // Set the border color
                                  width: 2.0, // Set the border width
                                ),
                                // Do not specify a color or set it to null to avoid filling the container
                              ),
                              child: Row(
                                children: [
                                  const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(Icons.alarm)),
                                  _buildDateSelector(
                                    time: endTime,
                                    onTap: () => _selectEndTime(context),
                                    placeholder: 'End Time',
                                    isTime: true,
                                  ),
                                ],
                              )),
                        ],
                      ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              // Create Coupon Button
              ElevatedButton(
                onPressed: _saveCoupon,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Create Coupon',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
