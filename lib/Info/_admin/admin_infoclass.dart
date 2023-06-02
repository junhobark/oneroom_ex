import 'package:json_annotation/json_annotation.dart';
part 'admin_infoclass.g.dart';

@JsonSerializable()
class Admininfo {
  final int id;
  final DateTime createdAt;

  Admininfo({
    required this.id,
    required this.createdAt,
  });

  factory Admininfo.fromJson(Map<String, dynamic> json) =>
      _$AdmininfoFromJson(json);

  Map<String, dynamic> toJson() => _$AdmininfoToJson(this);
}
