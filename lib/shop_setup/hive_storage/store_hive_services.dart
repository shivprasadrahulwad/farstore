import 'package:farstore/models/category.dart' as CustomCategory;
import 'package:farstore/models/category.dart';
import 'package:farstore/models/charges.dart';
import 'package:farstore/models/coupon.dart';
import 'package:farstore/models/offerDes.dart';
import 'package:farstore/providers/shopInfo_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class StoreHiveService {
  final BuildContext context;

  StoreHiveService(this.context);

  Future<void> initCouponHive() async {
    try {
      // Open or get the existing Hive box for coupons
      final couponBox = await Hive.openBox<Coupon>('coupons');

      print('Initializing Coupon Box...');
      await couponBox.clear();
      print('Cleared existing coupons from Hive');

      // Get shop info from provider
      final shopInfoProvider =
          Provider.of<ShopInfoProvider>(context, listen: false);
      final shopInfo = shopInfoProvider.shopInfo;
      final couponsList = shopInfo?.coupon?.entries.toList();

      if (shopInfo != null && couponsList != null && couponsList.isNotEmpty) {
        print('Found ${couponsList.length} coupons in ShopInfo');

        for (var entry in couponsList) {
          final couponData = entry.value;

          print(
              'Processing coupon data: $couponData (Type: ${couponData.runtimeType})');

          // Handle different coupon data formats
          if (couponData is List) {
            // If coupon data is a list of coupons
            for (var couponItem in couponData) {
              if (couponItem is Map<String, dynamic>) {
                try {
                  final coupon = _createCouponFromMap(couponItem);
                  print(
                      'Adding Coupon: ${coupon.couponCode}, Off: ${coupon.off}, Price: ${coupon.price}');
                  await couponBox.add(coupon);
                } catch (e) {
                  print('Error adding coupon from List: $e');
                }
              } else {
                print('Invalid coupon item format in List: $couponItem');
              }
            }
          } else if (couponData is Map<String, dynamic>) {
            // If coupon data is a single coupon map
            try {
              final coupon = _createCouponFromMap(couponData);
              print(
                  'Adding Coupon: ${coupon.couponCode}, Off: ${coupon.off}, Price: ${coupon.price}');
              await couponBox.add(coupon);
            } catch (e) {
              print('Error adding individual coupon: $e');
            }
          } else {
            print('Invalid coupon data format: $couponData');
          }
        }

        print('Finished adding coupons to Hive');
      } else {
        print('No coupons available from server');
      }
    } catch (e, stackTrace) {
      print('Error in initCouponHive: $e');
      print('Stack trace: $stackTrace');

      // Optional: Error handling mechanism (modify as per your app's error handling)
      _showErrorSnackBar('Error initializing coupons. Please try again.');
    }
  }

  // Helper method to create Coupon from a map
  Coupon _createCouponFromMap(Map<String, dynamic> couponItem) {
    return Coupon(
      couponCode: couponItem['couponCode'] as String,
      off: (couponItem['off'] as num).toDouble(),
      price: (couponItem['price'] as num).toDouble(),
    );
  }

  // Optional method for showing error snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> initOfferDesHive() async {
    try {
      // Open or get the existing Hive box for offer descriptions
      final offerDesBox = await Hive.openBox<offerDes>('offerDes');

      print('Initializing OfferDes Box...');
      await offerDesBox.clear();
      print('Cleared existing offer descriptions from Hive');

      // Get shop info from provider
      final shopInfoProvider =
          Provider.of<ShopInfoProvider>(context, listen: false);
      final shopInfo = shopInfoProvider.shopInfo;

      // Extract offer descriptions
      final offerDescriptionsList = shopInfo?.offerDes?['descriptions'];

      if (shopInfo != null &&
          offerDescriptionsList != null &&
          offerDescriptionsList is List) {
        print(
            'Found ${offerDescriptionsList.length} offer descriptions in ShopInfo');

        for (var offerItem in offerDescriptionsList) {
          if (offerItem is Map<String, dynamic>) {
            try {
              final offerDesItem = _createOfferDesFromMap(offerItem);
              print(
                  'Adding Offer Description: Title: ${offerDesItem.title}, Icon: ${offerDesItem.icon}');
              await offerDesBox.add(offerDesItem);
            } catch (e) {
              print('Error adding offer description: $e');
            }
          } else {
            print('Invalid offer description item format: $offerItem');
          }
        }

        print('Finished adding offer descriptions to Hive');
      } else {
        print('No offer descriptions available from server');
      }
    } catch (e, stackTrace) {
      print('Error in initOfferDesHive: $e');
      print('Stack trace: $stackTrace');

      // Optional: Error handling mechanism
      _showErrorSnackBar(
          'Error initializing offer descriptions. Please try again.');
    }
  }

