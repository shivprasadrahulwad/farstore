import 'dart:convert';

import 'package:farstore/constants/global_variables.dart';
import 'package:farstore/constants/utils.dart';
import 'package:farstore/features/admin/orders/order_cancellation_policy.dart';
import 'package:farstore/models/orderSettings.dart';
import 'package:farstore/providers/admin_provider.dart';
import 'package:farstore/widgets/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class OrderSettingsScreen extends StatefulWidget {
  final Function(Map<String, dynamic>)? onSave;

  const OrderSettingsScreen({Key? key, this.onSave}) : super(key: key);

  @override
  _OrderSettingsScreenState createState() => _OrderSettingsScreenState();
}

class _OrderSettingsScreenState extends State<OrderSettingsScreen> {
  late Box<OrderSettings> orderSettingsBox;
  late OrderSettings _settings;

  // Toggle Switches
  bool _isOrderAcceptanceEnabled = true;
  bool _isNotificationEnabled = false;
  bool _isAutoAcceptEnabled = false;
  bool _isOrderAcceptEnabled = false;
  bool _isOrderConfirmationEnabled = false;
  bool _isWhatsAppUpdatesEnabled = false;
  bool _isOrderCancellationAllowed = false;
  String _cancellationPolicy = '';

  // Delivery Mode
  String _selectedDeliveryMode = 'Standard';
  String _selectedPaymentType = 'Cash (COD)';

  // Return & Cancellation
  final TextEditingController _cancellationTimeLimitController =
      TextEditingController();
  final TextEditingController _returnPolicyDurationController =
      TextEditingController();
  final TextEditingController _orderLimitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    orderSettingsBox = Hive.box<OrderSettings>('orderSettings');
    // Get existing settings or create new ones
    _settings = orderSettingsBox.get('currentSettings') ?? OrderSettings();

