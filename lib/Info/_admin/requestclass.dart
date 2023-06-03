import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'requestclass.g.dart';

@JsonSerializable()
class Admin {
  final int id;
  final DateTime createdAt;
  final String location;
  final String name;
  final String nickname;
  final Map<String, dynamic> image;

  Admin({
    required this.createdAt,
    required this.id,
    required this.location,
    required this.name,
    required this.nickname,
    required this.image,
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

  factory Admin.fromJson(Map<String, dynamic> json) => _$AdminFromJson(json);

  Map<String, dynamic> toJson() => _$AdminToJson(this);
}
