// import 'package:hive/hive.dart';

// part 'shop_info_hive.g.dart'; // Update the part file name to match the new class name

// @HiveType(typeId: 0)
// class ShopInfoHive{ // Updated class name
//   @HiveField(0)
//   final String shopName;

//   @HiveField(1)
//   final String number;

//   @HiveField(2)
//   final String address;

//   @HiveField(3)
//   final String shopCode;

//   @HiveField(4)
//   final List<Map<String, dynamic>> categories;

//   @HiveField(5)
//   final double delPrice;

//   @HiveField(6)
//   final List<String> coupon;

//   @HiveField(7)
//   final List<String> offerImages;

//   @HiveField(8)
//   final List<Map<String, dynamic>> offerDes;

//   @HiveField(9)
//   final DateTime offerTime;

//   @HiveField(10)
//   final Map<String, String> socialLinks;

//   @HiveField(11)
//   final DateTime lastUpdated;

//   ShopInfoHive({ // Updated constructor name
//     required this.shopName,
//     required this.number,
//     required this.address,
//     required this.shopCode,
//     required this.categories,
//     required this.delPrice,
//     required this.coupon,
//     required this.offerImages,
//     required this.offerDes,
//     required this.offerTime,
//     required this.socialLinks,
//     required this.lastUpdated,
//   });

//   // Add your toMap and fromMap methods as needed
//     // Convert the object to a Map
//   Map<String, dynamic> toMap() {
//     return {
//       'shopName': shopName,
//       'number': number,
//       'address': address,
//       'shopCode': shopCode,
//       'categories': categories,
//       'delPrice': delPrice,
//       'coupon': coupon,
//       'offerImages': offerImages,
//       'offerDes': offerDes,
//       'offerTime': offerTime.toIso8601String(), // Convert DateTime to String
//       'socialLinks': socialLinks,
//       'lastUpdated': lastUpdated.toIso8601String(),
//     };
//   }

//   // Create a ShopInfoHive object from a Map
//   factory ShopInfoHive.fromMap(Map<String, dynamic> map) {
//     return ShopInfoHive(
//       shopName: map['shopName'],
//       number: map['number'],
//       address: map['address'],
//       shopCode: map['shopCode'],
//       categories: List<Map<String, dynamic>>.from(map['categories']),
//       delPrice: map['delPrice']?.toDouble() ?? 0.0, // Ensure double type
//       coupon: List<String>.from(map['coupon']),
//       offerImages: List<String>.from(map['offerImages']),
//       offerDes: List<Map<String, dynamic>>.from(map['offerDes'] ?? []),
//       offerTime: DateTime.parse(map['offerTime']), // Convert String back to DateTime
//       socialLinks: Map<String, String>.from(map['socialLinks']),
//       lastUpdated: DateTime.parse(map['lastUpdated']),
//     );
//   }

// }



import 'package:hive/hive.dart';

part 'shop_info_hive.g.dart'; // Update the part file name to match the new class name

@HiveType(typeId: 0)
class ShopInfoHive{ // Updated class name
  @HiveField(0)
  final String shopName;

  @HiveField(1)
  final String number;

  @HiveField(2)
  final String address;

  @HiveField(3)
  final String shopCode;

  @HiveField(4)
  final List<Map<String, dynamic>> categories;

  @HiveField(5)
  final double delPrice;

  @HiveField(6)
  final Map<String, dynamic>? coupon; // Modified to use Map<String, dynamic>?
  
  @HiveField(7)
  final Map<String, dynamic>? offerImages; // Modified to use Map<String, dynamic>?
  
  @HiveField(8)
  final Map<String, dynamic>? offerDes; // Modified to use Map<String, dynamic>?

  @HiveField(9)
  final DateTime offerTime;

  @HiveField(10)
  final Map<String, String> socialLinks;

  @HiveField(11)
  final DateTime lastUpdated;

  ShopInfoHive({ // Updated constructor name
    required this.shopName,
    required this.number,
    required this.address,
    required this.shopCode,
    required this.categories,
    required this.delPrice,
    required this.coupon,
    required this.offerImages,
    required this.offerDes,
    required this.offerTime,
    required this.socialLinks,
    required this.lastUpdated,
  });

  // Convert the object to a Map
  Map<String, dynamic> toMap() {
    return {
      'shopName': shopName,
      'number': number,
      'address': address,
      'shopCode': shopCode,
      'categories': categories,
      'delPrice': delPrice,
      'coupon': coupon,
      'offerImages': offerImages,
      'offerDes': offerDes,
      'offerTime': offerTime.toIso8601String(), // Convert DateTime to String
      'socialLinks': socialLinks,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  // Create a ShopInfoHive object from a Map
  factory ShopInfoHive.fromMap(Map<String, dynamic> map) {
    return ShopInfoHive(
      shopName: map['shopName'],
      number: map['number'],
      address: map['address'],
      shopCode: map['shopCode'],
      categories: List<Map<String, dynamic>>.from(map['categories']),
      delPrice: map['delPrice']?.toDouble() ?? 0.0, // Ensure double type
      coupon: map['coupon'] != null ? Map<String, dynamic>.from(map['coupon']) : null, // Modified to handle Map<String, dynamic>?
      offerImages: map['offerImages'] != null ? Map<String, dynamic>.from(map['offerImages']) : null, // Modified to handle Map<String, dynamic>?
      offerDes: map['offerDes'] != null ? Map<String, dynamic>.from(map['offerDes']) : null, // Modified to handle Map<String, dynamic>?
      offerTime: DateTime.parse(map['offerTime']), // Convert String back to DateTime
      socialLinks: Map<String, String>.from(map['socialLinks']),
      lastUpdated: DateTime.parse(map['lastUpdated']),
    );
  }
}