    // Update state with stored values
    setState(() {
      _isOrderAcceptanceEnabled = _settings.isOrderAcceptanceEnabled;
      _isNotificationEnabled = _settings.isNotificationEnabled;
      _isAutoAcceptEnabled = _settings.isAutoAcceptEnabled;
      _isOrderAcceptEnabled = _settings.isOrderAcceptEnabled;
      _isOrderConfirmationEnabled = _settings.isOrderConfirmationEnabled;
      _isWhatsAppUpdatesEnabled = _settings.isWhatsAppUpdatesEnabled;
      _isOrderCancellationAllowed = _settings.isOrderCancellationAllowed;
      _selectedDeliveryMode = _settings.selectedDeliveryMode;
      _selectedPaymentType = _settings.selectedPaymentType;
      _cancellationPolicy = _settings.cancellationPolicy!;
    });
  }

  Future<void> _saveSettings() async {
    // Validate cancellation policy when order cancellation is allowed
    if (_isOrderCancellationAllowed &&
        (_cancellationPolicy == null || _cancellationPolicy.trim().isEmpty)) {
      // Show a validation error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Validation Error'),
            content: const Text(
                'Please add a cancellation policy when order cancellation is enabled.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return; // Stop further execution
    }

    // Create settings object with current state values
    OrderSettings settings = OrderSettings(
      isOrderAcceptanceEnabled: _isOrderAcceptanceEnabled,
      isNotificationEnabled: _isNotificationEnabled,
      isAutoAcceptEnabled: _isAutoAcceptEnabled,
      isOrderAcceptEnabled: _isOrderAcceptEnabled,
      isOrderConfirmationEnabled: _isOrderConfirmationEnabled,
      isWhatsAppUpdatesEnabled: _isWhatsAppUpdatesEnabled,
      isOrderCancellationAllowed: _isOrderCancellationAllowed,
      selectedDeliveryMode: _selectedDeliveryMode,
      selectedPaymentType: _selectedPaymentType,
      cancellationPolicy: _cancellationPolicy,
    );

    // Save to Hive
    await orderSettingsBox.put('currentSettings', settings);

    // Update settings on server
    await _updateOrderSettingsOnServer(settings);

    // Call onSave callback if provided
    if (widget.onSave != null) {
      widget.onSave!(settings.toMap());
    }

    // Navigate back
    Navigator.of(context).pop();
  }

  Future<void> _updateOrderSettingsOnServer(OrderSettings settings) async {
    try {
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);

      // Convert settings to map using the toMap() method
      final updateData = {'orderSettings': settings.toMap()};

      final response = await http.post(
        Uri.parse('$uri/api/admin/update-order-settings'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': adminProvider.admin.token,
        },
        body: jsonEncode(updateData),
      );

      print('Server Response: ${response.body}'); // Debugging
      print('Sent Data: $updateData'); // Debugging

      if (response.statusCode == 200) {
        showSnackBar(context, 'Order settings updated successfully!');
      } else {
        throw Exception(
            'Failed to update order settings. Status: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      print('Error in updateOrderSettings: $e');
      showSnackBar(context, 'Error updating order settings: ${e.toString()}');
    }
  }

  @override
  void dispose() {
    _cancellationTimeLimitController.dispose();
    _returnPolicyDurationController.dispose();
    _orderLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (Builder) => NavigationMenu()));
          },
        ),
        title: const Text(
          'Orders Setting',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ORDER SETTINGS',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                ),
                _buildSettingRow(
                    'Accept orders',
                    'Accept incoming orders',
                    _isAutoAcceptEnabled,
                    (value) => setState(() => _isAutoAcceptEnabled = value),
                    Icons.info_outline,
                    GlobalVariables.greyBlueBackgroundColor,
                    GlobalVariables.greyBlueColor),
                const SizedBox(height: 16),
                _buildSettingRow(
                    'Auto accept',
                    'Automatically accept incoming orders',
                    _isOrderAcceptEnabled,
                    (value) => setState(() => _isOrderAcceptEnabled = value),
                    Icons.info_outline,
                    GlobalVariables.greyBlueBackgroundColor,
                    GlobalVariables.greyBlueColor),
                const SizedBox(height: 16),
                _buildSettingRow(
                    'Order Notifications',
                    'Receive notifications for new orders',
                    _isNotificationEnabled,
                    (value) => setState(() => _isNotificationEnabled = value),
                    Icons.info_outline,
                    GlobalVariables.greyBlueBackgroundColor,
                    GlobalVariables.greyBlueColor),
                const SizedBox(height: 16),
                const SizedBox(height: 20),

                // Delivery Mode
                _buildDeliveryModeSection(),
                const SizedBox(height: 20),

                // Customer Communication Section
                _buildCustomerCommunicationSection(),
                const SizedBox(height: 16),

                // Return & Cancellation Policies
                _buildReturnCancellationSection(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _saveSettings,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Save Settings',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeliveryModeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Delivery mode',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildDeliveryModeContainer(
                'Standard', _selectedDeliveryMode == 'Standard'),
            const SizedBox(width: 16),
            _buildDeliveryModeContainer(
                'Express', _selectedDeliveryMode == 'Express'),
            const SizedBox(width: 16),
            _buildDeliveryModeContainer(
                'Both', _selectedDeliveryMode == 'Both'),
          ],
        ),
        const SizedBox(height: 30),
        const Text(
          'Payment type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildPaymentTypeContainer(
                'Cash (COD)', _selectedPaymentType == 'Cash (COD)'),
            const SizedBox(width: 16),
            _buildPaymentTypeContainer(
                'Online', _selectedPaymentType == 'Online'),
            const SizedBox(width: 16),
            _buildPaymentTypeContainer('Both', _selectedPaymentType == 'Both'),
          ],
        ),
      ],
    );
  }

  Widget _buildDeliveryModeContainer(String label, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedDeliveryMode = label;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green.shade100 : Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isSelected ? Colors.green : Colors.green.shade300,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color:
                    isSelected ? Colors.green.shade800 : Colors.green.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentTypeContainer(String label, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPaymentType = label;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green.shade100 : Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isSelected ? Colors.green : Colors.green.shade300,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color:
                    isSelected ? Colors.green.shade800 : Colors.green.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerCommunicationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        const Text(
          'CUSTOMER COMMUNICATION',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const Divider(
          color: Colors.grey,
        ),
        // const SizedBox(height: 10),
        _buildSettingRow(
            'Order confirmation SMS',
            'Send Email/SMS confirmation',
            _isOrderConfirmationEnabled,
            (value) => setState(() => _isOrderConfirmationEnabled = value),
            Icons.info_outline,
            GlobalVariables.greyBlueBackgroundColor,
            GlobalVariables.greyBlueColor),
        const SizedBox(height: 10),
        _buildSettingRow(
            'WhatsApp updates',
            'Order update on Whatsapp',
            _isWhatsAppUpdatesEnabled,
            (value) => setState(() => _isWhatsAppUpdatesEnabled = value),
            Icons.info_outline,
            GlobalVariables.greyBlueBackgroundColor,
            GlobalVariables.greyBlueColor),
      ],
    );
  }

  Widget _buildReturnCancellationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 30,
        ),
        const Text(
          'Return & Cancellation Policies',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const Divider(
          color: Colors.grey,
        ),
        _buildSettingRow(
            'Allow order cancellation',
            'Enable order cancellation',
            _isOrderCancellationAllowed,
            (value) => setState(() => _isOrderCancellationAllowed = value),
            Icons.info_outline,
            GlobalVariables.greyBlueBackgroundColor,
            GlobalVariables.greyBlueColor),
        const SizedBox(height: 20),
        if (_isOrderCancellationAllowed) ...[
          Row(
            children: [
              const Text('Add cancellation policy'),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const OrderCancellationPolicyScreen(),
                    ),
                  ).then((policyText) {
                    if (policyText != null) {
                      // Use the returned policy text
                      print('Received policy: $policyText');
                    }
                  });
                },
                child: const Icon(
                  Icons.add,
                  color: GlobalVariables.greenColor,
                ),
              )
            ],
          )
        ],
      ],
    );
  }

  Widget _buildSettingRow(
      String title,
      String subtitle,
      bool value,
      Function(bool) onChanged,
      IconData? icon,
      Color? iconBackgroundColor,
      Color? iconColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (icon != null)
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconBackgroundColor ??
                  GlobalVariables.greyBlueBackgroundColor,
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              color: iconColor ?? GlobalVariables.greyBlueColor,
              size: 20,
            ),
          ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            onChanged(!value);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 47.0,
            height: 25.0,
            padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: value ? Colors.green : Colors.grey[300],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  left: value ? 24.0 : 4.0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 15.0,
                    height: 15.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: value ? Colors.white : Colors.white,
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
        )
      ],
    );
  }
}

