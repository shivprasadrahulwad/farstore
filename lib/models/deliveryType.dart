import 'package:hive/hive.dart';

part 'deliveryType.g.dart';

@HiveType(typeId: 15)
class DeliveryType {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int id;

  DeliveryType({required this.name, required this.id});

  static final cashOnDelivery = DeliveryType(name: 'Cash on Delivery', id: 0);
  static final onlinePayment = DeliveryType(name: 'Online Payment', id: 1);

  // Helper method to get a list of all types
  static List<DeliveryType> get allTypes => [cashOnDelivery, onlinePayment];
}
