// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bean.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BeanAdapter extends TypeAdapter<Bean> {
  @override
  final int typeId = 3;

  @override
  Bean read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bean(
      nameBean: fields[0] as String,
      beans: (fields[1] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Bean obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.nameBean)
      ..writeByte(1)
      ..write(obj.beans);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BeanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
