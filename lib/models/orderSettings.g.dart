// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orderSettings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderSettingsAdapter extends TypeAdapter<OrderSettings> {
  @override
  final int typeId = 21;

  @override
  OrderSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderSettings(
      isOrderAcceptanceEnabled: fields[0] as bool,
      isNotificationEnabled: fields[1] as bool,
      isAutoAcceptEnabled: fields[2] as bool,
      isOrderAcceptEnabled: fields[3] as bool,
      isOrderConfirmationEnabled: fields[4] as bool,
      isWhatsAppUpdatesEnabled: fields[5] as bool,
      isOrderCancellationAllowed: fields[6] as bool,
      selectedDeliveryMode: fields[7] as String,
      selectedPaymentType: fields[8] as String,
      cancellationPolicy: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OrderSettings obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.isOrderAcceptanceEnabled)
      ..writeByte(1)
      ..write(obj.isNotificationEnabled)
      ..writeByte(2)
      ..write(obj.isAutoAcceptEnabled)
      ..writeByte(3)
      ..write(obj.isOrderAcceptEnabled)
      ..writeByte(4)
      ..write(obj.isOrderConfirmationEnabled)
      ..writeByte(5)
      ..write(obj.isWhatsAppUpdatesEnabled)
      ..writeByte(6)
      ..write(obj.isOrderCancellationAllowed)
      ..writeByte(7)
      ..write(obj.selectedDeliveryMode)
      ..writeByte(8)
      ..write(obj.selectedPaymentType)
      ..writeByte(9)
      ..write(obj.cancellationPolicy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
