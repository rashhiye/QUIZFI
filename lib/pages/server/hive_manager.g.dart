// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_manager.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerAdapter extends TypeAdapter<Player> {
  @override
  final int typeId = 0;

  @override
  Player read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Player(
      name: fields[0] as String,
      ip: fields[1] as String,
      avatar: fields[2] as String?,
      correct: fields[3] as int,
      wrong: fields[4] as int,
      skip: fields[5] as int,
      time: fields[6] as double,
      point: fields[7] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Player obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.ip)
      ..writeByte(2)
      ..write(obj.avatar)
      ..writeByte(3)
      ..write(obj.correct)
      ..writeByte(4)
      ..write(obj.wrong)
      ..writeByte(5)
      ..write(obj.skip)
      ..writeByte(6)
      ..write(obj.time)
      ..writeByte(7)
      ..write(obj.point);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
