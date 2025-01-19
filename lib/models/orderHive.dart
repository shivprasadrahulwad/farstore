import 'package:farstore/models/order.dart';
import 'package:hive/hive.dart';

part 'orderHive.g.dart';

@HiveType(typeId: 14)
class OrderHive extends HiveObject {
  @HiveField(0)
  late String orderId;

  @HiveField(1)
  late int status;

  OrderHive({
    required this.orderId,
    required this.status,
  });

  // Create from Order model
  factory OrderHive.fromOrder(Order order) {
    return OrderHive(
      orderId: order.id,
      status: order.status,
    );
  }

  // Update status
  void updateStatus(int newStatus) {
    status = newStatus;
    save(); // Save changes to Hive
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'status': status,
    };
  }

  factory OrderHive.fromJson(Map<String, dynamic> json) {
    return OrderHive(
      orderId: json['orderId'] as String,
      status: json['status'] as int,
    );
  }

  @override
  String toString() {
    return 'OrderHive(orderId: $orderId, status: $status)';
  }
}