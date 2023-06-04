import 'package:json_annotation/json_annotation.dart';

part 'favoriteclass.g.dart';

@JsonSerializable()
class Favorite {
  final DateTime createdAt;
  final String location;
  final double totalGrade;
  final double reviewCount;
  final bool isLiked;
  final double posx;
  final double posy;
  Favorite({
    required this.createdAt,
    required this.totalGrade,
    required this.reviewCount,
    required this.location,
    required this.isLiked,
    required this.posx,
    required this.posy,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) =>
      _$FavoriteFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteToJson(this);
}
