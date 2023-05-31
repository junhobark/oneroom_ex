import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

import 'bodyclass.dart';
import 'gradeclass.dart';
part 'review_class.g.dart';

@JsonSerializable()
class Reviewdetail {
  final DateTime createdAt;
  final DateTime modifiedAt;
  final int id;
  final int buildingId;
  final Body body;
  final Grade grade;
  final String location;
  final List<Map<String, dynamic>> images;
  Reviewdetail({
    required this.createdAt,
    required this.modifiedAt,
    required this.id,
    required this.buildingId,
    required this.body,
    required this.grade,
    required this.location,
    required this.images,
  });

  Widget buildImageWidget(Map<String, dynamic> image) {
    var body = image['body'];
    var headers = image['headers'];
    var contentType = headers['Content-Type'][0];
    var decodedImage = base64Decode(body);

    // ignore: unnecessary_null_comparison
    if (contentType == null ||
        // ignore: unnecessary_null_comparison
        decodedImage == null ||
        decodedImage.lengthInBytes == 0) {
      return SizedBox.shrink();
    }

    return Image.memory(
      decodedImage,
      // fit: BoxFit.fill,
      fit: BoxFit.cover,
    );
  }

  factory Reviewdetail.fromJson(Map<String, dynamic> json) =>
      _$ReviewdetailFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewdetailToJson(this);
}
