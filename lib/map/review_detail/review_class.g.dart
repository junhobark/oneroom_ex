// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reviewdetail _$ReviewdetailFromJson(Map<String, dynamic> json) => Reviewdetail(
      createdAt: DateTime.parse(json['createdAt'] as String),
      modifiedAt: DateTime.parse(json['modifiedAt'] as String),
      id: json['id'] as int,
      building: Building.fromJson(json['building'] as Map<String, dynamic>),
      body: Body.fromJson(json['body'] as Map<String, dynamic>),
      grade: Grade.fromJson(json['grade'] as Map<String, dynamic>),
      location: json['location'] as String,
    );

Map<String, dynamic> _$ReviewdetailToJson(Reviewdetail instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt.toIso8601String(),
      'modifiedAt': instance.modifiedAt.toIso8601String(),
      'id': instance.id,
      'building': instance.building,
      'body': instance.body,
      'grade': instance.grade,
      'location': instance.location,
    };
