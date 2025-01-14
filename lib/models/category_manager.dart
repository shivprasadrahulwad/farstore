import 'package:hive/hive.dart';

class CategoryManager {
  static final Map<String, Box> _openBoxes = {};
  
  static Future<Box<T>> openBox<T>(String boxName) async {
    try {
      // Check if box is already in our tracking map
      if (_openBoxes.containsKey(boxName)) {
        final box = _openBoxes[boxName];
        // Ensure the box is of the correct type
        if (box is Box<T>) {
          return box as Box<T>;
        } else {
          throw HiveError('Box "$boxName" is of wrong type');
        }
      }

      // If box is open but not in our map, close it first
      if (Hive.isBoxOpen(boxName)) {
        await Hive.box(boxName).close();
      }

      // Open the box and store it in our map
      final box = await Hive.openBox<T>(boxName);
      _openBoxes[boxName] = box;
      return box;
    } catch (e) {
      throw HiveError('Failed to open box "$boxName": $e');
    }
  }

  static Future<void> closeBox(String boxName) async {
    try {
      if (_openBoxes.containsKey(boxName)) {
        await _openBoxes[boxName]?.close();
        _openBoxes.remove(boxName);
      }
    } catch (e) {
      throw HiveError('Failed to close box "$boxName": $e');
    }
  }

  static Future<void> closeAllBoxes() async {
    try {
      for (var box in _openBoxes.values) {
        await box.close();
      }
      _openBoxes.clear();
    } catch (e) {
      throw HiveError('Failed to close all boxes: $e');
    }
  }
}