// Helper method to create offerDes from a map
  offerDes _createOfferDesFromMap(Map<String, dynamic> offerItem) {
    return offerDes(
      title: offerItem['title'] as String? ?? '',
      description: offerItem['description'] as String? ?? '',
      icon: offerItem['icon'] as String? ?? 'Icons.local_offer',
    );
  }

  Future<void> initCategoryHive() async {
    try {
      final categoryBox =
          await Hive.openBox<CustomCategory.Category>('categories');

      print('---Initializing Category Box...');
      await categoryBox.clear();
      print('Cleared existing categories from Hive');

      final shopInfoProvider =
          Provider.of<ShopInfoProvider>(context, listen: false);
      final shopInfo = shopInfoProvider.shopInfo;

      final categoriesList = shopInfo?.categories;

      if (shopInfo != null &&
          categoriesList != null &&
          categoriesList is List) {
        print('Found ${categoriesList.length} categories in ShopInfo');
        print('Found ----------- categories in ShopInfo');

        for (var categoryItem in categoriesList) {
          if (categoryItem is Category) {
            // Already a Category object
            try {
              print(
                  'Adding Category: ID: ${categoryItem.id}, Name: ${categoryItem.categoryName}');
              await categoryBox.add(categoryItem);
            } catch (e) {
              print('Error adding category: $e');
            }
          } else {
            print('Invalid category item format: $categoryItem');
          }
        }

        print('Finished adding categories to Hive');
      } else {
        print('No categories available from server');
      }
    } catch (e, stackTrace) {
      print('Error in initCategoryHive: $e');
      print('Stack trace: $stackTrace');

      _showCategoryErrorSnackBar(
          'Error initializing categories. Please try again.');
    }
  }

  CustomCategory.Category _createCategoryFromMap(
      Map<String, dynamic> categoryItem) {
    return CustomCategory.Category(
      id: categoryItem['_id'] as String,
      categoryName: categoryItem['categoryName'] as String,
      subcategories: List.from(categoryItem['subcategories'] ?? []),
      categoryImage: categoryItem['categoryImage'] as String?,
    );
  }

  void _showCategoryErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }






  Future<void> initChargesHive() async {
  try {
    final chargesBox = await Hive.openBox<Charges>(Charges.boxName);
    
    print('Initializing Charges Box...');
    await chargesBox.clear();
    print('Cleared existing charges from Hive');

    final shopInfoProvider = Provider.of<ShopInfoProvider>(context, listen: false);
    final shopInfo = shopInfoProvider.shopInfo;
    final chargesData = shopInfo?.charges;

    if (shopInfo != null && chargesData != null) {
      print('Found charges data in ShopInfo');
      print('Processing charges data: $chargesData (Type: ${chargesData.runtimeType})');

      try {
        Charges charges;
        
        if (chargesData is Charges) {
          // If it's already a Charges object, use it directly
          charges = chargesData;
        } else if (chargesData is Map<String, dynamic>) {
          // If it's a Map, create Charges from it
          charges = Charges.fromMap(chargesData as Map<String, dynamic>);
        } else if (chargesData is Map) {
          // If it's a Map but not <String, dynamic>
          charges = Charges.fromMap(Map<String, dynamic>.from(chargesData as Map));
        } else {
          throw TypeError();
        }

        // Validate the charges data
        if (!charges.isValidTimeRange()) {
          print('Warning: Invalid time range in charges data');
        }
        if (!charges.isValidDateRange()) {
          print('Warning: Invalid date range in charges data');
        }

        print('Adding Charges: enabled=${charges.isDeliveryChargesEnabled}, '
             'charges=${charges.deliveryCharges}, '
             'startDate=${charges.startDate}, '
             'endDate=${charges.endDate}, '
             'startTime=${charges.startTime}, '
             'endTime=${charges.endTime}');

        await chargesBox.put(Charges.chargesKey, charges);
        print('Successfully added charges to Hive');
      } catch (e) {
        print('Error processing charges data: $e');
      }
    } else {
      print('No charges data available from server');
    }
  } catch (e, stackTrace) {
    print('Error in initChargesHive: $e');
    print('Stack trace: $stackTrace');
    _showErrorSnackBar('Error initializing delivery charges. Please try again.');
  }
}
}
