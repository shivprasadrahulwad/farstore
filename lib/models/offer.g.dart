// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveOfferAdapter extends TypeAdapter<HiveOffer> {
  @override
  final int typeId = 17;

  @override
  HiveOffer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveOffer(
      title: fields[0] as String,
      description: fields[1] as String,
      iconCodePoint: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HiveOffer obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.iconCodePoint);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveOfferAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
