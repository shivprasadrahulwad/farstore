import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:farstore/constants/global_variables.dart';
import 'package:farstore/features/admin/orders/order_settings_screen.dart';
import 'package:farstore/features/admin/screens/add_product_screen.dart';
import 'package:farstore/features/admin/services/admin_services.dart';
import 'package:farstore/models/category.dart';
import 'package:farstore/models/charges.dart';
import 'package:farstore/models/coupon.dart';
import 'package:farstore/models/offerDes.dart';
import 'package:farstore/models/offerImage.dart';
import 'package:farstore/models/toggle_management.dart';
import 'package:farstore/payment/add_payment_options_screen.dart';
import 'package:farstore/shop_setup/charges_screen.dart';
import 'package:farstore/shop_setup/coupon/coupon_screen.dart';
import 'package:farstore/shop_setup/hive_storage/hive_service.dart';
import 'package:farstore/shop_setup/offers/offer_image_screen.dart';
import 'package:farstore/shop_setup/payment_options_screen.dart';
import 'package:farstore/shop_setup/security_screen.dart';
import 'package:farstore/subscription/subscription_plan_screen.dart';
import 'package:farstore/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ShopSetupScreen extends StatefulWidget {
  static const String routeName = '/setup';
  final Function(Map<String, dynamic>) onChargesUpdated;
  const ShopSetupScreen({Key? key, required this.onChargesUpdated})
      : super(key: key);

  @override
  State<ShopSetupScreen> createState() => _ShopSetupScreenState();
}

class _ShopSetupScreenState extends State<ShopSetupScreen> {
  List<Map<String, dynamic>> categories = [];
  List<Coupon>? coupons;
  List<String> links = []; // List to store links
  List<XFile>? offerImages = [];
  bool _isExpanded = false;
  bool isCouponEnabled = false;
  bool isOfferEnabled = false; // Add this to your state class
  List<Map<String, dynamic>> offerDescriptions = [];
  Map<String, dynamic>? _currentCharges;

  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _youtubeController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final AdminServices adminServices = AdminServices();

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage(
        // imageQuality: 80, // Optional: adjust image quality
        );

