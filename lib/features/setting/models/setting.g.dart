// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingAdapter extends TypeAdapter<Setting> {
  @override
  final int typeId = 2;

  @override
  Setting read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Setting(
      reminderHour: fields[0] as int,
      reminderMinute: fields[7] as int,
      language: fields[1] as String?,
      passcode: fields[3] as String?,
      startingDayOfWeek: fields[4] as String?,
      hasPasscode: fields[6] as bool,
      hasReminderTime: fields[5] as bool,
      point: fields[8] as int,
      bean: fields[2] as Bean,
      myBeans: (fields[9] as List).cast<Bean>(),
      background: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Setting obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.reminderHour)
      ..writeByte(1)
      ..write(obj.language)
      ..writeByte(2)
      ..write(obj.bean)
      ..writeByte(3)
      ..write(obj.passcode)
      ..writeByte(4)
      ..write(obj.startingDayOfWeek)
      ..writeByte(5)
      ..write(obj.hasReminderTime)
      ..writeByte(6)
      ..write(obj.hasPasscode)
      ..writeByte(7)
      ..write(obj.reminderMinute)
      ..writeByte(8)
      ..write(obj.point)
      ..writeByte(9)
      ..write(obj.myBeans)
      ..writeByte(10)
      ..write(obj.background);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
