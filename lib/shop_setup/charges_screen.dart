import 'package:farstore/constants/global_variables.dart';
import 'package:farstore/models/charges.dart';
import 'package:farstore/models/toggle_management.dart';
import 'package:farstore/widgets/dash_line.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class ChargesData {
  final bool isDeliveryChargesEnabled;
  final double? deliveryCharges;
  final DateTime? startDate;
  final DateTime? endDate;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;

  ChargesData({
    required this.isDeliveryChargesEnabled,
    this.deliveryCharges,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
  });
}

class ChargesScreen extends StatefulWidget {
  static const String routeName = '/charges-screen';
  const ChargesScreen({Key? key}) : super(key: key);

  @override
  State<ChargesScreen> createState() => _ChargesScreenState();
}

class _ChargesScreenState extends State<ChargesScreen> {
  final TextEditingController chargesController = TextEditingController();
  final TextEditingController couponCodeController = TextEditingController();
  final TextEditingController percentOffController = TextEditingController();
  final TextEditingController purchaseValueController = TextEditingController();
  bool isSwitched = false;
  bool isToggled = false;
  String? error;
  bool isLoading = false;
  bool isChecked1 = false;
  bool isChecked2 = false;

  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  DateTime? currentTime;

  @override
  void initState() {
    super.initState();
    currentTime = DateTime.now();
    _loadChargesData();
  }

  Future<void> _initializeScreen() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      // Initialize Hive box if not already done
      if (!Hive.isBoxOpen(Charges.boxName)) {
        await Hive.openBox<Charges>(Charges.boxName);
      }

      // Load toggle state
      await initToggle();

      // Load charges data
      await _loadChargesData();
    } catch (e) {
      print('Error initializing screen: $e');
      setState(() {
        error = 'Failed to initialize. Please restart the app.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadChargesData() async {
    try {
      setState(() => isLoading = true);

      // Load toggle state
      await initToggle();

      final charges = await Charges.getFromHive();
      if (charges != null && mounted) {
        setState(() {
          isToggled = charges.isDeliveryChargesEnabled;
          if (isToggled) {
            if (charges.deliveryCharges != null) {
              chargesController.text = charges.deliveryCharges.toString();
            }
            startDate = charges.startDate;
            endDate = charges.endDate;
            startTime = charges.startTime;
            endTime = charges.endTime;
          }
        });
      }
    } catch (e) {
      print('Error loading charges: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading charges: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _saveAndReturn() async {
    try {
      if (isToggled && chargesController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter delivery charges')),
        );
        return;
      }

      if (startDate != null && startTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Please select start time since start date is selected')),
        );
        return;
      }

      if (endDate != null && endTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Please select end time since end date is selected')),
        );
        return;
      }

      // Save to Hive
      await Charges.saveToHive(
        isToggled,
        isToggled ? double.tryParse(chargesController.text) : null,
        startDate,
        endDate,
        startTime,
        endTime,
      );

      // Create ChargesData for backward compatibility
      final chargesData = ChargesData(
        isDeliveryChargesEnabled: isToggled,
        deliveryCharges:
            isToggled ? double.tryParse(chargesController.text) : null,
        startDate: startDate,
        endDate: endDate,
        startTime: startTime,
        endTime: endTime,
      );

      if (mounted) {
        Navigator.pop(context, chargesData);
      }
    } catch (e) {
      print('Error saving charges: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving charges: $e')),
        );
      }
    }
  }

  Future<void> initToggle() async {
    try {
      await ToggleManager.init();
      if (mounted) {
        setState(() {
          isToggled = ToggleManager.getToggleState(ToggleType.charges);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Error initializing settings. Please restart the app.'),
          ),
        );
      }
    }
  }

  // Add this new function to clear the dates and times
