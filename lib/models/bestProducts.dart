// import 'package:hive/hive.dart';

// part 'bestProducts.g.dart';

// @HiveType(typeId: 22)
// class BestProduct {
//   @HiveField(0)
//   final String name;

//   @HiveField(1)
//   int quantity;

//   @HiveField(2)
//   double totalAmount;

//   BestProduct({
//     required this.name,
//     required this.quantity,
//     required this.totalAmount,
//   });
// }


import 'package:hive/hive.dart';

part 'bestProducts.g.dart';

@HiveType(typeId: 22)
class BestProduct {
  @HiveField(0)
  final String name;

  @HiveField(1)
  int quantity;

  @HiveField(2)
  double? basePrice;

  @HiveField(3)
  double? sellingPrice;

  @HiveField(4)
  double? discountPrice;

  BestProduct({
    required this.name,
    required this.quantity,
    this.basePrice,
    this.sellingPrice,
    this.discountPrice,
  });
}
