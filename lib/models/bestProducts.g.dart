// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bestProducts.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BestProductAdapter extends TypeAdapter<BestProduct> {
  @override
  final int typeId = 22;

  @override
  BestProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BestProduct(
      name: fields[0] as String,
      quantity: fields[1] as int,
      basePrice: fields[2] as double?,
      sellingPrice: fields[3] as double?,
      discountPrice: fields[4] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, BestProduct obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.basePrice)
      ..writeByte(3)
      ..write(obj.sellingPrice)
      ..writeByte(4)
      ..write(obj.discountPrice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BestProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
