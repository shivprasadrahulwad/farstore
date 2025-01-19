
import 'package:farstore/constants/error_handeling.dart';
import 'package:farstore/constants/global_variables.dart';
import 'package:farstore/constants/utils.dart';
import 'package:farstore/models/order.dart';
import 'package:farstore/models/shopInfo.dart';
import 'package:farstore/providers/admin_provider.dart';
import 'package:farstore/providers/shopInfo_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert'; 
import 'package:http/http.dart' as http;

import '../../../models/product.dart';

class AdminServices {

Future<void> addShopInfo({
  required BuildContext context,
  required String shopName,
  required String number,
  required String address,
  required String time,
  required String shopCode,
  required List<Map<String, dynamic>> categories,
  required int delPrice,
  required Map<String, dynamic>? coupon,
  required Map<String, dynamic>? offerImages,
  required Map<String, dynamic>? offerDes,
  required DateTime? offerTime,
  required List<String>? socialLinks,
  required Map<String, dynamic>? charges,
}) async {
  final adminProvider = Provider.of<AdminProvider>(context, listen: false);

  try {
    // Validate required fields
    if (shopName.isEmpty || number.isEmpty || address.isEmpty || shopCode.isEmpty || categories.isEmpty || time.isEmpty) {
      throw Exception('All required fields must be filled');
    }

    // Handle coupon data properly
    Map<String, dynamic> formattedCoupon = {
      'couponToggle': false,
      'coupons': [],
    };

    if (coupon != null && coupon['type'] != null) {
      final typeData = coupon['type'];
      if (typeData is Map<String, dynamic> && typeData['coupons'] != null) {
        final List<dynamic> couponsData = typeData['coupons'];
        final List<Map<String, dynamic>> formattedCoupons = couponsData
            .map((couponData) {
              if (couponData is Map<String, dynamic>) {
                return {
                  'couponCode': couponData['couponCode']?.toString() ?? '',
                  'off': (couponData['off'] ?? 0.0).toDouble(),
                  'price': (couponData['price'] ?? 0.0).toDouble(),
                  'customLimit':(couponData['customLimit'] ?? 0.0),
                  'limit': (couponData['limit']),
                  'startTime': (couponData['startTimeMinutes']),
                  'endTime': (couponData['endTimeMinutes']),
                  'startDate': (couponData['startDate']),
                  'endDate': (couponData['endDate']),
                };
              }
              throw Exception('Invalid coupon data format');
            })
            .toList();
            

        formattedCoupon = {
          'couponToggle': typeData['couponToggle'] ?? false,
          'coupons': formattedCoupons,
        };
      }
       print('-----------adminservice coupon ${formattedCoupon}');
    }

    Map<String, dynamic> formattedOfferImages = {
      'type': {
        'images': [],
        'offerImagesToggle': false,
      }
    };

    if (offerImages != null && offerImages['type'] != null) {
      formattedOfferImages = {
        'type': {
          'images': offerImages['type']['images'] ?? [],
          'offerImagesToggle': offerImages['type']['offerImagesToggle'] ?? false,
        }
      };
    }

    Map<String, dynamic> formattedOfferDes = {};

if (offerDes != null) {
  dynamic descriptionsData = offerDes['type']?['descriptions'];
  bool offerToggle = offerDes['type']?['offerToggle'] ?? false;
  
  List<Map<String, dynamic>> validDescriptions = [];

  if (descriptionsData is Map<String, dynamic>) {
    validDescriptions.add({
      'title': descriptionsData['title']?.toString() ?? '',
      'description': descriptionsData['description']?.toString() ?? '',
      'icon': descriptionsData['icon']?.toString() ?? ''
    });
  } else if (descriptionsData is List) {
    for (var desc in descriptionsData) {
      if (desc is Map<String, dynamic>) {
        validDescriptions.add({
          'title': desc['title']?.toString() ?? '',
          'description': desc['description']?.toString() ?? '',
          'icon': desc['icon']?.toString() ?? ''
        });
      }
    }
  }

  // Limit to 5 descriptions
  validDescriptions = validDescriptions.take(5).toList();

  // Modify to match expected object structure
  formattedOfferDes = {
    'descriptions': validDescriptions,
    'offerToggle': offerToggle
  };
}

    // Prepare the shop info data
    final newShopInfo = {
      'shopName': shopName,
      'number': number,
      'address': address,
      'time': time,
      'shopCode': shopCode,
      'categories': categories,
      'delPrice': delPrice,
      'coupon': formattedCoupon,
      'offerImages': formattedOfferImages,
      'offerDes': formattedOfferDes,
      'Offertime': (offerTime ?? DateTime.now()).toUtc().toIso8601String(),
      'socialLinks': socialLinks ?? [],
      'charges': charges ?? {},
    };

    // Debugging prints
    debugPrint('Formatted shop info: ${jsonEncode(newShopInfo)}');

    // Send POST request
    final response = await http.post(
      Uri.parse('$uri/api/admin/add-shop-info'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': adminProvider.admin.token,
      },
      body: jsonEncode(newShopInfo),
    );

    // Handle the response
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      
      if (responseData['success'] == true && responseData['shopInfo'] != null) {
        showSnackBar(context, 'Shop information added successfully!');
        
        debugPrint('Response body: ${jsonEncode(responseData)}');
        
        // Convert the shopInfo to the correct format
        final Map<String, dynamic> shopInfo = Map<String, dynamic>.from(responseData['shopInfo']);
        
        // Update the admin provider with the new shop details
        final List<Map<String, dynamic>> updatedShopDetails = List<Map<String, dynamic>>.from(
          adminProvider.admin.shopDetails ?? []
        )..add(shopInfo);

        adminProvider.setAdminFromModel(
          adminProvider.admin.copyWith(shopDetails: updatedShopDetails),
        );
      } else {
        throw Exception('Response indicates failure or missing shop info');
      }
    } else {
      throw Exception('Failed to add shop info. Status: ${response.statusCode}, Body: ${response.body}');
    }
  } catch (e) {
    debugPrint('Error in addShopInfo: $e');
    showSnackBar(context, 'Error adding shop info: ${e.toString()}');
    rethrow;
  }
}



  Future<Map<String, dynamic>> fetchLatestShopInfo(BuildContext context) async {
  try {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);

    // Make the GET request to fetch the latest shop info
    final response = await http.get(
      Uri.parse('$uri/api/admin/fetch-latest-shop-info'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': adminProvider.admin.token,
      },
    );

    // Check if the response is successful
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData; // Returning the latest shop info as Map
    } else {
      throw Exception('Failed to fetch latest shop info. Status: ${response.statusCode}');
    }
  } catch (e) {
    print('Error in fetchLatestShopInfo: $e');
    throw Exception('Failed to fetch latest shop info: $e');
  }
}


