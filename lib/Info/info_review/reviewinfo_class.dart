import 'package:json_annotation/json_annotation.dart';
import '_bodyclass.dart';
import '_gradeclass.dart';
part 'reviewinfo_class.g.dart';

@JsonSerializable()
class Reviewinfo {
  final DateTime createdAt;
  final DateTime modifiedAt;
  final int id;
  final int buildingId;
  final BBody body;
  final GGrade grade;
  final String location;

  Reviewinfo({
    required this.createdAt,
    required this.modifiedAt,
    required this.id,
    required this.buildingId,
    required this.body,
    required this.grade,
    required this.location,
  });

  factory Reviewinfo.fromJson(Map<String, dynamic> json) =>
      _$ReviewinfoFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewinfoToJson(this);
}
