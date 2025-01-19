// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offerDes.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class offerDesAdapter extends TypeAdapter<offerDes> {
  @override
  final int typeId = 7;

  @override
  offerDes read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return offerDes(
      title: fields[0] as String,
      description: fields[1] as String,
      icon: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, offerDes obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.icon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is offerDesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
