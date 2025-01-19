import 'dart:convert';

class Rating {
  final String userId;
  final double rating;

  Rating({
    required this.userId,
    required this.rating,
  });

  /// Convert `Rating` to a Map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'rating': rating,
    };
  }

  /// Create a `Rating` object from a Map
  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      userId: map['userId'] ?? '',
      rating: map['rating']?.toDouble() ?? 0.0,
    );
  }

  /// Convert to JSON
  String toJson() => json.encode(toMap());

  /// Create a `Rating` object from JSON
  factory Rating.fromJson(String source) => Rating.fromMap(json.decode(source));

  /// Create a copy of `Rating` with new values
  Rating copyWith({
    String? userId,
    double? rating,
  }) {
    return Rating(
      userId: userId ?? this.userId,
      rating: rating ?? this.rating,
    );
  }
}
