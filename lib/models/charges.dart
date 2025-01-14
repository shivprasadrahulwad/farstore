import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'charges.g.dart';


@HiveType(typeId: 8)
class Charges extends HiveObject {
  @HiveField(0)
  final bool isDeliveryChargesEnabled;

  @HiveField(1)
  final double? deliveryCharges;

  @HiveField(2)
  final String? startDateStr;

  @HiveField(3)
  final String? endDateStr;

  @HiveField(4)
  final int? startTimeMinutes;

  @HiveField(5)
  final int? endTimeMinutes;

  // Getters remain the same
  DateTime? get startDate {
    try {
      return startDateStr != null ? DateTime.parse(startDateStr!) : null;
    } catch (e) {
      print('Error parsing startDate: $e');
      return null;
    }
  }

  DateTime? get endDate {
    try {
      return endDateStr != null ? DateTime.parse(endDateStr!) : null;
    } catch (e) {
      print('Error parsing endDate: $e');
      return null;
    }
  }

  TimeOfDay? get startTime => startTimeMinutes != null ? 
    minutesToTimeOfDay(startTimeMinutes!) : null;

  TimeOfDay? get endTime => endTimeMinutes != null ? 
    minutesToTimeOfDay(endTimeMinutes!) : null;

  Charges({
    required this.isDeliveryChargesEnabled,
    this.deliveryCharges,
    DateTime? startDate,
    DateTime? endDate,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  }) :
    startDateStr = startDate?.toIso8601String(),
    endDateStr = endDate?.toIso8601String(),
    startTimeMinutes = startTime != null ? timeOfDayToMinutes(startTime) : null,
    endTimeMinutes = endTime != null ? timeOfDayToMinutes(endTime) : null;

  // Updated fromMap method to handle API response format
  factory Charges.fromMap(Map<String, dynamic> map) {
    double? parseDeliveryCharges(dynamic value) {
      try {
        if (value == null) return null;
        if (value is double) return value;
        if (value is int) return value.toDouble();
        if (value is String) return double.tryParse(value);
        return null;
      } catch (e) {
        print('Error parsing delivery charges: $e');
        return null;
      }
    }

    DateTime? parseDateTime(dynamic dateValue) {
      try {
        if (dateValue == null) return null;
        if (dateValue is String) {
          return DateTime.parse(dateValue);
        }
        return null;
      } catch (e) {
        print('Error parsing date: $e');
        return null;
      }
    }

    TimeOfDay? parseTimeOfDay(dynamic minutes) {
      try {
        if (minutes == null) return null;
        final intMinutes = int.tryParse(minutes.toString());
        return intMinutes != null ? minutesToTimeOfDay(intMinutes) : null;
      } catch (e) {
        print('Error parsing time: $e');
        return null;
      }
    }

    // Debug prints to track the parsing process
    print('Parsing map: $map');
    
    final startDate = parseDateTime(map['startDate']);
    final endDate = parseDateTime(map['endDate']);
    final startTime = parseTimeOfDay(map['startTime']);
    final endTime = parseTimeOfDay(map['endTime']);

    print('Parsed values:');
    print('startDate: $startDate');
    print('endDate: $endDate');
    print('startTime: $startTime');
    print('endTime: $endTime');

    return Charges(
      isDeliveryChargesEnabled: map['isDeliveryChargesEnabled'] ?? false,
      deliveryCharges: parseDeliveryCharges(map['deliveryCharges']),
      startDate: startDate,
      endDate: endDate,
      startTime: startTime,
      endTime: endTime,
    );
  }

  // Rest of the methods remain the same
  static int timeOfDayToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  static TimeOfDay minutesToTimeOfDay(int minutes) {
    return TimeOfDay(
      hour: minutes ~/ 60,
      minute: minutes % 60,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isDeliveryChargesEnabled': isDeliveryChargesEnabled,
      'deliveryCharges': deliveryCharges,
      'startDateStr': startDateStr,
      'endDateStr': endDateStr,
      'startTimeMinutes': startTimeMinutes,
      'endTimeMinutes': endTimeMinutes,
    };
  }

  static const String boxName = 'charges_box';
  static const String chargesKey = 'current_charges';



  static Future<void> saveToHive(
    bool isDeliveryChargesEnabled,
    double? deliveryCharges,
    DateTime? startDate,
    DateTime? endDate,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  ) async {
    try {
      final box = await Hive.openBox<Charges>(boxName);
      final charges = Charges(
        isDeliveryChargesEnabled: isDeliveryChargesEnabled,
        deliveryCharges: deliveryCharges,
        startDate: startDate,
        endDate: endDate,
        startTime: startTime,
        endTime: endTime,
      );
      await box.put(chargesKey, charges);
      print('Saved to Hive: ${charges.toMap()}');
    } catch (e) {
      print('Error saving to Hive: $e');
      rethrow;
    }
  }

  static Future<Charges?> getFromHive() async {
    try {
      final box = await Hive.openBox<Charges>(boxName);
      final charges = box.get(chargesKey);
      print('Retrieved from Hive: ${charges?.toMap()}');
      return charges;
    } catch (e) {
      print('Error retrieving from Hive: $e');
      rethrow;
    }
  }

  static Future<void> deleteFromHive() async {
    try {
      final box = await Hive.openBox<Charges>(boxName);
      await box.delete(chargesKey);
      print('Deleted charges from Hive');
    } catch (e) {
      print('Error deleting from Hive: $e');
      rethrow;
    }
  }

  // Helper method to validate time range
  bool isValidTimeRange() {
    if (startTime == null || endTime == null) return true;
    final startMinutes = timeOfDayToMinutes(startTime!);
    final endMinutes = timeOfDayToMinutes(endTime!);
    return endMinutes > startMinutes;
  }

  // Helper method to validate date range
  bool isValidDateRange() {
    if (startDate == null || endDate == null) return true;
    return endDate!.isAfter(startDate!);
  }

  //  Map<String, int>? getTimeDifferenceFromNow() {
  //   if (endTime == null) {
  //     return null; // No end time available
  //   }

  //   // Get the current time
  //   final now = DateTime.now();

  //   // If `endDate` is null, assume it's today
  //   final effectiveEndDate = endDate ?? now;

  //   // Combine `endDate` and `endTime` to create a full DateTime object
  //   final endDateTime = DateTime(
  //     effectiveEndDate.year,
  //     effectiveEndDate.month,
  //     effectiveEndDate.day,
  //     endTime!.hour,
  //     endTime!.minute,
  //   );

  //   // Calculate the difference
  //   final difference = endDateTime.difference(now);

  //   if (difference.isNegative) {
  //     return null; // End time has already passed
  //   }

  //   final days = difference.inDays;
  //   final hours = difference.inHours % 24;
  //   final minutes = difference.inMinutes % 60;
  //   final seconds = difference.inSeconds % 60;

  //   return {
  //     'days': days,
  //     'hours': hours,
  //     'minutes': minutes,
  //     'seconds': seconds,
  //   };
  // }
}



