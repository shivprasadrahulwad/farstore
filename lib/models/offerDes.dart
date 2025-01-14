import 'dart:convert';

import 'package:hive/hive.dart';

part 'offerDes.g.dart';

@HiveType(typeId: 7) // Assign a unique type ID
class offerDes {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String icon;

  offerDes({
    required this.title,
    required this.description,
    required this.icon,
  });

  /// Convert `offerDes` to a Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'icon': icon,
    };
  }

  /// Create an `offerDes` object from a Map
  factory offerDes.fromMap(Map<String, dynamic> map) {
    return offerDes(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      icon: map['icon'] ?? '',
    );
  }

  /// Convert to JSON
  String toJson() => toMap().toString();

  /// Create an `offerDes` object from JSON
  factory offerDes.fromJson(String json) {
    final Map<String, dynamic> map = jsonDecode(json);
    return offerDes.fromMap(map);
  }
}
