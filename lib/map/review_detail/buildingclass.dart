import 'package:json_annotation/json_annotation.dart';

part 'buildingclass.g.dart';

@JsonSerializable()
class Building {
  final int id;
  final String name;
  final double posx;
  final double posy;
  final double totalgrade;

  Building({
    required this.id,
    required this.name,
    required this.posx,
    required this.posy,
    required this.totalgrade,
  });

  factory Building.fromJson(Map<String, dynamic> json) =>
      _$BuildingFromJson(json);

  Map<String, dynamic> toJson() => _$BuildingToJson(this);
}
