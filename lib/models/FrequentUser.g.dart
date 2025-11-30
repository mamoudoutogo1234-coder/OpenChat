// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FrequentUser.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FrequentUserAdapter extends TypeAdapter<FrequentUser> {
  @override
  final int typeId = 2;

  @override
  FrequentUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FrequentUser(
      id: fields[0] as String,
      lastMessage: fields[1] as String,
      updatedAt: fields[2] as String,
      sender: (fields[3] as Map).cast<String, dynamic>(),
      receiver: (fields[4] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, FrequentUser obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.lastMessage)
      ..writeByte(2)
      ..write(obj.updatedAt)
      ..writeByte(3)
      ..write(obj.sender)
      ..writeByte(4)
      ..write(obj.receiver);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FrequentUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
