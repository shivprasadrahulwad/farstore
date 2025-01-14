import 'package:flutter/material.dart';
import 'package:farstore/models/admin.dart';

class AdminProvider extends ChangeNotifier {
  Admin _admin = Admin(
    id: '',
    name: '',
    email: '',
    password: '',
    address: '',
    type: '',
    token: '',
    productsInfo: [],
    shopDetails: [],
    shopCode: '',
  );

  Admin get admin => _admin;

   void removeProductFromInfo(String productId) {
    // Filter out the product with the matching ID
    final updatedProductsInfo = _admin.productsInfo.where((product) => product['_id'] != productId).toList();
    
    // Update the _admin object with the new product list
    _admin = _admin.copyWith(productsInfo: updatedProductsInfo);
    
    // Notify listeners that the state has changed
    notifyListeners();
  }

  

  // Set Admin from JSON
  void setAdmin(String adminJson) {
    _admin = Admin.fromJson(adminJson);
    notifyListeners();
  }

  // Set Admin from Admin model
  void setAdminFromModel(Admin admin) {
    _admin = admin;
    notifyListeners();
  }

  // Add product to productsInfo
  void addProductToInfo(Map<String, dynamic> product) {
    final existingProductIndex = _admin.productsInfo.indexWhere((item) => item['_id'] == product['_id']);
    
    if (existingProductIndex == -1) {
      _admin = _admin.copyWith(productsInfo: [..._admin.productsInfo, product]);
      notifyListeners();
    }
  }

  // Add shop info to shopDetails
  void addShopToDetails(Map<String, dynamic> shopInfo) {
    final existingShopIndex = _admin.shopDetails.indexWhere((item) => item['shopCode'] == shopInfo['shopCode']);
    
    if (existingShopIndex == -1) {
      _admin = _admin.copyWith(shopDetails: [..._admin.shopDetails, shopInfo]);
      notifyListeners();
    }
  }

  // Remove shop from shopDetails
  void removeShopFromDetails(String shopCode) {
    final updatedShopDetails = _admin.shopDetails.where((item) => item['shopCode'] != shopCode).toList();
    _admin = _admin.copyWith(shopDetails: updatedShopDetails);
    notifyListeners();
  }

  // Check if a shop is in shopDetails
  bool isShopInDetails(String shopCode) {
    return _admin.shopDetails.any((item) => item['shopCode'] == shopCode);
  }

  // Clear shopDetails (removes all shops)
  void clearShopDetails() {
    _admin = _admin.copyWith(shopDetails: []);
    notifyListeners();
  }

  // Get admin token
  String getAdminToken() {
    return _admin.token;
  }
}
