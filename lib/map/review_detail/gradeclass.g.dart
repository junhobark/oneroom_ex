// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gradeclass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Grade _$GradeFromJson(Map<String, dynamic> json) => Grade(
      lessor: (json['lessor'] as num).toDouble(),
      quality: (json['quality'] as num).toDouble(),
      area: (json['area'] as num).toDouble(),
      noise: (json['noise'] as num).toDouble(),
    );

Map<String, dynamic> _$GradeToJson(Grade instance) => <String, dynamic>{
      'lessor': instance.lessor,
      'quality': instance.quality,
      'area': instance.area,
      'noise': instance.noise,
    };
