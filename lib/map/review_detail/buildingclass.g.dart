// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buildingclass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Building _$BuildingFromJson(Map<String, dynamic> json) => Building(
      id: json['id'] as int,
      name: json['name'] as String,
      posx: (json['posx'] as num).toDouble(),
      posy: (json['posy'] as num).toDouble(),
      totalgrade: (json['totalgrade'] as num).toDouble(),
    );

Map<String, dynamic> _$BuildingToJson(Building instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'posx': instance.posx,
      'posy': instance.posy,
      'totalgrade': instance.totalgrade,
    };
