// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'charges.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChargesAdapter extends TypeAdapter<Charges> {
  @override
  final int typeId = 8;

  @override
  Charges read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Charges(
      isDeliveryChargesEnabled: fields[0] as bool,
      deliveryCharges: fields[1] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, Charges obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.isDeliveryChargesEnabled)
      ..writeByte(1)
      ..write(obj.deliveryCharges)
      ..writeByte(2)
      ..write(obj.startDateStr)
      ..writeByte(3)
      ..write(obj.endDateStr)
      ..writeByte(4)
      ..write(obj.startTimeMinutes)
      ..writeByte(5)
      ..write(obj.endTimeMinutes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChargesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
