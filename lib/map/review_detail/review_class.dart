import 'package:json_annotation/json_annotation.dart';

import 'bodyclass.dart';
import 'buildingclass.dart';
import 'gradeclass.dart';

part 'review_class.g.dart';

@JsonSerializable()
class Reviewdetail {
  final DateTime createdAt;
  final DateTime modifiedAt;
  final int id;
  final Building building;
  final Body body;
  final Grade grade;
  final String location;

  Reviewdetail({
    required this.createdAt,
    required this.modifiedAt,
    required this.id,
    required this.building,
    required this.body,
    required this.grade,
    required this.location,
  });

  factory Reviewdetail.fromJson(Map<String, dynamic> json) =>
      _$ReviewdetailFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewdetailToJson(this);
}
