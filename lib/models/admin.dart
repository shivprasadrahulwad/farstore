import 'dart:convert';

class Admin {
  final String id;
  final String name;
  final String email;
  final String password;
  final String address;
  final String type;
  final String token;
  late final List<dynamic> productsInfo;
  final List<Map<String, dynamic>> shopDetails;
  final String shopCode;

  Admin({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.address,
    required this.type,
    required this.token,
    required this.productsInfo,
    required this.shopDetails,
    required this.shopCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'address': address,
      'type': type,
      'token': token,
      'productsInfo': productsInfo,
      'shopDetails': shopDetails,
      'shopCode': shopCode
    };
  }

  factory Admin.fromMap(Map<String, dynamic> map) {
    print("Initializing Admin from Map: $map");
    return Admin(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      address: map['address'] ?? '',
      type: map['type'] ?? '',
      token: map['token'] ?? '',
      productsInfo: List<Map<String, dynamic>>.from(
        map['productsInfo']?.map(
          (x) => Map<String, dynamic>.from(x),
        ),
      ),
      shopDetails: List<Map<String, dynamic>>.from(map['shopDetails'] ?? []),
      shopCode: map['shopCode'] ?? '',
    );
  }
  
  String toJson() => json.encode(toMap());

  factory Admin.fromJson(String source) => Admin.fromMap(json.decode(source));

  Admin copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? address,
    String? type,
    String? token,
    List<dynamic>? productsInfo,
    List<Map<String, dynamic>>? shopDetails,
    String? shopCode,
  }) {
    return Admin(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      address: address ?? this.address,
      type: type ?? this.type,
      token: token ?? this.token,
      productsInfo: productsInfo ?? this.productsInfo,
      shopDetails: shopDetails ?? this.shopDetails,
      shopCode: shopCode ?? this.shopCode,
    );
  }
}
