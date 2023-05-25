// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gradeclass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Grade _$GradeFromJson(Map<String, dynamic> json) => Grade(
      lessor: json['lessor'] as int,
      quality: json['quality'] as int,
      area: json['area'] as int,
      noise: json['noise'] as int,
    );

Map<String, dynamic> _$GradeToJson(Grade instance) => <String, dynamic>{
      'lessor': instance.lessor,
      'quality': instance.quality,
      'area': instance.area,
      'noise': instance.noise,
    };
