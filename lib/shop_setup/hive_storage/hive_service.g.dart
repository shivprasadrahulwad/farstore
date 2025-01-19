// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_service.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShopInfoHiveAdapter extends TypeAdapter<ShopInfoHive> {
  @override
  final int typeId = 0;

  @override
  ShopInfoHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShopInfoHive(
      categories: (fields[0] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      coupon: (fields[1] as Map).cast<String, dynamic>(),
      offerImages: (fields[2] as Map).cast<String, dynamic>(),
      offerDes: (fields[3] as Map?)?.cast<String, dynamic>(),
      offerTime: fields[4] as DateTime,
      socialLinks: (fields[5] as Map).cast<String, String>(),
      delPrice: fields[6] as int,
      shopName: fields[7] as String,
      number: fields[8] as String,
      address: fields[9] as String,
      shopCode: fields[10] as String,
      lastUpdated: fields[11] as DateTime,
      charges: (fields[12] as Map).cast<String, dynamic>(),
      time: fields[13] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ShopInfoHive obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.categories)
      ..writeByte(1)
      ..write(obj.coupon)
      ..writeByte(2)
      ..write(obj.offerImages)
      ..writeByte(3)
      ..write(obj.offerDes)
      ..writeByte(4)
      ..write(obj.offerTime)
      ..writeByte(5)
      ..write(obj.socialLinks)
      ..writeByte(6)
      ..write(obj.delPrice)
      ..writeByte(7)
      ..write(obj.shopName)
      ..writeByte(8)
      ..write(obj.number)
      ..writeByte(9)
      ..write(obj.address)
      ..writeByte(10)
      ..write(obj.shopCode)
      ..writeByte(11)
      ..write(obj.lastUpdated)
      ..writeByte(12)
      ..write(obj.charges)
      ..writeByte(13)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopInfoHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QueueItemAdapter extends TypeAdapter<QueueItem> {
  @override
  final int typeId = 1;

  @override
  QueueItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QueueItem(
      operation: fields[0] as String,
      data: (fields[1] as Map).cast<String, dynamic>(),
      timestamp: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, QueueItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.operation)
      ..writeByte(1)
      ..write(obj.data)
      ..writeByte(2)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueueItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
