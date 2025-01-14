import 'package:farstore/constants/global_variables.dart';
import 'package:farstore/features/auth/screens/sample.dart';
import 'package:farstore/models/coupon.dart';
import 'package:farstore/models/toggle_management.dart';
import 'package:farstore/shop_setup/coupon/create_coupon_screen.dart';
import 'package:farstore/widgets/custom_check_box.dart';
import 'package:farstore/widgets/custom_dropdown_field.dart';
import 'package:farstore/widgets/custom_radio_button.dart';
import 'package:farstore/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class CouponScreenResult {
  final List<Coupon> coupons;
  final bool isToggled;

  CouponScreenResult({
    required this.coupons,
    required this.isToggled,
  });
}

class CouponScreen extends StatefulWidget {
  static const String routeName = '/coupon';

  const CouponScreen({Key? key}) : super(key: key);

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  bool isAddingCoupon = false; // Track if user clicked on the add button
  final TextEditingController couponCodeController = TextEditingController();
  final TextEditingController percentOffController = TextEditingController();
  final TextEditingController purchaseValueController = TextEditingController();
  final TextEditingController customLimitController = TextEditingController();
  bool isToggled = false;
  late Box<Coupon> couponBox;
  List<Coupon> coupons = [];
  String selectedValue = 'Percentage';
  String? selectedOption = 'Option 1';
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  DateTime? currentTime;
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool limitText = false;

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

  @override
  void initState() {
    super.initState();
    couponCodeController.text = '';
    percentOffController.text = '';
    customLimitController.text = '0';
    initHive();
  }

