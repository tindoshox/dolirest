// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GroupModelAdapter extends TypeAdapter<GroupModel> {
  @override
  final typeId = 6;

  @override
  GroupModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GroupModel(
      id: fields[1] as dynamic,
      rowid: fields[2] as dynamic,
      codeDepartement: fields[3] as dynamic,
      code: fields[4] as dynamic,
      name: fields[5] as dynamic,
      nom: fields[6] as dynamic,
      label: fields[7] as dynamic,
      active: fields[8] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, GroupModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.rowid)
      ..writeByte(3)
      ..write(obj.codeDepartement)
      ..writeByte(4)
      ..write(obj.code)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.nom)
      ..writeByte(7)
      ..write(obj.label)
      ..writeByte(8)
      ..write(obj.active);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
