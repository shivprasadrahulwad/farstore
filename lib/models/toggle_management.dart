import 'package:hive/hive.dart';

enum ToggleType {
  coupon,
  charges,
  offerDes, 
  offerImage; 

  String get key => '${name}Toggle';
}

class ToggleManager {
  static const String _boxName = 'toggles';
  static late Box _toggleBox;
  static bool _isInitialized = false;

  static Future<void> init() async {
    if (!_isInitialized) {
      _toggleBox = await Hive.openBox(_boxName);
      _isInitialized = true;
    }
  }

  static bool getToggleState(ToggleType type) {
    _ensureInitialized();
    return _toggleBox.get(type.key, defaultValue: false);
  }

  static Future<void> saveToggleState(ToggleType type, bool value) async {
    _ensureInitialized();
    await _toggleBox.put(type.key, value);
  }

  static Future<void> dispose() async {
    if (_isInitialized && _toggleBox.isOpen) {
      await _toggleBox.close();
      _isInitialized = false;
    }
  }

  static void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError('ToggleManager must be initialized before use');
    }
  }
}
