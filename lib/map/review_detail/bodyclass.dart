import 'package:json_annotation/json_annotation.dart';
part 'bodyclass.g.dart';

@JsonSerializable()
class Body {
  final String advantage;
  final String weakness;
  final String etc;

  Body({
    required this.advantage,
    required this.weakness,
    required this.etc,
  });

  factory Body.fromJson(Map<String, dynamic> json) => _$BodyFromJson(json);

  Map<String, dynamic> toJson() => _$BodyToJson(this);
}
