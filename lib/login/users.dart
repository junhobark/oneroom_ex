import 'package:json_annotation/json_annotation.dart';
part 'users.g.dart';

@JsonSerializable()
class Users {
  final String id;
  final String valid;
  final String? location;
  final String nickName;

  Users({
    required this.valid,
    required this.id,
    required this.location,
    required this.nickName,
  });

  factory Users.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
