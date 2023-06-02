// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_gradeclass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GGrade _$GGradeFromJson(Map<String, dynamic> json) => GGrade(
      lessor: (json['lessor'] as num).toDouble(),
      quality: (json['quality'] as num).toDouble(),
      area: (json['area'] as num).toDouble(),
      noise: (json['noise'] as num).toDouble(),
    );

Map<String, dynamic> _$GGradeToJson(GGrade instance) => <String, dynamic>{
      'lessor': instance.lessor,
      'quality': instance.quality,
      'area': instance.area,
      'noise': instance.noise,
    };
