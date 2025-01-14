import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'offer.g.dart';

// Hive model for storing offers
@HiveType(typeId: 17)
class HiveOffer extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String description;

  @HiveField(2)
  late int iconCodePoint;

  // Optional: You might want to add a constructor
  HiveOffer({
    required this.title,
    required this.description,
    required this.iconCodePoint,
  }); 

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'icon': IconData(iconCodePoint, fontFamily: 'MaterialIcons').toString(),
    };
  }

  // Optional: Add methods for comparison or conversion if needed
  @override
  String toString() {
    return 'HiveOffer(title: $title, description: $description, iconCodePoint: $iconCodePoint)';
  }

  
}