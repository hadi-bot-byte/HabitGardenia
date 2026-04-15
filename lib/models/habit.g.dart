// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitAdapter extends TypeAdapter<Habit> {
  @override
  final int typeId = 1;

  @override
  Habit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Habit(
      id: fields[0] as String?,
      name: fields[1] as String,
      category: fields[2] as HabitCategory,
      targetMinutes: fields[4] as int,
      plantType: fields[5] as String,
    )..completedDates = (fields[3] as List).cast<DateTime>();
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.completedDates)
      ..writeByte(4)
      ..write(obj.targetMinutes)
      ..writeByte(5)
      ..write(obj.plantType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HabitCategoryAdapter extends TypeAdapter<HabitCategory> {
  @override
  final int typeId = 0;

  @override
  HabitCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HabitCategory.exercise;
      case 1:
        return HabitCategory.meditation;
      case 2:
        return HabitCategory.reading;
      case 3:
        return HabitCategory.journaling;
      case 4:
        return HabitCategory.custom;
      default:
        return HabitCategory.exercise;
    }
  }

  @override
  void write(BinaryWriter writer, HabitCategory obj) {
    switch (obj) {
      case HabitCategory.exercise:
        writer.writeByte(0);
        break;
      case HabitCategory.meditation:
        writer.writeByte(1);
        break;
      case HabitCategory.reading:
        writer.writeByte(2);
        break;
      case HabitCategory.journaling:
        writer.writeByte(3);
        break;
      case HabitCategory.custom:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