Future<void> fetchShopDetails(BuildContext context) async {
  try {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    
    if (adminProvider.admin?.token == null) {
      throw Exception('Authentication token is missing. Please login again.');
    }
    
    final response = await http.get(
      Uri.parse('$uri/api/admin/fetch-shop-info'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': adminProvider.admin!.token,
      },
    );
    
    print('Fetch Shop Details Response status: ${response.statusCode}');
    print('Fetch Shop Details Response body: ${response.body}');
    
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      
      if (responseData == null || responseData.isEmpty) {
        throw Exception('No shop details found');
      }
      
      final shopDetails = responseData;
      print('Shop Details charges: ${shopDetails[0]['charges']}'); // Debug print
      
      final shopInfoProvider = Provider.of<ShopInfoProvider>(context, listen: false);
      final updatedShopInfo = ShopInfo.fromMap(shopDetails[0]);
      
      print('Parsed ShopInfo charges: ${updatedShopInfo.charges?.toMap()}'); // Debug print
      print('Parsed ShopInfo des: ${updatedShopInfo.offerDes}');
      
      shopInfoProvider.setShopInfo(updatedShopInfo);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Shop details fetched successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      throw Exception('Failed to fetch shop details. Status: ${response.statusCode}');
    }
  } catch (e) {
    print('Error in fetchShopDetails: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error fetching shop details: $e'),
        backgroundColor: Colors.red,
      ),
    );
    rethrow;
  }
}

  void addProduct({
    required BuildContext context,
    required String description,
    required String category,
    required String subCategory,
    required int quantity,
    required List<String> colors,
    required List<String> size,
    required List<String> images,
    required String offer,
    required int price,
    required int discountPrice,
    required String name,
    required String note,
    required int basePrice,
    
  }) async {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);

    try {
      final newProduct = {
        'product': {
          'name': name,
          'description': description,
          'price': price,
          'discountPrice': discountPrice,
          'quantity': quantity,
          'colors': colors,
          'size': size,
          'images': images,
          'category': category,
          'subCategory': subCategory,
          'offer': offer,
          'note':note,
          'basePrice':basePrice,
        }
      };

      final response = await http.post(
        Uri.parse('$uri/api/admin/add-product-info'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': adminProvider.admin.token,
        },
        body: jsonEncode(newProduct),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        showSnackBar(context, 'Product added successfully!');
        adminProvider.admin.productsInfo = responseData['productsInfo'];
      } else {
        throw Exception('Failed to add product. Status: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      print('Error in addProduct: $e');
      showSnackBar(context, 'Error adding product: ${e.toString()}');
    }
    
  }


  Future<void> updateProduct({
    required BuildContext context,
    required String productId,
    required String description,
    required String category,
    required String subCategory,
    required int quantity,
    required List<String> colors,
    required List<String> size,
    required List<String> images,
    required String offer,
    required int price,
    required int discountPrice,
    required String name,
    required int basePrice,
  }) async {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);

    try {
      final updatedProduct = {
        'product': {
          '_id': productId,  // Include the product's _id for identification
          'name': name,
          'description': description,
          'price': price,
          'discountPrice': discountPrice,
          'quantity': quantity,
          'colors': colors,
          'size': size,
          'images': images,
          'category': category,
          'subCategory': subCategory,
          'offer': offer,
          'basePrice':basePrice,
        }
      };

      final response = await http.put(
        Uri.parse('$uri/api/admin/edit-product-info'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': adminProvider.admin.token,
        },
        body: jsonEncode(updatedProduct),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        showSnackBar(context, 'Product updated successfully!');
        adminProvider.admin.productsInfo = responseData['productsInfo'];
      } else {
        throw Exception('Failed to edit product. Status: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      print('Error in updateProduct: $e');
      showSnackBar(context, 'Error editing product: ${e.toString()}');
    }
  }


// delete Produc from the shop
void deleteProductFromProductInfo({
  required BuildContext context,
  required String productId,
  required VoidCallback onSuccess,
}) async {
  final adminProvider = Provider.of<AdminProvider>(context, listen: false);

  try {
    final res = await http.post(
      Uri.parse('$uri/admin/delete-productinfo-product'),  // Updated API endpoint
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': adminProvider.admin.token,
      },
      body: jsonEncode({
        'userId': adminProvider.admin.id,
        'productId': productId,
      }),
    );

    if (res.statusCode == 200) {
      // Product successfully deleted from productsInfo
      onSuccess();
    } else {
      // Handle any other status code, e.g., 404, 500, etc.
      throw Exception('Failed to delete product from productsInfo');
    }
  } catch (e) {
    // Handle any errors that occur during the HTTP request
    print('Error deleting product from productsInfo: $e');
    // You can show a snackbar or other UI notification to inform the user about the error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to delete product from productsInfo. Please try again.'),
      ),
    );
  }
}




