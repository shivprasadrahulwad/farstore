// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orderHive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderHiveAdapter extends TypeAdapter<OrderHive> {
  @override
  final int typeId = 14;

  @override
  OrderHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderHive(
      orderId: fields[0] as String,
      status: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, OrderHive obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.orderId)
      ..writeByte(1)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
