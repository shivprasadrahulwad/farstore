import 'package:farstore/features/admin/services/admin_services.dart';
import 'package:farstore/models/coupon.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'hive_service.g.dart';

// Hive model for shop info
@HiveType(typeId: 0)
class ShopInfoHive extends HiveObject {
  @HiveField(0)
  List<Map<String, dynamic>> categories;

  @HiveField(1)
  Map<String, dynamic> coupon;

  @HiveField(2)
  Map<String, dynamic> offerImages;

  @HiveField(3)
  Map<String, dynamic>? offerDes;

  @HiveField(4)
  DateTime offerTime;

  @HiveField(5)
  Map<String, String> socialLinks;

  @HiveField(6)
  int delPrice;

  @HiveField(7)
  String shopName;

  @HiveField(8)
  String number;

  @HiveField(9)
  String address;

  @HiveField(10)
  String shopCode;

  @HiveField(11)
  DateTime lastUpdated;

  @HiveField(12)
  Map<String, dynamic> charges;

  @HiveField(13)
  String time;

  ShopInfoHive({
    required this.categories,
    required this.coupon,
    required this.offerImages,
    required this.offerDes,
    required this.offerTime,
    required this.socialLinks,
    required this.delPrice,
    required this.shopName,
    required this.number,
    required this.address,
    required this.shopCode,
    required this.lastUpdated,
    required this.charges,
    required this.time,
  });

  factory ShopInfoHive.fromMap(Map<String, dynamic> map) {
    return ShopInfoHive(
      categories: List<Map<String, dynamic>>.from(map['categories'] ?? []),
      coupon: Map<String, dynamic>.from(map['coupon'] ?? {}),
      offerImages: Map<String, dynamic>.from(map['offerImages'] ?? {}),
      offerDes: map['offerDes'] != null ? Map<String, dynamic>.from(map['offerDes']) : null,
      offerTime: DateTime.parse(map['offerTime']),
      socialLinks: Map<String, String>.from(map['socialLinks'] ?? {}),
      delPrice: map['delPrice'] ?? 0,
      shopName: map['shopName'] ?? '',
      number: map['number'] ?? '',
      address: map['address'] ?? '',
      shopCode: map['shopCode'] ?? '',
      lastUpdated: DateTime.parse(map['lastUpdated']),
      charges: Map<String, dynamic>.from(map['charges'] ?? {}),
      time: map['time'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categories': categories,
      'coupon': coupon,
      'offerImages': offerImages,
      'offerDes': offerDes,
      'offerTime': offerTime.toIso8601String(),
      'socialLinks': socialLinks,
      'delPrice': delPrice,
      'shopName': shopName,
      'number': number,
      'address': address,
      'shopCode': shopCode,
      'lastUpdated': lastUpdated.toIso8601String(),
      'time': time,
    };
  }
}

@HiveType(typeId: 1)
class QueueItem extends HiveObject {
  @HiveField(0)
  String operation;

  @HiveField(1)
  Map<String, dynamic> data;

  @HiveField(2)
  DateTime timestamp;

  QueueItem({
    required this.operation,
    required this.data,
    required this.timestamp,
  });
}

class HiveService {
  static const String shopInfoBoxName = 'shopInfo';
  static const String queueBoxName = 'updateQueue';
  static final AdminServices adminServices = AdminServices();

  // Initialize Hive
  static Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ShopInfoHiveAdapter());
    Hive.registerAdapter(QueueItemAdapter());

