import 'package:json_annotation/json_annotation.dart';

part 'map_markers.g.dart';

@JsonSerializable()
class Mapmarkers {
  final int id;
  final String location;
  final double posx;
  final double posy;
  final double totalgrade;
  final int reviewCount;
  final bool isLiked;

  Mapmarkers({
    required this.id,
    required this.location,
    required this.posx,
    required this.posy,
    required this.totalgrade,
    required this.reviewCount,
    required this.isLiked,
  });

  factory Mapmarkers.fromJson(Map<String, dynamic> json) =>
      _$MapmarkersFromJson(json);

  Map<String, dynamic> toJson() => _$MapmarkersToJson(this);
}
