import 'package:json_annotation/json_annotation.dart';

part '_gradeclass.g.dart';

@JsonSerializable()
class GGrade {
  final double lessor;
  final double quality;
  final double area;
  final double noise;

  GGrade({
    required this.lessor,
    required this.quality,
    required this.area,
    required this.noise,
  });

  factory GGrade.fromJson(Map<String, dynamic> json) => _$GGradeFromJson(json);

  Map<String, dynamic> toJson() => _$GGradeToJson(this);
}
