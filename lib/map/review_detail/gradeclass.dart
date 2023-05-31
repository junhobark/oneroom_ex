import 'package:json_annotation/json_annotation.dart';

part 'gradeclass.g.dart';

@JsonSerializable()
class Grade {
  final double lessor;
  final double quality;
  final double area;
  final double noise;

  Grade({
    required this.lessor,
    required this.quality,
    required this.area,
    required this.noise,
  });

  factory Grade.fromJson(Map<String, dynamic> json) => _$GradeFromJson(json);

  Map<String, dynamic> toJson() => _$GradeToJson(this);
}
