// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAccessDataAdapter extends TypeAdapter<UserAccessData> {
  @override
  final int typeId = 1;

  @override
  UserAccessData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserAccessData(
      email: fields[0] as String?,
      token: fields[4] as String?,
      image: fields[3] as String?,
      bio: fields[2] as String?,
      userName: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserAccessData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.email)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.bio)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.token);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAccessDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
