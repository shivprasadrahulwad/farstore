import 'dart:convert';

class Product {
  final int? discountPrice;
  final String? offer;
  final String subCategory;
  final String name;
  final String description;
  final int quantity;
  final List<String> images;
  final String category;
  final int price;
  final String id;
  final List<String> colors; 
  final List<String> size; 
  final String? note;
  final int basePrice;

  Product({
    required this.subCategory,
    required this.name,
    required this.description,
    required this.quantity,
    required this.images,
    required this.category,
    required this.price,
    required this.id,
    this.discountPrice,
    this.offer,
    this.colors = const [], 
    this.size = const [], 
    this.note,
    required this.basePrice,
  });

  Product copyWith({
    int? discountPrice,
    String? offer,
    String? subCategory,
    String? name,
    String? description,
    int? quantity,
    List<String>? images,
    String? category,
    int? price,
    String? id,
    List<String>? colors,
    List<String>? size,
    String? note,
    int? basePrice,
  }) {
    return Product(
      discountPrice: discountPrice ?? this.discountPrice,
      offer: offer ?? this.offer,
      subCategory: subCategory ?? this.subCategory,
      name: name ?? this.name,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      images: images ?? this.images,
      category: category ?? this.category,
      price: price ?? this.price,
      id: id ?? this.id,
      colors: colors ?? this.colors,
      size: size ?? this.size,
      note: note ?? this.note,
      basePrice: basePrice ?? this.basePrice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'discountPrice': discountPrice,
      'offer': offer,
      'subCategory': subCategory,
      'name': name,
      'description': description,
      'quantity': quantity,
      'images': images,
      'category': category,
      'price': price,
      '_id': id,
      'colors': colors, // Add colors to the map
      'size': size, // Add size to the map
      'note': note,
      'basePrice': basePrice,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    print('Mapping product: $map'); // Debugging statement

    return Product(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      quantity: (map['quantity'] )?.toInt() ?? 0,
      images: List<String>.from(map['images'] ?? []),
      category: map['category'] ?? '',
      subCategory: map['subCategory'] ?? '',
      price: (map['price'] )?.toInt() ?? 0,
      discountPrice: (map['discountPrice'] )?.toInt() ?? 0,
      offer: map['offer'],
      colors: List<String>.from(map['colors'] ?? []), // Map the colors
      size: List<String>.from(map['size'] ?? []), // Map the size
      note: map['note'],
      basePrice: (map['basePrice'] )?.toInt() ?? 0
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) => Product.fromMap(json.decode(source) as Map<String, dynamic>);
}

void main() {
  String jsonString = '''
  {
    "_id": "669335e32879d9af5fb38381",
    "name": "Groundnut",
    "description": "Most famous Indian vegetable which is loved by most people",
    "price": 90,
    "discountPrice": 80,
    "category": "Atta, Rice & Dal",
    "subCategory": "Dal",
    "offer": "",
    "quantity": 100,
    "images": ["https://res.cloudinary.com/dybzzlqhv/image/upload/v1720927440/shop/lr0"],
    "colors": ["red", "green"],
    "size": ["small", "medium"]
  }
  ''';

  // Convert JSON string to Product object
  Product product = Product.fromJson(jsonString);

  // Print Product object
  print('Product Name: ${product.name}');
  print('Product Description: ${product.description}');
  print('Product Price: ${product.price}');
  print('Product ID: ${product.id}');
  print('Product Colors: ${product.colors}');
  print('Product Size: ${product.size}');
  print('Product Note: ${product.note}');
    print('Product base price: ${product.basePrice}');

  // Convert Product object back to JSON string
  String productJson = product.toJson();
  print('Product JSON: $productJson');
}
