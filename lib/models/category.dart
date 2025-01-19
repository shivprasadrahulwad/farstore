import 'dart:convert';

import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 4)
class Category extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String categoryName;

  @HiveField(2)
  final List<String> subcategories;

  @HiveField(3)
  final String? categoryImage;

  Category({
    required this.id,
    required this.categoryName,
    required this.subcategories,
    this.categoryImage,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'categoryName': categoryName,
      'subcategories': subcategories,
      'categoryImage': categoryImage,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['_id'] ?? '',
      categoryName: map['categoryName'] ?? '',
      subcategories: List<String>.from(map['subcategories'] ?? []),
      categoryImage: map['categoryImage'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) => Category.fromMap(json.decode(source));

  Category copyWith({
    String? id,
    String? categoryName,
    List<String>? subcategories,
    String? categoryImage,
  }) {
    return Category(
      id: id ?? this.id,
      categoryName: categoryName ?? this.categoryName,
      subcategories: subcategories ?? this.subcategories,
      categoryImage: categoryImage ?? this.categoryImage,
    );
  }
}
