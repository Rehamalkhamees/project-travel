import 'package:flutter/material.dart';

class DestinationModel {
  final String name;
  final String type;
  final String image;
  final Color color;

  DestinationModel({
    required this.name,
    required this.type,
    required this.image,
    required this.color,
  });

  factory DestinationModel.fromJson(Map<String, dynamic> json) {
    return DestinationModel(
      name: json['name'],
      type: json['type'],
      image: json['image'],
      color: Color(int.parse(json['color'].toString())),
    );
  }
}
