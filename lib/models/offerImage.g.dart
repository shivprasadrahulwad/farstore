// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offerImage.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OfferImageAdapter extends TypeAdapter<OfferImage> {
  @override
  final int typeId = 10;

  @override
  OfferImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OfferImage(
      imageUrls: (fields[0] as List?)?.cast<String>(),
      lastUpdated: fields[1] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, OfferImage obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.imageUrls)
      ..writeByte(1)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfferImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
