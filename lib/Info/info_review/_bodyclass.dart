import 'package:json_annotation/json_annotation.dart';
part '_bodyclass.g.dart';

@JsonSerializable()
class BBody {
  final String advantage;
  final String weakness;
  final String etc;

  BBody({
    required this.advantage,
    required this.weakness,
    required this.etc,
  });

  factory BBody.fromJson(Map<String, dynamic> json) => _$BBodyFromJson(json);

  Map<String, dynamic> toJson() => _$BBodyToJson(this);
}
