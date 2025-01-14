import 'dart:convert';

import 'package:farstore/models/category.dart';
import 'package:farstore/models/charges.dart';
import 'package:farstore/models/orderSettings.dart';
import 'package:farstore/models/rating.dart';


class ShopInfo {
  final String shopName;
  final int number;
  final String address;
  final String time;
  final String shopCode;
  final List<Category> categories;
  final double? delPrice;
  final Map<String, dynamic>? coupon;
  final Map<String, dynamic>? offerImages;
  final Map<String, dynamic>? offerDes; // Updated field
  final DateTime? offertime;
  final String? socialLinks;
  final DateTime lastUpdated;
  final Charges? charges;
  final OrderSettings? orderSettings;
  final List<Rating>? rating;

  ShopInfo({
    required this.shopName,
    required this.number,
    required this.address,
    required this.time,
    required this.shopCode,
    required this.categories,
    this.delPrice,
    this.coupon,
    this.offerImages,
    this.offerDes,
    this.offertime,
    this.socialLinks,
    required this.lastUpdated,
    this.charges,
    this.orderSettings,
    this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'shopName': shopName,
      'number': number,
      'address': address,
      'time': time, 
      'shopCode': shopCode,
      'categories': categories.map((x) => x.toMap()).toList(),
      'delPrice': delPrice,
      'coupon': coupon,
      'offerImages': offerImages,
      'offerDes': offerDes,
      'offertime': offertime?.toIso8601String(),
      'socialLinks': socialLinks,
      'lastUpdated': lastUpdated.toIso8601String(),
      'charges': charges?.toMap(),
      'orderSettings': orderSettings?.toMap(),
      'rating': rating,
    };
  }

  factory ShopInfo.fromMap(Map<String, dynamic> map) {
  return ShopInfo(
    shopName: map['shopName'] ?? '',
    number: int.tryParse(map['number'].toString()) ?? 0,
    address: map['address'] ?? '',
    time: map['time'] ?? '',
    shopCode: map['shopCode'] ?? '',
    categories: map['categories'] != null
        ? List<Category>.from(
            (map['categories'] as List).map((x) => Category.fromMap(x)))
        : [],
    delPrice: (map['delPrice'] ?? 0).toDouble(),
    coupon: map['coupon'] != null ? Map<String, dynamic>.from(map['coupon']) : null,
      offerImages: map['offerImages'] != null ? Map<String, dynamic>.from(map['offerImages']) : null,
      offerDes: map['offerDes'] != null ? Map<String, dynamic>.from(map['offerDes']) : null,
    offertime: map['Offertime'] != null
        ? DateTime.parse(map['Offertime'])
        : null,
    socialLinks: map['socialLinks']?.isNotEmpty == true
        ? map['socialLinks'][0]
        : null,
    lastUpdated: DateTime.parse(map['lastUpdated']),
    charges: map['charges'] != null ? Charges.fromMap(map['charges']) : null,
    orderSettings: map['orderSettings'] != null 
          ? OrderSettings.fromMap(map['orderSettings']) 
          : null,
    rating: map['ratings'] != null
          ? List<Rating>.from(
              map['ratings']?.map(
                (x) => Rating.fromMap(x),
              ),
            )
          : null,
  );
}

  String toJson() => json.encode(toMap());

  factory ShopInfo.fromJson(String source) =>
      ShopInfo.fromMap(json.decode(source));

  /// `copyWith` method to create a modified copy of the current object
  ShopInfo copyWith({
    String? shopName,
    int? number,
    String? address,
    String? time,
    String? shopCode,
    List<Category>? categories,
    double? delPrice,
    Map<String, dynamic>? coupon,
    Map<String, dynamic>? offerImages,
    Map<String, dynamic>? offerDes,
    DateTime? offertime,
    String? socialLinks,
    DateTime? lastUpdated,
    Charges? charges,
    OrderSettings? orderSettings,
    List<Rating>? rating,

  }) {
    return ShopInfo(
      shopName: shopName ?? this.shopName,
      number: number ?? this.number,
      address: address ?? this.address,
      time: time ?? this.time,
      shopCode: shopCode ?? this.shopCode,
      categories: categories ?? this.categories,
      delPrice: delPrice ?? this.delPrice,
      coupon: coupon ?? this.coupon,
      offerImages: offerImages ?? this.offerImages,
      offerDes: offerDes ?? this.offerDes, 
      offertime: offertime ?? this.offertime,
      socialLinks: socialLinks ?? this.socialLinks,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      charges: charges ?? this.charges,
      orderSettings: orderSettings ?? this.orderSettings, 
      rating: rating ?? this.rating,
    );
  }
}
