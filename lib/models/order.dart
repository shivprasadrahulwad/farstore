import 'dart:convert';

import 'package:farstore/models/product.dart';

class Order {
  final String id;
  final List<Product> products;
  final List<int> quantity;
  final String address;
  final List<String> instruction;
  final String tips;
  final String userId;
  final int orderedAt;
  int status;
  final int totalSave;
  final int totalPrice;
  final String shopId;
  final String note;
  final int number;
  final String name;
  Map<String, double> location;
  final int paymentType;

  Order({
    required this.id,
    required this.products,
    required this.quantity,
    required this.address,
    required this.instruction,
    required this.tips,
    required this.userId,
    required this.orderedAt,
    required this.status,
    required this.totalSave,
    required this.totalPrice,
    required this.shopId,
    required this.note,
    required this.number,
    required this.name,
    required this.location,
    required this.paymentType,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'shopId': shopId,
      'products': products.asMap().entries.map((entry) => {
        'product': entry.value.toMap(),
        'quantity': quantity[entry.key]
      }).toList(),
      'address': address,
      'instruction': instruction,
      'tips': tips,
      'userId': userId,
      'orderedAt': orderedAt,
      'status': status,
      'totalSave': totalSave,
      'totalPrice': totalPrice,
      'note': note,
      'number': number,
      'name': name,
      'location': location,
      'paymentType': paymentType,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
  return Order(
    id: map['_id'] ?? '',
    products: (map['products'] as List<dynamic>? ?? []).map((product) {
      return Product.fromMap(product['product']);
    }).toList(),
    quantity: (map['products'] as List<dynamic>? ?? []).map((product) {
      return product['quantity'] as int;
    }).toList(),
    address: map['address'] ?? '',
    shopId: map['shopId']?.toString() ?? '',
    note: map['note']?.toString() ?? '',
    userId: map['userId']?.toString() ?? '',
    instruction: List<String>.from(map['instruction'] ?? []),
    orderedAt: map['orderedAt']?.toInt() ?? 0,
    status: map['status']?.toInt() ?? 0,
    number: map['number']?.toInt() ?? 0,
    totalSave: map['totalSave']?.toInt() ?? 0,
    totalPrice: map['totalPrice']?.toInt() ?? 0,
    tips: map['tips']?.toString() ?? '',
    name: map['name']?.toString() ?? '',
    location: (map['location'] as Map<String, dynamic>? ?? {'latitude': 0, 'longitude': 0})
        .map((key, value) => MapEntry(key, (value as num).toDouble())),
    paymentType: map['paymentType']?.toInt() ?? 0,
  );
}


  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));

  Order copyWith({
    String? id,
    List<Product>? products,
    List<int>? quantity,
    String? address,
    List<String>? instruction,
    String? tips,
    String? userId,
    int? orderedAt,
    int? status,
    int? totalSave,
    int? totalPrice,
    String? shopId,
    String? note,
    int? number,
    String? name,
    Map<String, double>? location,
    int? paymentType,
  }) {
    return Order(
      id: id ?? this.id,
      products: products ?? this.products,
      quantity: quantity ?? this.quantity,
      address: address ?? this.address,
      instruction: instruction ?? this.instruction,
      tips: tips ?? this.tips,
      userId: userId ?? this.userId,
      orderedAt: orderedAt ?? this.orderedAt,
      status: status ?? this.status,
      totalSave: totalSave ?? this.totalSave,
      totalPrice: totalPrice ?? this.totalPrice,
      shopId: shopId ?? this.shopId,
      number: number ?? this.number,
      note: note ?? this.note,
      name: name ?? this.name,
      location: location ?? this.location,
      paymentType: paymentType ?? this.paymentType,
    );
  }
}
