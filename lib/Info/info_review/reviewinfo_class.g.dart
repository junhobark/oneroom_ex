// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reviewinfo_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reviewinfo _$ReviewinfoFromJson(Map<String, dynamic> json) => Reviewinfo(
      createdAt: DateTime.parse(json['createdAt'] as String),
      modifiedAt: DateTime.parse(json['modifiedAt'] as String),
      id: json['id'] as int,
      buildingId: json['buildingId'] as int,
      body: BBody.fromJson(json['body'] as Map<String, dynamic>),
      grade: GGrade.fromJson(json['grade'] as Map<String, dynamic>),
      location: json['location'] as String,
    );

Map<String, dynamic> _$ReviewinfoToJson(Reviewinfo instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt.toIso8601String(),
      'modifiedAt': instance.modifiedAt.toIso8601String(),
      'id': instance.id,
      'buildingId': instance.buildingId,
      'body': instance.body,
      'grade': instance.grade,
      'location': instance.location,
    };
