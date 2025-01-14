// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deliveryType.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeliveryTypeAdapter extends TypeAdapter<DeliveryType> {
  @override
  final int typeId = 15;

  @override
  DeliveryType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeliveryType(
      name: fields[0] as String,
      id: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DeliveryType obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliveryTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
