import 'package:hive/hive.dart';

part 'orderSettings.g.dart';

@HiveType(typeId: 21)
class OrderSettings extends HiveObject {
  @HiveField(0)
  bool isOrderAcceptanceEnabled;

  @HiveField(1)
  bool isNotificationEnabled;

  @HiveField(2)
  bool isAutoAcceptEnabled;

  @HiveField(3)
  bool isOrderAcceptEnabled;

  @HiveField(4)
  bool isOrderConfirmationEnabled;

  @HiveField(5)
  bool isWhatsAppUpdatesEnabled;

  @HiveField(6)
  bool isOrderCancellationAllowed;

  @HiveField(7)
  String selectedDeliveryMode;

  @HiveField(8)
  String selectedPaymentType;

  @HiveField(9)
  String? cancellationPolicy;

  OrderSettings({
    this.isOrderAcceptanceEnabled = true,
    this.isNotificationEnabled = false,
    this.isAutoAcceptEnabled = false,
    this.isOrderAcceptEnabled = false,
    this.isOrderConfirmationEnabled = false,
    this.isWhatsAppUpdatesEnabled = false,
    this.isOrderCancellationAllowed = false,
    this.selectedDeliveryMode = 'Standard',
    this.selectedPaymentType = 'Cash (COD)',
    this.cancellationPolicy,
  });

  // Helper method to create OrderSettings from a Map
  factory OrderSettings.fromMap(Map<String, dynamic> map) {
    return OrderSettings(
      isOrderAcceptanceEnabled: map['orderAcceptanceEnabled'] ?? true,
      isNotificationEnabled: map['notificationsEnabled'] ?? false,
      isAutoAcceptEnabled: map['autoAcceptEnabled'] ?? false,
      isOrderAcceptEnabled: map['orderAcceptEnabled'] ?? false,
      isOrderConfirmationEnabled: map['orderConfirmationEnabled'] ?? false,
      isWhatsAppUpdatesEnabled: map['whatsAppUpdatesEnabled'] ?? false,
      isOrderCancellationAllowed: map['orderCancellationAllowed'] ?? false,
      selectedDeliveryMode: map['deliveryMode'] ?? 'Standard',
      selectedPaymentType: map['paymentType'] ?? 'Cash On Delivery (COD)',
      cancellationPolicy: map['cancellationPolicy'],
    );
  }

  Map<String, dynamic> toMap() {
  return {
    'orderAcceptanceEnabled': isOrderAcceptanceEnabled,
    'notificationsEnabled': isNotificationEnabled,
    'autoAcceptEnabled': isAutoAcceptEnabled,
    'orderAcceptEnabled': isOrderAcceptEnabled,
    'orderConfirmationEnabled': isOrderConfirmationEnabled,
    'whatsAppUpdatesEnabled': isWhatsAppUpdatesEnabled,
    'orderCancellationAllowed': isOrderCancellationAllowed,
    'deliveryMode': selectedDeliveryMode,
    'paymentType': selectedPaymentType,
    'cancellationPolicy': cancellationPolicy,
  };
}

  OrderSettings copyWith({
    bool? isOrderAcceptanceEnabled,
    bool? isNotificationEnabled,
    bool? isAutoAcceptEnabled,
    bool? isOrderAcceptEnabled,
    bool? isOrderConfirmationEnabled,
    bool? isWhatsAppUpdatesEnabled,
    bool? isOrderCancellationAllowed,
    String? selectedDeliveryMode,
    String? selectedPaymentType,
    String? cancellationPolicy,
  }) {
    return OrderSettings(
      isOrderAcceptanceEnabled: isOrderAcceptanceEnabled ?? this.isOrderAcceptanceEnabled,
      isNotificationEnabled: isNotificationEnabled ?? this.isNotificationEnabled,
      isAutoAcceptEnabled: isAutoAcceptEnabled ?? this.isAutoAcceptEnabled,
      isOrderAcceptEnabled: isOrderAcceptEnabled ?? this.isOrderAcceptEnabled,
      isOrderConfirmationEnabled: isOrderConfirmationEnabled ?? this.isOrderConfirmationEnabled,
      isWhatsAppUpdatesEnabled: isWhatsAppUpdatesEnabled ?? this.isWhatsAppUpdatesEnabled,
      isOrderCancellationAllowed: isOrderCancellationAllowed ?? this.isOrderCancellationAllowed,
      selectedDeliveryMode: selectedDeliveryMode ?? this.selectedDeliveryMode,
      selectedPaymentType: selectedPaymentType ?? this.selectedPaymentType,
      cancellationPolicy: cancellationPolicy ?? this.cancellationPolicy,
    );
  }

}