    if (images != null && images.isNotEmpty) {
      // Ensure no more than 3 images are selected
      if (offerImages!.length + images.length > 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You can only select up to 3 images.')),
        );
      } else {
        setState(() {
          offerImages?.addAll(images);
        });
      }
    }
  }

  void selectImages() async {
    await _pickImages();
  }

  // Regular expressions for each platform
  final RegExp instagramRegex =
      RegExp(r"^https:\/\/(www\.)?instagram\.com\/[a-zA-Z0-9_.]+\/?$");

  final RegExp youtubeRegex = RegExp(
      r"^https:\/\/(www\.)?youtube\.com\/(watch\?v=|channel\/|user\/|c\/)?[a-zA-Z0-9_-]+$|^https:\/\/youtu\.be\/[a-zA-Z0-9_-]+$");

  final RegExp whatsappRegex = RegExp(
      r"^https:\/\/(www\.)?wa\.me\/[0-9]+$|^https:\/\/(www\.)?api\.whatsapp\.com\/send\?phone=[0-9]+$");

  bool isValidInstagramLink(String url) {
    return instagramRegex.hasMatch(url);
  }

  bool isValidYouTubeLink(String url) {
    return youtubeRegex.hasMatch(url);
  }

  bool isValidWhatsAppLink(String url) {
    return whatsappRegex.hasMatch(url);
  }

  void _saveLinks() {
    final String instagramLink = _instagramController.text.trim();
    final String youtubeLink = _youtubeController.text.trim();
    final String whatsappLink = _whatsappController.text.trim();

    // Validate each link
    if (instagramLink.isNotEmpty && !isValidInstagramLink(instagramLink)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Instagram link is not correct.')),
      );
      return;
    }

    if (youtubeLink.isNotEmpty && !isValidYouTubeLink(youtubeLink)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('YouTube link is not correct.')),
      );
      return;
    }

    if (whatsappLink.isNotEmpty && !isValidWhatsAppLink(whatsappLink)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('WhatsApp link is not correct.')),
      );
      return;
    }

    // Append links to the list if all are valid
    setState(() {
      links.add(instagramLink);
      links.add(youtubeLink);
      links.add(whatsappLink);
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Social links saved successfully!'),
        duration: Duration(seconds: 2),
      ),
    );

    // Clear the fields after saving
    _instagramController.clear();
    _youtubeController.clear();
    _whatsappController.clear();
  }

  Future<List<String>> uploadImagesToCloudinary(
      List<XFile> images, String shopName) async {
    final cloudinary = CloudinaryPublic('dybzzlqhv', 'se7irpmg');
    List<String> cloudinaryUrls = [];

    try {
      for (XFile image in images) {
        if (await File(image.path).exists()) {
          CloudinaryResponse res = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(
              image.path,
              folder: shopName,
            ),
          );
          cloudinaryUrls.add(res.secureUrl);
        }
      }
      return cloudinaryUrls;
    } catch (e) {
      print('Error uploading to Cloudinary: $e');
      throw Exception('Failed to upload images to Cloudinary: $e');
    }
  }

  void addInfo() async {
    // Capture the BuildContext at the start
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final currentContext = context;

    // if (offerImages != null && offerImages!.isNotEmpty) {
    // Get categories from Hive and format them
    final categoryBox = await Hive.openBox<Category>('categories');
    final hiveCategories = categoryBox.values.toList();

    List<Map<String, dynamic>> formattedCategories = hiveCategories
        .where((category) => category != null)
        .map((category) => {
              'categoryName': category.categoryName ?? '',
              'subcategories': category.subcategories ?? [],
              'categoryImage': category.categoryImage,
            })
        .toList();

    // Get coupons from Hive
    final couponBox = await Hive.openBox<Coupon>('coupons');
    final List<Coupon> hiveCoupons = couponBox.values.toList();

    final isCouponsEnabled = ToggleManager.getToggleState(ToggleType.coupon);
    final isOfferDesEnabled = ToggleManager.getToggleState(ToggleType.offerDes);
    final isChargesEnabled = ToggleManager.getToggleState(ToggleType.charges);
    final isOfferImagesEnabled =
        ToggleManager.getToggleState(ToggleType.offerImage);

    Map<String, dynamic> formattedCouponData = {
      'type': {
        'coupons': hiveCoupons
            .map((coupon) =>
                coupon.toMap()) // Use the toMap method of the Coupon class
            .toList(),
        'couponToggle': isCouponsEnabled
      }
    };

    print('Formatted coupon data --- : ${jsonEncode(formattedCouponData)}');

    if (isCouponsEnabled && formattedCouponData.isNotEmpty) {
      print('Coupons found: ${formattedCouponData.length}');
    } else {
      print('No coupons found or toggle is disabled');
    }

    Map<String, String> formattedSocialLinks = {
      for (int i = 0; i < links.length; i++) 'link$i': links[i]
    };

    final charges = await Charges.getFromHive();

    Map<String, dynamic> formatChargesForServer(Charges? charges) {
      if (charges == null) {
        return {'isEnabled': false, 'charges': '0'};
      }

      Map<String, dynamic> formattedCharges = {
        'isEnabled': charges.isDeliveryChargesEnabled,
        'charges': charges.deliveryCharges?.toString() ?? '0'
      };

      // Only add schedule if we have all required schedule data
      if (charges.startDate != null &&
          charges.endDate != null &&
          charges.startTimeMinutes != null &&
          charges.endTimeMinutes != null) {
        formattedCharges['schedule'] = {
          'startDate': charges.startDate?.toUtc().toIso8601String(),
          'endDate': charges.endDate?.toUtc().toIso8601String(),
          'startTime': charges.startTimeMinutes,
          'endTime': charges.endTimeMinutes,
          'isActive': true
        };
      }
      return formattedCharges;
    }

    final formattedCharges = formatChargesForServer(charges);

    // Modified offers handling to match expected List<Map<String, dynamic>>? type
    final offerBox = await Hive.openBox<offerDes>('offerDes');
    Map<String, dynamic>? formattedOfferDes;

    final offersList = offerBox.values.toList();
    final validatedOffers = offersList.take(6).toList();

    if (validatedOffers.isNotEmpty) {
      formattedOfferDes = {
        'type': {
          'descriptions': validatedOffers
              .map((offer) => {
                    'title': offer.title,
                    'description': offer.description,
                    'icon': offer.icon, // Already stored as string
                  })
              .toList(),
          'offerToggle': isOfferEnabled
        }
      };

      print('Formatted offers before sending:');
      print(jsonEncode(formattedOfferDes));
    }
// }

    // Use the stored image URLs directly from Hive
    final offerImageService = OfferImageService();
    await offerImageService.init();
    final offerImageModel = await offerImageService.getOfferImages();
    final storedImageUrls = offerImageModel.imageUrls;
    Map<String, dynamic> formattedOfferImages = {
      'type': {
        'images': offerImageModel.imageUrls,
        'offerImagesToggle': isOfferImagesEnabled
      }
    };

    try {
      await adminServices.addShopInfo(
        context: currentContext, // Use captured context
        shopName: 'Shivay',
        number: '8830031264',
        address: 'Behind Apurv Hospital, Nanded',
        time: '10:00 AM - 8:00 PM',
        shopCode: '123456',
        categories: formattedCategories,
        delPrice: 0,
        coupon: formattedCouponData,
        // offerImages: offerImages!.map((file) => file.path).toList(),
        offerImages: formattedOfferImages,
        offerDes:
            formattedOfferDes, // Now correctly typed as List<Map<String, dynamic>>?
        offerTime: DateTime(2024, 10, 13),
        socialLinks: formattedSocialLinks.values.toList(),
        charges: formattedCharges,
      );

      print('-----save info---');
      print(jsonEncode(formattedOfferDes));

      final shopInfoHive = ShopInfoHive(
        categories: formattedCategories,
        coupon: formattedCouponData,
        // offerImages: offerImages!.map((file) => file.path).toList(),
        offerImages: formattedOfferImages,
        offerDes:
            formattedOfferDes, // Now correctly typed as List<Map<String, dynamic>>?
        offerTime: DateTime(2024, 10, 13),
        socialLinks: formattedSocialLinks,
        delPrice: 0,
        shopName: 'Shivay',
        number: '8830031264',
        address: 'Behind Apurv Hospital, Nanded',
        time: '10:00 AM - 8:00 PM',
        shopCode: '123456',
        lastUpdated: DateTime.now(),
        charges: formattedCharges,
      );

      final box = await Hive.openBox<ShopInfoHive>('shopInfo');

      if (!box.isOpen) {
        print("Error: Box 'shopInfo' could not be opened.");
        return;
      }

      await box.put('currentShop', shopInfoHive);
      print("Shop info saved to Hive: ${shopInfoHive.toMap()}");

      final savedShopInfo = box.get('currentShop');
      if (savedShopInfo != null) {
        print("Retrieved shop info from Hive: ${savedShopInfo.toMap()}");
      } else {
        print("Failed to retrieve shop info from Hive");
      }

      // Use captured ScaffoldMessenger
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Shop info added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error occurred: $e');
      // Use captured ScaffoldMessenger
      if (e.toString().contains('Invalid charges format')) {
        print('Current charges format: ${jsonEncode(formattedCharges)}');
      }
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Error adding shop info: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _instagramController.dispose();
    _youtubeController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Offer banner',
                      style: TextStyle(
                        fontFamily: 'SemiBold',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // const SizedBox(height: 20),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: const Color.fromARGB(
                                              255, 90, 228, 44),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(3),
                                          child: Icon(
                                            Icons.done,
                                            size: 10,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        'Select upto three images',
                                        style: TextStyle(
                                          fontFamily: 'Regular',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: const Color.fromARGB(
                                              255, 90, 228, 44),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(3),
                                          child: Icon(
                                            Icons.done,
                                            size: 10,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        'Displayed on home screen',
                                        style: TextStyle(
                                          fontFamily: 'Regular',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      // Check if there are already 3 images selected
                                      if (offerImages!.length == 3) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Maximum 3 images can be selected.'),
                                          ),
                                        );
                                        return; // Exit the tap event
                                      }

                                      await _pickImages();
                                      setModalState(() {});
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.blueAccent,
                                          width: 3,
                                        ),
                                        borderRadius: BorderRadius.circular(35),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(12),
                                        child: Icon(
                                          Icons.image,
                                          size: 30,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    'Tap to select',
                                    style: TextStyle(
                                        fontFamily: 'Ragular',
                                        fontSize: 12,
                                        color: Colors.blueGrey,
                                        fontStyle: FontStyle.italic),
                                  )
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (offerImages != null && offerImages!.isNotEmpty)
                            CarouselSlider(
                              items: offerImages!.map((image) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Image.file(
                                            File(image.path),
                                            fit: BoxFit.cover,
                                            height: 200,
                                            width: double.infinity,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: GestureDetector(
                                            onTap: () {
                                              setModalState(() {
                                                offerImages!.remove(
                                                    image); // Remove the selected image
                                              });
                                            },
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.all(4),
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }).toList(),
                              options: CarouselOptions(
                                viewportFraction: 1,
                                height: 200,
                              ),
                            )
                          else
                            const Text(
                              '-- No images selected --',
                              style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontFamily: 'Regular',
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold),
                            ),
                          const SizedBox(height: 10),
                          const Divider(color: Colors.black),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: const Color.fromARGB(255, 90, 228, 44),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(3),
                                  child: Icon(
                                    Icons.done,
                                    size: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Select upto three images',
                                style: TextStyle(
                                  fontFamily: 'Regular',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, dd MMM yy').format(now);

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     'Shop setup',
      //     style: TextStyle(
      //         fontFamily: 'Regular',
      //         fontSize: 16,
      //         color: Colors.black,
      //         fontWeight: FontWeight.bold),
      //   ),
      //   backgroundColor: Colors.white,
      //   elevation: 4.0,
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

               Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      const Text(
                                        'Shivprasad',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Medium'),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        'Rahulwad',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Medium'),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        '-ClothyEz-',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Regular'),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      // const Text(
                                      //   'Shop Id: 123456',
                                      //   style: TextStyle(
                                      //       fontSize: 16,
                                      //       fontWeight: FontWeight.bold,
                                      //       fontFamily: 'Regular'),
                                      // ),
                                      // const SizedBox(
                                      //   height: 10,
                                      // ),
                                      const Text(
                                        '8830031264',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Regular'),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      // Text(
                                      //   '${adminProvider.admin.email}',
                                      //   style: const TextStyle(
                                      //       fontSize: 16,
                                      //       fontWeight: FontWeight.normal,
                                      //       fontFamily: 'Regular'),
                                      // ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                            top: 7, bottom: 7),
                                        decoration: BoxDecoration(
                                          color: GlobalVariables.blueBackground, // Light blue background
                                          borderRadius: BorderRadius.circular(
                                              20), // Border radius of 20
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsets.only(left: 12, right: 12),
                                          child: Row(
                                            children: [
                                              // Icon with circular black background
                                              Container(
                                                width: 20,
                                                height: 20,
                                                decoration: const BoxDecoration(
                                                  color: Colors
                                                      .black, // Circular black background
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons
                                                      .done, // Icon of your choice
                                                  size: 15,
                                                  color:
                                                      Colors.white, // Icon color
                                                ),
                                              ),
                                              const SizedBox(
                                                  width:
                                                      10), // Space between the icon and the text
                                              // Text 'Shop ID'
                                              const Text(
                                                'Shop ID: 123456',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color:
                                                      Colors.black, // Text color
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Container(
                            decoration: BoxDecoration(
                              color: const Color(
                                  0xFFFAF6EB), // Light green background color
                              borderRadius:
                                  BorderRadius.circular(15), // Radius of 20
                            ),
                            padding: const EdgeInsets.all(
                                16), // Padding inside the container
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceAround, // Distribute space evenly
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SubscriptionPlanScreen()),
                        );
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize
                                        .min, // Minimize size to fit content
                                    children: [
                                      Image.asset(
                                        'assets/images/orders.png',
                                        width: 22,
                                        height: 22,
                                        fit: BoxFit.cover,
                                      ),
                                      const SizedBox(
                                          height:
                                              8), // Space between icon and label
                                      const Text(
                                        'Subscription',
                                        style: TextStyle(
                                            color: Colors.black, // Text color
                                            fontSize:
                                                14, // Font size of the label
                                            fontFamily: 'Regular',
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize
                                      .min, // Minimize size to fit content
                                  children: [
                                    Image.asset(
                                      'assets/images/orders.png',
                                      width: 22,
                                      height: 22,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(
                                        height:
                                            8), // Space between icon and label
                                    const Text(
                                      'Support',
                                      style: TextStyle(
                                          color: Colors.black, // Text color
                                          fontSize:
                                              14, // Font size of the label
                                          fontFamily: 'Regular',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize
                                      .min, // Minimize size to fit content
                                  children: [
                                    Image.asset(
                                      'assets/images/orders.png',
                                      width: 22,
                                      height: 25,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(
                                        height:
                                            8), // Space between icon and label
                                    const Text(
                                      'Payments',
                                      style: TextStyle(
                                          color: Colors.black, // Text color
                                          fontSize:
                                              14, // Font size of the label
                                          fontFamily: 'Regular',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
     
              const Text(
                'SHOP DETAILS',
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              const Divider(
                color: Colors.grey,
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  final result =
                      await Navigator.pushNamed(context, '/setup-category');
                  if (result != null && result is List<Map<String, dynamic>>) {
                    setState(() {
                      setState(() {
                        categories = result
                            .map((category) => {
                                  'categoryName': category['categoryName'],
                                  'subcategories': category['subcategories'],
                                  'categoryImage': category['categoryImage'],
                                })
                            .toList();
                      });
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Categories saved successfully!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    print('No categories received or invalid data format');
                  }
                },
                child: Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: GlobalVariables.greyBlueBackgroundColor,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.info_outline_rounded,
                        color: GlobalVariables.greyBlueColor,
                        size: 15,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Collection",
                      style: TextStyle(
                        fontFamily: 'Medium',
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: GlobalVariables.greyBlueColor,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AddProductScreen.routeName,
                  );
                },
                child: Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: GlobalVariables.greyBlueBackgroundColor,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.info_outline_rounded,
                        color: GlobalVariables.greyBlueColor,
                        size: 15,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Add products",
                      style: TextStyle(
                        fontFamily: 'Medium',
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: GlobalVariables.greyBlueColor,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'DISCOUNT AND CHARGES',
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              const Divider(
                color: Colors.grey,
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  final CouponScreenResult? result =
                      await Navigator.pushNamed(context, '/coupon')
                          as CouponScreenResult?;

                  if (result != null) {
                    setState(() {
                      coupons = result.coupons;
                      isCouponEnabled =
                          result.isToggled; // Add this variable to your state
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Coupons saved successfully!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: GlobalVariables.greyBlueBackgroundColor,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.info_outline_rounded,
                        color: GlobalVariables.greyBlueColor,
                        size: 15,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Coupon",
                      style: TextStyle(
                        fontFamily: 'Medium',
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: GlobalVariables.greyBlueColor,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                   Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const OfferImageScreen()),
                        );
                  // _showBottomSheet(context);
                },
                child: Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: GlobalVariables.greyBlueBackgroundColor),
                      padding:
                          const EdgeInsets.all(8), // Adjust padding as needed
                      child: const Icon(
                        Icons.info_outline_rounded,
                        color: GlobalVariables.greyBlueColor,
                        size: 15,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "OfferImage",
                      style: TextStyle(
                        fontFamily: 'Medium',
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      padding:
                          const EdgeInsets.all(8), // Adjust padding as needed
                      child: const Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: GlobalVariables.greyBlueColor,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PaymentOptionScreen()),
                  );
                },
                child: Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: GlobalVariables.greyBlueBackgroundColor),
                      padding:
                          const EdgeInsets.all(8), // Adjust padding as needed
                      child: const Icon(
                        Icons.info_outline_rounded,
                        color: GlobalVariables.greyBlueColor,
                        size: 15,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Payment method",
                      style: TextStyle(
                        fontFamily: 'Medium',
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      padding:
                          const EdgeInsets.all(8), // Adjust padding as needed
                      child: const Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: GlobalVariables.greyBlueColor,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  // Navigate to the /offers screen and await the result
                  final List<Map<String, dynamic>>? result =
                      await Navigator.pushNamed(context, '/offers')
                          as List<Map<String, dynamic>>?;

                  if (result != null) {
                    setState(() {
                      offerDescriptions =
                          result; // Update the list with the result
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Offers descriptions saved successfully!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: GlobalVariables.greyBlueBackgroundColor,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.info_outline_rounded,
                        color: GlobalVariables.greyBlueColor,
                        size: 15,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Offers Description",
                      style: TextStyle(
                        fontFamily: 'Medium',
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: GlobalVariables.greyBlueColor,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              GestureDetector(
                onTap: () async {
                  final ChargesData? result = await Navigator.pushNamed(
                    context,
                    ChargesScreen.routeName,
                  ) as ChargesData?;

                  if (result != null) {
                    // Create the base charges map
                    Map<String, dynamic> chargesMap = {
                      'isEnabled': result.isDeliveryChargesEnabled,
                      'charges': result.deliveryCharges?.toString() ?? '0',
                      'description': result.isDeliveryChargesEnabled
                          ? '₹${result.deliveryCharges?.toString() ?? "0"}'
                          : 'Free Delivery',
                    };

                    // Add schedule information if available
                    if (result.startDate != null &&
                        result.endDate != null &&
                        result.startTime != null &&
                        result.endTime != null) {
                      chargesMap['schedule'] = {
                        'startDate':
                            DateFormat('dd MMM, EEE').format(result.startDate!),
                        'endDate':
                            DateFormat('dd MMM, EEE').format(result.endDate!),
                        'startTime': result.startTime!.format(context),
                        'endTime': result.endTime!.format(context),
                        'isActive': true,
                      };

                      // Calculate if the schedule is currently active
                      final now = DateTime.now();
                      final startDateTime = DateTime(
                        result.startDate!.year,
                        result.startDate!.month,
                        result.startDate!.day,
                        result.startTime!.hour,
                        result.startTime!.minute,
                      );
                      final endDateTime = DateTime(
                        result.endDate!.year,
                        result.endDate!.month,
                        result.endDate!.day,
                        result.endTime!.hour,
                        result.endTime!.minute,
                      );

                      chargesMap['schedule']['isActive'] =
                          now.isAfter(startDateTime) &&
                              now.isBefore(endDateTime);
                    }

                    setState(() {
                      _currentCharges = chargesMap;
                    });

                    // Notify parent about the update
                    widget.onChargesUpdated(chargesMap);

                    // Show success message
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Charges updated successfully!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
                child: Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: GlobalVariables.greyBlueBackgroundColor,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.info_outline_rounded,
                        color: GlobalVariables.greyBlueColor,
                        size: 15,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Charges",
                            style: TextStyle(
                              fontFamily: 'Medium',
                              fontSize: 16,
                            ),
                          ),
                          if (_currentCharges != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              _currentCharges!['description'],
                              style: const TextStyle(
                                color: GlobalVariables.greyBlueColor,
                                fontSize: 14,
                              ),
                            ),
                            if (_currentCharges!['schedule'] != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                'Free delivery: ${_currentCharges!['schedule']['startDate']} - ${_currentCharges!['schedule']['endDate']}',
                                style: const TextStyle(
                                  color: GlobalVariables.greyBlueColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ],
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: GlobalVariables.greyBlueColor,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'ADDITIONAL CONFIGURATIONS',
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              const Divider(
                color: Colors.grey,
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OrderSettingsScreen()),
                  );
                },
                child: Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: GlobalVariables.greyBlueBackgroundColor),
                      padding:
                          const EdgeInsets.all(8), // Adjust padding as needed
                      child: const Icon(
                        Icons.info_outline_rounded,
                        color: GlobalVariables.greyBlueColor,
                        size: 15,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Order setting",
                      style: TextStyle(
                        fontFamily: 'Medium',
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      padding:
                          const EdgeInsets.all(8), // Adjust padding as needed
                      child: const Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: GlobalVariables.greyBlueColor,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),

              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddPaymentOptionsScreen()),
                  );
                },
                child: Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: GlobalVariables.greyBlueBackgroundColor),
                      padding:
                          const EdgeInsets.all(8), // Adjust padding as needed
                      child: const Icon(
                        Icons.info_outline_rounded,
                        color: GlobalVariables.greyBlueColor,
                        size: 15,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "add Payment provider",
                      style: TextStyle(
                        fontFamily: 'Medium',
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      padding:
                          const EdgeInsets.all(8), // Adjust padding as needed
                      child: const Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: GlobalVariables.greyBlueColor,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SecurityScreen()),
                  );
                },
                child: Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: GlobalVariables.greyBlueBackgroundColor),
                      padding:
                          const EdgeInsets.all(8), // Adjust padding as needed
                      child: const Icon(
                        Icons.info_outline_rounded,
                        color: GlobalVariables.greyBlueColor,
                        size: 15,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Security",
                      style: TextStyle(
                        fontFamily: 'Medium',
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      padding:
                          const EdgeInsets.all(8), // Adjust padding as needed
                      child: const Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: GlobalVariables.greyBlueColor,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              // const Text(
              //   "Socail Links",
              //   style: TextStyle(
              //     fontFamily: 'SemiBold',
              //     fontSize: 20,
              //   ),
              // ),
              const Text(
                'SOCIAL MEDIA (Optional)',
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              const Divider(
                color: Colors.grey,
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                "Add your socail media links that will be visibale to the user after placing order.",
                style: TextStyle(
                  fontFamily: 'Regular',
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    decoration: BoxDecoration(
                      color: Colors.grey[300], // Grey color
                      borderRadius:
                          BorderRadius.circular(15), // Rounded corners
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Add social links',
                          style: TextStyle(
                            fontFamily: 'Regular',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_drop_down_sharp, // Drawer opener icon
                            size: 24,
                            color: Colors.black, // Change color if needed
                          ),
                          onPressed: () {
                            setState(() {
                              _isExpanded =
                                  !_isExpanded; // Toggle the expansion
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  // GestureDetector(
                  //   onTap: () async {
                  //     addInfo();
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       const SnackBar(
                  //         content: Text('Shop info added successfully'),
                  //       ),
                  //     );
                  //   },
                  //   child: Container(
                  //     padding: const EdgeInsets.all(10),
                  //     decoration: BoxDecoration(
                  //       color: Colors.green,
                  //       borderRadius: BorderRadius.circular(15),
                  //     ),
                  //     child: const Center(
                  //       child: Text(
                  //         'Continue',
                  //         style: TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 16,
                  //           fontFamily: 'SemiBold',
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  if (_isExpanded) ...[
                    const SizedBox(
                        height: 10), // Spacing before the input fields
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: CustomTextFields(
                        hintText: 'Instagram Link',
                        controller: _instagramController,
                        keyboardType: TextInputType.url,
                        maxLines: 1,
                        prefixIcon: Icons.camera_alt, // Instagram icon
                        // onClear: () => _instagramController.clear(), // Clear action for Instagram
                      ),
                    ),
                    const SizedBox(height: 10), // Spacing between input fields
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: CustomTextFields(
                        hintText: 'YouTube Link',
                        controller: _youtubeController,
                        keyboardType: TextInputType.url,
                        maxLines: 1,
                        prefixIcon: Icons.video_label, // YouTube icon
                        // onClear: () => _youtubeController.clear(), // Clear action for YouTube
                      ),
                    ),
                    const SizedBox(height: 10), // Spacing between input fields
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: CustomTextFields(
                        hintText: 'WhatsApp Link',
                        controller: _whatsappController,
                        keyboardType: TextInputType.url,
                        maxLines: 1,
                        prefixIcon: Icons.message, // WhatsApp icon
                        // onClear: () => _whatsappController.clear(), // Clear action for WhatsApp
                      ),
                    ),
                    const SizedBox(height: 10), // Spacing before the button
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10), // Vertical padding
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        color: Colors.green, // Green color
                        borderRadius:
                            BorderRadius.circular(15), // Rounded corners
                      ),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                            _saveLinks();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Social links saved successfully!'),
                                duration: Duration(
                                    seconds: 2), // Duration of the Snackbar
                              ),
                            );
                          }, // Handle tap event
                          child: const Text(
                            'Save Links',
                            style: TextStyle(
                              fontFamily: 'Regular',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Text color
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],

                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      addInfo();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Shop info added successfully'),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(
                        child: Text(
                          'Continue',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'SemiBold',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
