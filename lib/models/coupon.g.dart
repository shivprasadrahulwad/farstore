// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CouponAdapter extends TypeAdapter<Coupon> {
  @override
  final int typeId = 12;

  @override
  Coupon read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Coupon(
      couponCode: fields[0] as String,
      off: fields[1] as double,
      price: fields[2] as double?,
      customLimit: fields[3] as int?,
      limit: fields[4] as bool?,
      startDate: fields[5] as String?,
      endDate: fields[6] as String?,
      startTimeMinutes: fields[7] as int?,
      endTimeMinutes: fields[8] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Coupon obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.couponCode)
      ..writeByte(1)
      ..write(obj.off)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.customLimit)
      ..writeByte(4)
      ..write(obj.limit)
      ..writeByte(5)
      ..write(obj.startDate)
      ..writeByte(6)
      ..write(obj.endDate)
      ..writeByte(7)
      ..write(obj.startTimeMinutes)
      ..writeByte(8)
      ..write(obj.endTimeMinutes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CouponAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
