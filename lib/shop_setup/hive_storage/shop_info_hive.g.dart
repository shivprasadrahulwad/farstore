// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_info_hive.dart';

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
      shopName: fields[0] as String,
      number: fields[1] as String,
      address: fields[2] as String,
      shopCode: fields[3] as String,
      categories: (fields[4] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      delPrice: fields[5] as double,
      coupon: (fields[6] as Map?)?.cast<String, dynamic>(),
      offerImages: (fields[7] as Map?)?.cast<String, dynamic>(),
      offerDes: (fields[8] as Map?)?.cast<String, dynamic>(),
      offerTime: fields[9] as DateTime,
      socialLinks: (fields[10] as Map).cast<String, String>(),
      lastUpdated: fields[11] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ShopInfoHive obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.shopName)
      ..writeByte(1)
      ..write(obj.number)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.shopCode)
      ..writeByte(4)
      ..write(obj.categories)
      ..writeByte(5)
      ..write(obj.delPrice)
      ..writeByte(6)
      ..write(obj.coupon)
      ..writeByte(7)
      ..write(obj.offerImages)
      ..writeByte(8)
      ..write(obj.offerDes)
      ..writeByte(9)
      ..write(obj.offerTime)
      ..writeByte(10)
      ..write(obj.socialLinks)
      ..writeByte(11)
      ..write(obj.lastUpdated);
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
