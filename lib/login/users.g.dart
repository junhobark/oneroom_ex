// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Users _$UserFromJson(Map<String, dynamic> json) => Users(
      id: json['id'] as String,
      location: json['location'] as String?,
      nickName: json['nickName'] as String,
      valid: json['valid'] as String,
    );

Map<String, dynamic> _$UserToJson(Users instance) => <String, dynamic>{
      'id': instance.id,
      'location': instance.location,
      'nickName': instance.nickName,
      'valid': instance.valid,
    };
