// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'requestclass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Admin _$AdminFromJson(Map<String, dynamic> json) => Admin(
      createdAt: DateTime.parse(json['createdAt'] as String),
      id: json['id'] as int,
      location: json['location'] as String,
      name: json['name'] as String,
      nickname: json['nickname'] as String,
      image: json['image'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$AdminToJson(Admin instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'location': instance.location,
      'name': instance.name,
      'nickname': instance.nickname,
      'image': instance.image,
    };