Future<void> _clearDateTime() async {
  try {
    // Clear the UI state
    setState(() {
      startDate = null;
      endDate = null;
      startTime = null;
      endTime = null;
      isChecked1 = false; // Reset the checkbox as well
    });

    // Save the cleared state to Hive
    await Charges.saveToHive(
      isToggled,
      isToggled ? double.tryParse(chargesController.text) : null,
      null, // cleared startDate
      null, // cleared endDate
      null, // cleared startTime
      null, // cleared endTime
    );
  } catch (e) {
    print('Error clearing date/time: $e');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error clearing schedule: $e')),
      );
    }
  }
}

  Future<void> toggleButton() async {
    try {
      final newValue = !isToggled;
      await ToggleManager.saveToggleState(ToggleType.charges, newValue);

      // Instead of deleting data, we just update the UI state
      setState(() {
        isToggled = newValue;
        if (!newValue) {
          // Clear UI fields without deleting Hive data
          chargesController.clear();
          startDate = null;
          endDate = null;
          startTime = null;
          endTime = null;
        } else {
          // If turning on, reload the data from Hive
          _loadChargesData();
        }
      });
    } catch (e) {
      print('Error toggling: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving settings: $e')),
        );
      }
    }
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

  double _calculateProgress() {
    if (startDate != null &&
        endDate != null &&
        startTime != null &&
        endTime != null) {
      // Combine the selected date and time for start and end
      final start = DateTime(startDate!.year, startDate!.month, startDate!.day,
          startTime!.hour, startTime!.minute);
      final end = DateTime(endDate!.year, endDate!.month, endDate!.day,
          endTime!.hour, endTime!.minute);

      final currentTime = DateTime.now();

      // Calculate the total duration and the elapsed time
      final totalDuration = end.difference(start);
      final elapsedDuration = currentTime.isBefore(start)
          ? Duration.zero
          : currentTime.isAfter(end)
              ? totalDuration
              : currentTime.difference(start);
      return elapsedDuration.inMilliseconds / totalDuration.inMilliseconds;
    }
    return 0.0;
  }

  String _formatDate(DateTime? date, String placeholder) {
    return date != null ? DateFormat('dd MMM, EEE').format(date) : placeholder;
  }

  String _formatTime(TimeOfDay? time, String placeholder) {
    return time != null ? time.format(context) : placeholder;
  }

  Duration? _calculateTimeDifference(DateTime startDate, DateTime endDate) {
    if (startDate != null && endDate != null) {
      return endDate.difference(startDate);
    }
    return null;
  }

  int calculateDaysDifference(DateTime startDate, DateTime endDate) {
    Duration difference = endDate.difference(startDate);
    return difference.inDays.abs();
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
    final progress = _calculateProgress();
    // final timeDifference = _calculateTimeDifference();
    Duration? timeDifference;
    int? numberOfDays;
    if (startDate != null && endDate != null) {
      numberOfDays = calculateDaysDifference(startDate!, endDate!);
    }

    if (startDate != null && endDate != null) {
      timeDifference = _calculateTimeDifference(startDate!, endDate!);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: _saveAndReturn,
            child: const Text('Save',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
        title: const Text(
          'Charges',
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
                      "Delivery charges",
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
                const SizedBox(height: 50),
                if (!isToggled)
                  const Divider(
                    color: Colors.grey,
                  ),
                if (isToggled)
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("DELIVERY CHARGE",
                            style: TextStyle(
                                fontFamily: 'Regular',
                                fontSize: 14,
                                color: GlobalVariables.greyBlueColor,
                                fontWeight: FontWeight.bold)),
                        const Divider(color: Colors.grey),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 10,top: 10),
                            child: TextField(
                              controller: chargesController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: '₹ Add charges',
                                prefixText: '  ₹ ',
                                prefixStyle: TextStyle(color: Colors.black),
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
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
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        border: Border.all(
                                          color: Colors
                                              .black, // Set the border color
                                          width: 2.0, // Set the border width
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
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        border: Border.all(
                                          color: Colors
                                              .black, // Set the border color
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                      value: isChecked1,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    // const Icon(Icons.alarm),
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          border: Border.all(
                                            color: Colors
                                                .black, // Set the border color
                                            width: 2.0, // Set the border width
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
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          border: Border.all(
                                            color: Colors
                                                .black, // Set the border color
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
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: const BoxDecoration(
                                color: Colors.black, // Black background
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: const Icon(Icons.alarm,
                                            color: Colors.black),
                                      ),
                                      const SizedBox(width: 10),
                                      const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Free Delivery',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            'No Charges',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: const BoxDecoration(
                                    color: Colors.grey, // Background color
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(
                                          15), // Bottom left corner radius
                                      bottomRight: Radius.circular(
                                          15), // Bottom right corner radius
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Remaining Time',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: LinearProgressIndicator(
                                              value:
                                                  progress, // This is the progress value between 0.0 and 1.0
                                              color: Colors.blue,
                                              backgroundColor: Colors.yellow,
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Text('${_formatEndTime(endTime)}',
                                              style: const TextStyle(
                                                  fontSize: 14)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        'Ends in 43 min',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
