import 'package:hive/hive.dart';
import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';

part 'offerImage.g.dart';

@HiveType(typeId: 10)
class OfferImage extends HiveObject {
  @HiveField(0)
  List<String> imageUrls;

  @HiveField(1)
  DateTime lastUpdated;

  // Changed to create a new modifiable list instead of using const
  OfferImage({
    List<String>? imageUrls,
    DateTime? lastUpdated,
  }) : 
    imageUrls = imageUrls?.toList() ?? [], // Create a new modifiable list
    lastUpdated = lastUpdated ?? DateTime.now();

  bool addImage(String imageUrl) {
    if (imageUrls.length < 3) {
      imageUrls.add(imageUrl);
      lastUpdated = DateTime.now();
      return true;
    }
    return false;
  }

  bool removeImage(String imageUrl) {
    final success = imageUrls.remove(imageUrl);
    if (success) {
      lastUpdated = DateTime.now();
    }
    return success;
  }

  void clearImages() {
    imageUrls.clear();
    lastUpdated = DateTime.now();
  }
}

class OfferImageService {
  static const String boxName = 'offerImageBox';
  static const String key = 'currentOfferImages';
  final cloudinary = CloudinaryPublic('dybzzlqhv', 'se7irpmg');
  Box<OfferImage>? _box;

  Future<void> init() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox<OfferImage>(boxName);
    }
  }

  Future<void> close() async {
    await _box?.close();
    _box = null;
  }

  Future<Box<OfferImage>> _getBox() async {
    if (_box == null || !_box!.isOpen) {
      await init();
    }
    return _box!;
  }

  Future<OfferImage> getOfferImages() async {
    final box = await _getBox();
    var model = box.get(key);
    if (model == null) {
      model = OfferImage(imageUrls: []); // Initialize with empty modifiable list
      await box.put(key, model);
    }
    return model;
  }

  Future<bool> addImage(String imageUrl) async {
    final box = await _getBox();
    OfferImage model = await getOfferImages();
    
    if (model.addImage(imageUrl)) {
      await box.put(key, model);
      return true;
    }
    return false;
  }

  Future<String?> uploadToCloudinary(String localPath) async {
    try {
      final file = File(localPath);
      if (await file.exists()) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(
            file.path,
            folder: 'offer_images',
          ),
        );
        return res.secureUrl;
      }
      return null;
    } catch (e) {
      print('Error uploading to Cloudinary: $e');
      throw Exception('Failed to upload image to Cloudinary: $e');
    }
  }

  Future<bool> removeImage(String imageUrl) async {
    final box = await _getBox();
    OfferImage model = await getOfferImages();
    
    if (model.removeImage(imageUrl)) {
      await box.put(key, model);
      return true;
    }
    return false;
  }

  Future<void> clearImages() async {
    final box = await _getBox();
    OfferImage model = await getOfferImages();
    model.clearImages();
    await box.put(key, model);
  }
}