// Fetch user's products from productsInfo based on subcategory
// Future<List<Product>> fetchUserSubCategoryProducts({
//   required BuildContext context,
//   required String shopCode,
//   required String subCategory,
// }) async {
//    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
//    List<Product> productList = [];
   
//    try {
//      final response = await http.get(
//        Uri.parse('$uri/admin/user-products/$shopCode?subCategory=$subCategory'),
//        headers: {
//          'Content-Type': 'application/json; charset=UTF-8',
//          'x-auth-token': adminProvider.admin.token,
//        },
//      );
     
//      if (response.statusCode == 200) {
//        final List<dynamic>? data = jsonDecode(response.body);
       
//        if (data != null) {
//          productList = data.map((item) {
//            if (item is Map<String, dynamic>) {
//              return Product.fromMap(item);
//            } else {
//              throw Exception('Invalid product data format');
//            }
//          }).toList();
//        } else {
//          throw Exception('No data received from the server');
//        }
//      } else if (response.statusCode == 404) {
//        throw Exception('No products found for this shop and subcategory');
//      } else {
//        throw Exception('Failed to load products: ${response.statusCode}');
//      }
//    } catch (e) {
//      showSnackBar(context, e.toString()); // Show error in the UI
//    }
   
//    return productList;
// }



Future<List<Product>> fetchUserSubCategoryProducts({
  required BuildContext context,
  required String shopCode,
  required String subCategory,
  required String category,
}) async {
  final adminProvider = Provider.of<AdminProvider>(context, listen: false);
  List<Product> productList = [];

  try {
    final response = await http.get(
      Uri.parse('$uri/admin/user-products/$shopCode?subCategory=$subCategory&category=$category'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': adminProvider.admin.token,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic>? data = jsonDecode(response.body);

      if (data != null) {
        productList = data.map((item) {
          if (item is Map<String, dynamic>) {
            return Product.fromMap(item);
          } else {
            throw Exception('Invalid product data format');
          }
        }).toList();
      } else {
        throw Exception('No data received from the server');
      }
    } else if (response.statusCode == 404) {
      throw Exception('No products found for this shop, category, and subcategory');
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  } catch (e) {
    showSnackBar(context, e.toString()); // Show error in the UI
  }

  return productList;
}

//admin fetch alll orders
Future<List<Order>> fetchAllOrders(BuildContext context, String shopId) async {
    final userProvider = Provider.of<AdminProvider>(context, listen: false);
    List<Order> orderList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/admin/get-orders/$shopId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.admin.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            orderList.add(
              Order.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return orderList;
  }


////  add order settings and update it
Future<void> updateOrderSettings({
  required BuildContext context,
  required Map<String, dynamic> orderSettingsData,
}) async {
  final adminProvider = Provider.of<AdminProvider>(context, listen: false);
 
  try {
    final updateData = {
      'orderSettings': orderSettingsData
    };

    final response = await http.post(
      Uri.parse('$uri/api/admin/update-order-settings'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': adminProvider.admin.token,
      },
      body: jsonEncode(updateData),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      showSnackBar(context, 'Order settings updated successfully!');
    } else {
      throw Exception('Failed to update order settings. Status: ${response.statusCode}, Body: ${response.body}');
    }
  } catch (e) {
    print('Error in updateOrderSettings: $e');
    showSnackBar(context, 'Error updating order settings: ${e.toString()}');
  }
}
  

}


