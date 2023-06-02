// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_infoclass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Admininfo _$AdmininfoFromJson(Map<String, dynamic> json) => Admininfo(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$AdmininfoToJson(Admininfo instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
    };
