// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favoriteclass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Favorite _$FavoriteFromJson(Map<String, dynamic> json) => Favorite(
      createdAt: DateTime.parse(json['createdAt'] as String),
      totalGrade: (json['totalGrade'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toDouble(),
      location: json['location'] as String,
      isLiked: json['isLiked'] as bool,
      posx: (json['posx'] as num).toDouble(),
      posy: (json['posy'] as num).toDouble(),
    );

Map<String, dynamic> _$FavoriteToJson(Favorite instance) => <String, dynamic>{
      'createdAt': instance.createdAt.toIso8601String(),
      'location': instance.location,
      'totalGrade': instance.totalGrade,
      'reviewCount': instance.reviewCount,
      'isLiked': instance.isLiked,
      'posx': instance.posx,
      'posy': instance.posy,
    };
