// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_markers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mapmarkers _$MapmarkersFromJson(Map<String, dynamic> json) => Mapmarkers(
      id: json['id'] as int,
      location: json['location'] as String,
      posx: (json['posx'] as num).toDouble(),
      posy: (json['posy'] as num).toDouble(),
      totalgrade: (json['totalgrade'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      isLiked: json['isLiked'] as bool,
    );

Map<String, dynamic> _$MapmarkersToJson(Mapmarkers instance) =>
    <String, dynamic>{
      'id': instance.id,
      'location': instance.location,
      'posx': instance.posx,
      'posy': instance.posy,
      'totalgrade': instance.totalgrade,
      'reviewCount': instance.reviewCount,
      'isLiked': instance.isLiked,
    };
