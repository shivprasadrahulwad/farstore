import 'package:hive/hive.dart';

part 'queue_item.g.dart'; // This is the generated file

@HiveType(typeId: 1) // Ensure this ID is unique within your Hive models
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
