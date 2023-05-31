// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reviewdetail _$ReviewdetailFromJson(Map<String, dynamic> json) => Reviewdetail(
      createdAt: DateTime.parse(json['createdAt'] as String),
      modifiedAt: DateTime.parse(json['modifiedAt'] as String),
      id: json['id'] as int,
      buildingId: json['buildingId'] as int,
      body: Body.fromJson(json['body'] as Map<String, dynamic>),
      grade: Grade.fromJson(json['grade'] as Map<String, dynamic>),
      location: json['location'] as String,
      images: (json['images'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$ReviewdetailToJson(Reviewdetail instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt.toIso8601String(),
      'modifiedAt': instance.modifiedAt.toIso8601String(),
      'id': instance.id,
      'buildingId': instance.buildingId,
      'body': instance.body,
      'grade': instance.grade,
      'location': instance.location,
      'images': instance.images,
    };
