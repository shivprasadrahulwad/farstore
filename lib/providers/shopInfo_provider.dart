import 'package:farstore/models/category.dart';
import 'package:farstore/models/charges.dart';
import 'package:farstore/models/coupon.dart';
import 'package:farstore/models/rating.dart';
import 'package:farstore/models/shopInfo.dart';
import 'package:flutter/material.dart';


class ShopInfoProvider with ChangeNotifier {
  ShopInfo? _shopInfo;

  ShopInfo? get shopInfo => _shopInfo;

  // Set ShopInfo
  void setShopInfo(ShopInfo shopInfo) {
    _shopInfo = shopInfo;
    notifyListeners();
  }

  double get averageRating {
    if (_shopInfo?.rating != null && _shopInfo!.rating!.isNotEmpty) {
      double total = _shopInfo!.rating!.map((r) => r.rating).reduce((a, b) => a + b);
      return total / _shopInfo!.rating!.length;
    }
    return 0.0; 
  }

List<Coupon> fetchLatestCoupons() {

    if (_shopInfo?.coupon != null) {
      List<Coupon> couponList = [];
      _shopInfo!.coupon!.forEach((key, value) {
        couponList.add(Coupon.fromMap(value));  
      });
      return couponList;
    }
    return [];
  }


 Map<String, int>? calculateTimeDifference() {
    try {
      if (_shopInfo == null) {
        return null;
      }

      if (_shopInfo!.charges == null) {
        print('Charges is null');
        return null;
      }

      final charges = _shopInfo!.charges!;
      
      if (charges.endTime == null) {
        print('EndTime is null');
        return null;
      }

      final now = DateTime.now();
      final endDate = charges.endDate;
      
      final endDateTime = DateTime(
        endDate?.year ?? now.year,
        endDate?.month ?? now.month,
        endDate?.day ?? now.day,
        charges.endTime!.hour,
        charges.endTime!.minute,
      );

      final difference = endDateTime.difference(now);

      if (difference.isNegative) {
        return null;
      }

      return {
        'days': difference.inDays,
        'hours': difference.inHours % 24,
        'minutes': difference.inMinutes % 60,
        'seconds': difference.inSeconds % 60,
      };
    } catch (e) {
      return null;
    }
  }

  void updateShopInfo({
    String? shopName,
    int? number,
    String? address,
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
    List<Rating>? rating,
  }) {
    if (_shopInfo != null) {
      _shopInfo = _shopInfo!.copyWith(
        shopName: shopName,
        number: number,
        address: address,
        shopCode: shopCode,
        categories: categories,
        delPrice: delPrice,
        coupon: coupon,
        offerImages: offerImages,
        offerDes: offerDes,
        offertime: offertime,
        socialLinks: socialLinks,
        lastUpdated: lastUpdated,
        charges: charges,
        rating: rating,
      );
      notifyListeners();
    }
  }

  // Clear ShopInfo
  void clearShopInfo() {
    _shopInfo = null;
    notifyListeners();
  }
}