extension OrderSettingsExtension on OrderSettings {
  OrderSettings copyWith({
    String? cancellationPolicy,
    bool? isOrderAcceptanceEnabled,
    bool? isNotificationEnabled,
    bool? isAutoAcceptEnabled,
    bool? isOrderAcceptEnabled,
    bool? isOrderConfirmationEnabled,
    bool? isWhatsAppUpdatesEnabled,
    bool? isOrderCancellationAllowed,
    String? selectedDeliveryMode,
    String? selectedPaymentType,
  }) {
    return OrderSettings(
      cancellationPolicy: cancellationPolicy ?? this.cancellationPolicy,
      isOrderAcceptanceEnabled:
          isOrderAcceptanceEnabled ?? this.isOrderAcceptanceEnabled,
      isNotificationEnabled:
          isNotificationEnabled ?? this.isNotificationEnabled,
      isAutoAcceptEnabled: isAutoAcceptEnabled ?? this.isAutoAcceptEnabled,
      isOrderAcceptEnabled: isOrderAcceptEnabled ?? this.isOrderAcceptEnabled,
      isOrderConfirmationEnabled:
          isOrderConfirmationEnabled ?? this.isOrderConfirmationEnabled,
      isWhatsAppUpdatesEnabled:
          isWhatsAppUpdatesEnabled ?? this.isWhatsAppUpdatesEnabled,
      isOrderCancellationAllowed:
          isOrderCancellationAllowed ?? this.isOrderCancellationAllowed,
      selectedDeliveryMode: selectedDeliveryMode ?? this.selectedDeliveryMode,
      selectedPaymentType: selectedPaymentType ?? this.selectedPaymentType,
    );
  }
}
