// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DiaryAdapter extends TypeAdapter<Diary> {
  @override
  final int typeId = 0;

  @override
  Diary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Diary(
      mood: fields[0] as String,
      createdAt: fields[3] as DateTime,
      content: fields[1] as String?,
      images: (fields[2] as List?)?.cast<Uint8List>(),
      key: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Diary obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.mood)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.images)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.key);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiaryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
