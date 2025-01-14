import 'package:hive/hive.dart';

part 'coupon.g.dart'; // Generates the adapter

@HiveType(typeId: 12)
class Coupon extends HiveObject {
  @HiveField(0)
  final String couponCode;

  @HiveField(1)
  final double off;

  @HiveField(2)
  final double? price;

  @HiveField(3)
  final int? customLimit;

  @HiveField(4)
  final bool? limit;

  @HiveField(5)
  final String? startDate;

  @HiveField(6)
  final String? endDate;

  @HiveField(7)
  final int? startTimeMinutes;

  @HiveField(8)
  final int? endTimeMinutes;

  Coupon({
    required this.couponCode,
    required this.off,
    this.price,
    this.customLimit,
    this.limit,
    this.startDate,
    this.endDate,
    this.startTimeMinutes,
    this.endTimeMinutes,
  });

  Coupon copyWith({
    String? couponCode,
    double? off,
    double? price,
    int? customLimit,
    bool? limit,
    String? startDate,
    String? endDate,
    int? startTimeMinutes,
    int? endTimeMinutes,
  }) {
    return Coupon(
      couponCode: couponCode ?? this.couponCode,
      off: off ?? this.off,
      price: price ?? this.price,
      customLimit: customLimit ?? this.customLimit,
      limit: limit ?? this.limit,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTimeMinutes: startTimeMinutes ?? this.startTimeMinutes,
      endTimeMinutes: endTimeMinutes ?? this.endTimeMinutes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'couponCode': couponCode,
      'off': off,
      'price': price,
      'customLimit': customLimit,
      'limit': limit,
      'startDate': startDate,
      'endDate': endDate,
      'startTimeMinutes': startTimeMinutes,
      'endTimeMinutes': endTimeMinutes,
    };
  }

  factory Coupon.fromMap(Map<String, dynamic> map) {
    return Coupon(
      couponCode: map['couponCode'] as String,
      off: map['off'] as double,
      price: map['price'] as double?,
      customLimit: map['customLimit'] as int?,
      limit: map['limit'] as bool?,
      startDate: map['startDate'] as String?,
      endDate: map['endDate'] as String?,
      startTimeMinutes: map['startTimeMinutes'] as int?,
      endTimeMinutes: map['endTimeMinutes'] as int?,
    );
  }
}
