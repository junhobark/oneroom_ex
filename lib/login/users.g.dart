// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Users _$UsersFromJson(Map<String, dynamic> json) => Users(
      valid: json['valid'] as String,
      id: json['id'] as String,
      location: json['location'] as String?,
      nickName: json['nickName'] as String,
    );

Map<String, dynamic> _$UsersToJson(Users instance) => <String, dynamic>{
      'id': instance.id,
      'valid': instance.valid,
      'location': instance.location,
      'nickName': instance.nickName,
    };