    // Open the boxes
    await _openBox<ShopInfoHive>(shopInfoBoxName);
    await _openBox<QueueItem>(queueBoxName);
  }

  static Future<void> _openBox<T>(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<T>(boxName);
    }
  }

  // Add or update shop info in Hive and database
  static Future<void> addOrUpdateShopInfo({
    required BuildContext context,
    required List<Map<String, dynamic>> categories,
    required Map<String, dynamic> coupon,
    required Map<String, dynamic> offerImages,
    required Map<String, dynamic>? offerDes,
    required DateTime offerTime,
    required Map<String, String> socialLinks,
    required int delPrice,
    required String shopName,
    required String number,
    required String address,
    required String shopCode,
    required Map<String, dynamic> charges,
    required String time,
  }) async {
    final shopInfo = ShopInfoHive(
      categories: categories,
      coupon: coupon,
      offerImages: offerImages,
      offerDes: offerDes,
      offerTime: offerTime,
      socialLinks: socialLinks,
      delPrice: delPrice,
      shopName: shopName,
      number: number,
      address: address,
      shopCode: shopCode,
      lastUpdated: DateTime.now(),
      charges: charges,
      time: time,
    );

    try {
      await adminServices.addShopInfo(
        context: context,
        categories: categories,
        coupon: coupon,
        offerImages: offerImages,
        offerDes: offerDes,
        offerTime: offerTime,
        socialLinks: socialLinks.values.toList(),
        delPrice: delPrice,
        shopName: shopName,
        number: number,
        address: address,
        shopCode: shopCode,
        charges: charges,
        time: time,
      );

      final box = Hive.box<ShopInfoHive>(shopInfoBoxName);
      await box.put('currentShop', shopInfo);
      print("Shop info updated in database and Hive");
    } catch (e) {
      print("Failed to update database: $e");
      await addToQueue('update', shopInfo.toMap());
      print("Update queued for later synchronization");
    }
  }

  // Add operation to update queue
  static Future<void> addToQueue(String operation, Map<String, dynamic> data) async {
    final queueBox = Hive.box<QueueItem>(queueBoxName);
    await queueBox.add(QueueItem(
      operation: operation,
      data: data,
      timestamp: DateTime.now(),
    ));
  }

  // Process queued updates
  static Future<void> processQueue(BuildContext context) async {
  final queueBox = Hive.box<QueueItem>(queueBoxName);
  final shopInfoBox = Hive.box<ShopInfoHive>(shopInfoBoxName);

  for (var i = 0; i < queueBox.length; i++) {
    final item = queueBox.getAt(i);
    if (item != null) {
      try {
        await adminServices.addShopInfo(
          context: context,
          categories: List<Map<String, dynamic>>.from(item.data['categories']),
          coupon: Map<String, dynamic>.from(item.data['coupon']),
          offerImages: Map<String, dynamic>.from(item.data['offerImages'] ?? {}),
          offerDes: item.data['offerDes'] != null ? Map<String, dynamic>.from(item.data['offerDes']) : null,
          offerTime: DateTime.parse(item.data['offerTime']),
          socialLinks: item.data['socialLinks'].values.toList(),
          delPrice: item.data['delPrice'],
          shopName: item.data['shopName'],
          number: item.data['number'],
          address: item.data['address'],
          shopCode: item.data['shopCode'],
          charges: item.data['charges'],
          time: item.data['time'],
        );

        await shopInfoBox.put('currentShop', ShopInfoHive.fromMap(item.data));
        await queueBox.deleteAt(i);
        i--; // Adjust index after deletion
        print("Queued update processed successfully");
      } catch (e) {
        print("Failed to process queued update: $e");
      }
    }
  }
}

  // Check for updates in shop info
  static Future<void> checkForUpdates(BuildContext context) async {
    try {
      final Map<String, dynamic> latestData =
          await adminServices.fetchLatestShopInfo(context);
      final currentData = await getShopInfo();

      final latestShopInfo = ShopInfoHive.fromMap(latestData);

      if (currentData == null || latestShopInfo.lastUpdated.isAfter(currentData.lastUpdated)) {
        final box = Hive.box<ShopInfoHive>(shopInfoBoxName);
        await box.put('currentShop', latestShopInfo);
        print("Shop info updated from database");
      }
    } catch (e) {
      print("Failed to check for updates: $e");
      
    }
  }

  // Retrieve shop info from Hive
  static Future<ShopInfoHive?> getShopInfo() async {
    final box = Hive.box<ShopInfoHive>(shopInfoBoxName);
    return box.get('currentShop');
  }
}