  Future<void> initHive() async {
    try {
      // Open the Hive box
      couponBox = await Hive.openBox<Coupon>('coupons');

      // Load existing coupons
      setState(() {
        coupons = couponBox.values.toList();
      });
    } catch (e) {
      print('Error initializing Hive: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error initializing storage: $e')),
      );
    }
  }

  Future<void> loadCouponsAndSettings() async {
    if (mounted) {
      try {
        setState(() {
          // Load coupons from Hive box
          coupons = couponBox.values.toList();
          // Get toggle state from ToggleManager
          isToggled = ToggleManager.getToggleState(ToggleType.coupon);
        });
      } catch (e) {
        print('Error loading coupons: $e');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error loading coupons: $e')));
      }
    }
  }

  Future<void> toggleButton() async {
    try {
      final newValue = !isToggled;
      await ToggleManager.saveToggleState(ToggleType.coupon, newValue);
      setState(() {
        isToggled = newValue;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error saving settings. Please try again.'),
          ),
        );
      }
    }
  }

  Future<void> saveCoupon() async {
    try {
      // Validate required fields
      if (couponCodeController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Coupon code cannot be empty')));
        return;
      }

      final off = double.tryParse(percentOffController.text);
      if (off == null || off <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid percentage off')));
        return;
      }

      // Create the coupon
      // final coupon = Coupon(
      //   couponCode: couponCodeController.text,
      //   off: off,
      //   startDate: startDate,
      //   endDate: endDate,
      //   startTime: startTime,
      //   endTime: endTime,
      //   customLimit: int.tryParse(customLimitController.text) ?? 0,
      //   limit: limitText,
      // );

      // Explicitly open the Hive box
      final couponBox = await Hive.openBox<Coupon>('coupons');

      // Save the coupon
      // await couponBox.add(coupon);
      print('Coupon saved successfully with key: ${couponBox.length - 1}');

      // Refresh the list of coupons
      setState(() {
        coupons = couponBox.values.toList();
        clearAndHideInputs();
      });

      // Optional: Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coupon saved successfully')),
      );
    } catch (e, stackTrace) {
      print('Error saving coupon: $e');
      print('Stacktrace: $stackTrace');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving coupon: $e')),
      );
    }
  }
  // Future<void> saveCoupon(Coupon coupon) async {
  //   await couponBox.add(coupon);
  //   setState(() {
  //     coupons = couponBox.values.toList();
  //     clearAndHideInputs();
  //   });
  // }

  void clearAndHideInputs() {
    couponCodeController.clear();
    percentOffController.clear();
    purchaseValueController.clear();
    customLimitController.clear();
    isAddingCoupon = false;
  }

  Future<void> _clearDateTime() async {
    try {
      setState(() {
        startDate = null;
        endDate = null;
        startTime = null;
        endTime = null;
        isChecked1 = false; // Reset the checkbox
      });
    } catch (e) {
      print('Error clearing date/time: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error clearing schedule: $e')),
        );
      }
    }
  }

  Future<void> deleteCoupon(int index) async {
    final key = couponBox.keyAt(index);
    await couponBox.delete(key);
    setState(() {
      coupons = couponBox.values.toList();
    });
  }

  Future<void> saveToggleState() async {
    await Hive.box('settings').put('couponToggle', isToggled);
  }

  Widget _buildCustomRadioTile(String title, String value) {
    return Row(
      children: [
        CustomRadioButton(
          isSelected: selectedOption == value,
          onChanged: (bool isSelected) {
            setState(() {
              if (isSelected) selectedOption = value;
            });
          },
        ),
        const SizedBox(width: 10), // Space between radio button and text
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
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

  String _formatEndTime(TimeOfDay? time) {
    if (time != null) {
      final hours = time.hour;
      final minutes = time.minute;
      // Format the time to a 12-hour format with AM/PM
      final formattedTime =
          '${hours % 12 == 0 ? 12 : hours % 12}:${minutes.toString().padLeft(2, '0')} ${hours >= 12 ? 'PM' : 'AM'}';
      return formattedTime;
    }
    return ''; // Default text if the time is not set
  }

  @override
  void dispose() {
    couponCodeController.dispose();
    percentOffController.dispose();
    purchaseValueController.dispose();
    customLimitController.dispose();
    couponBox.close();
    super.dispose();
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Coupon',
          style: TextStyle(
              fontFamily: 'Regular',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black),
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
                Row(
                  children: [
                    const Text(
                      "Coupons",
                      style: TextStyle(
                          fontFamily: 'Regular',
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: toggleButton,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 47.0,
                        height: 25.0,
                        padding: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: isToggled ? Colors.green : Colors.grey[300],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 200),
                              left: isToggled ? 24.0 : 4.0,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 15.0,
                                height: 15.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isToggled
                                      ? Colors.white
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                if (!isToggled)
                  const Divider(
                    color: Colors.grey,
                  ),
                if (isToggled)
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Text('ADD COUPONS '),
                        const Divider(
                          color: Colors.grey,
                        ),
                        GestureDetector(
                          onTap: () {
                            // setState(() {
                            //   isAddingCoupon =
                            //       !isAddingCoupon; // Toggle input fields visibility
                            // });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateCouponScreen(),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: GlobalVariables
                                        .greyBlueBackgroundColor),
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.info_outline_rounded,
                                  color: GlobalVariables.greyBlueColor,
                                  size: 15,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "Add coupon code",
                                style: TextStyle(
                                    fontFamily: 'Regular',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.green,
                                  size: 25,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // const SizedBox(height: 20),

                        if (isAddingCoupon)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
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
                                          padding: const EdgeInsets.all(8.0),
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
                                        value:
                                            selectedValue, // Pass the current selected value
                                        items: ['Percentage', 'Fixed Amount'],
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedValue =
                                                newValue!; // Update the selected value in state
                                          });
                                          print('Selected Value: $newValue');
                                        },
                                        placeholderText: 'Select a category',
                                        isEnabled: true,
                                      ),
                                      if (selectedValue == 'Percentage')
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: CustomTextField(
                                            controller: percentOffController,
                                            hintText: '${selectedValue}',
                                            maxLines: 1,
                                            prefixWidget: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Image.asset(
                                                'assets/images/envelope.png',
                                                width: 20,
                                                height: 20,
                                              ),
                                            ),
                                            fillColor: Colors.white,
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      const SizedBox(height: 10),
                                      if (selectedValue == 'Fixed Amount')
                                        CustomTextField(
                                          controller: percentOffController,
                                          hintText: '${selectedValue}',
                                          maxLines: 1,
                                          prefixWidget: Padding(
                                            padding: const EdgeInsets.all(8.0),
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
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Minimum purchase requirement:',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      _buildCustomRadioTile(
                                          ' No minimum requirements',
                                          'Option 1'),
                                      const SizedBox(
                                          height:
                                              10), // Adjust spacing between items
                                      _buildCustomRadioTile(
                                          ' Minimum purchase amount (₹)',
                                          'Option 2'),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      if (selectedOption == 'Option 2')
                                        CustomTextField(
                                          controller: purchaseValueController,
                                          hintText: 'Minimum purchase value',
                                          maxLines: 1,
                                          prefixWidget: Padding(
                                            padding: const EdgeInsets.all(8.0),
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
                              const SizedBox(
                                height: 30,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Maximum discount uses',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 20),
                                      ..._selectedOptions.keys.map((option) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  CustomCheckbox(
                                                    isSelected:
                                                        _selectedOptions[
                                                            option]!,
                                                    onChanged: (value) =>
                                                        _onCheckboxChanged(
                                                            option, value),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Text(
                                                      option,
                                                      style: const TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              if (option ==
                                                      ' Limit number of times this discount can be used in total' &&
                                                  _selectedOptions[option] ==
                                                      true)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: CustomTextField(
                                                    controller:
                                                        customLimitController,
                                                    hintText: 'Number of times',
                                                    maxLines: 1,
                                                    prefixWidget: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Image.asset(
                                                        'assets/images/envelope.png',
                                                        width: 20,
                                                        height: 20,
                                                      ),
                                                    ),
                                                    fillColor: Colors.white,
                                                    style: const TextStyle(
                                                        fontSize: 16),
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
                              const SizedBox(
                                height: 30,
                              ),
                              const Text("FREE DELIVERY SCHEDULE(Optinal)",
                                  style: TextStyle(
                                      fontFamily: 'Regular',
                                      fontSize: 14,
                                      color: GlobalVariables.greyBlueColor,
                                      fontWeight: FontWeight.bold)),
                              const Divider(color: Colors.grey),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
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
                                            _clearDateTime();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.red.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(15),
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
                                                      color: Colors.red,
                                                      fontSize: 12),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              border: Border.all(
                                                color: Colors
                                                    .black, // Set the border color
                                                width:
                                                    2.0, // Set the border width
                                              ),
                                              // Do not specify a color or set it to null to avoid filling the container
                                            ),
                                            child: Row(
                                              children: [
                                                const Padding(
                                                    padding: EdgeInsets.all(10),
                                                    child: Icon(Icons
                                                        .calendar_month_outlined)),
                                                _buildDateSelector(
                                                  date: startDate,
                                                  onTap: () =>
                                                      _selectStartDate(context),
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
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              border: Border.all(
                                                color: Colors
                                                    .black, // Set the border color
                                                width:
                                                    2.0, // Set the border width
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
                                                  onTap: () =>
                                                      _selectStartTime(context),
                                                  placeholder: 'Start Time',
                                                  isTime: true,
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Checkbox(
                                            value: isChecked1,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      3), // Set radius to 10
                                            ),
                                            activeColor: Colors
                                                .green, // Green color when selected
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          // const Icon(Icons.alarm),
                                          Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                                border: Border.all(
                                                  color: Colors
                                                      .black, // Set the border color
                                                  width:
                                                      2.0, // Set the border width
                                                ),
                                                // Do not specify a color or set it to null to avoid filling the container
                                              ),
                                              child: Row(
                                                children: [
                                                  const Padding(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: Icon(Icons
                                                          .calendar_month_outlined)),
                                                  _buildDateSelector(
                                                    date: endDate,
                                                    onTap: () =>
                                                        _selectEndDate(context),
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
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                                border: Border.all(
                                                  color: Colors
                                                      .black, // Set the border color
                                                  width:
                                                      2.0, // Set the border width
                                                ),
                                                // Do not specify a color or set it to null to avoid filling the container
                                              ),
                                              child: Row(
                                                children: [
                                                  const Padding(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: Icon(Icons.alarm)),
                                                  _buildDateSelector(
                                                    time: endTime,
                                                    onTap: () =>
                                                        _selectEndTime(context),
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
                              const SizedBox(height: 20),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (coupons.length >= 6) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Only 6 coupons can be added...'),
                                        ),
                                      );
                                      return;
                                    }

                                    print(
                                        'Debug: About to call saveCoupon'); // Add this debug print
                                    await saveCoupon();
                                    print(
                                        'Debug: After calling saveCoupon'); // Add this debug print
                                  },
                                  child: const Text('Add Coupon'),
                                ),
                              ),
                            ],
                          ),

                        const SizedBox(height: 20),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: coupons.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: GlobalVariables
                                                .lightBlueTextColor, // Light blue color
                                            borderRadius: BorderRadius.circular(
                                                10), // Rounded corners
                                          ),
                                          padding: const EdgeInsets.all(
                                              10), // Optional: Add padding around the text and divider
                                          child: Column(
                                            children: [
                                              Center(
                                                child: Text(
                                                  '${coupons[index].couponCode.toUpperCase()}',
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'SemiBold',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.discount),
                                              Text(
                                                '  ${coupons[index].off.toInt()}%',
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'Regular',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const Spacer(),
                                              const Text(
                                                'Above: ',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Regular',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                '₹${coupons[index].price!.toInt()}',
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'Regular',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              IconButton(
                                                icon: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.red[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  child: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                    size: 20,
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  await deleteCoupon(index);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            'Coupon deleted. (${coupons.length}/6 remaining)')),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        if (isAddingCoupon)
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                            ],
                          ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(
                              context,
                              CouponScreenResult(
                                coupons: coupons,
                                isToggled: isToggled,
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
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
                      ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
