import 'package:farstore/onboard/onboard_screen.dart';
import 'package:flutter/material.dart';


String uri = 'http://192.168.2.160:5000';

class GlobalVariables {
  // COLORS
  static const appBarGradient = LinearGradient( 
    colors: [
      Color.fromARGB(255, 29, 201, 192),
      Color.fromARGB(255, 125, 221, 216),
    ],
    stops: [0.5, 1.0],
  );

  static const primaryColor = Color.fromRGBO(255, 153, 0, 1);
  static const secondaryColor = Color.fromRGBO(255, 153, 0, 1);
  static const blueTextColor = Color(0xFF326BDC);
  static const lightBlueTextColor = Color.fromARGB(255, 115, 144, 189);
  static const savingColor = Color(0xFFDCE8FF);
  static const yelloColor = Color(0xFFfbcb44);
  static const lightGreen = Color(0xFFE9FFEE);
  static const greenColor = Color(0xFF328616);
  static const blueBackground = Color(0xFFdce8ff);
  static const backgroundColor = Color(0xFFF5F6FB);
  static const dividerColor = Color(0xFFE1E1E1);
  static const greyTextColor = Color.fromARGB(255, 125, 125, 125);
  static const Color greyBackgroundCOlor = Color(0xffebecee);
  static const greyBlueBackgroundColor=Color.fromARGB(255, 228, 232, 245);
  static const faintBlackColor =  Color.fromARGB(255, 70, 70, 70);
  
  static var selectedNavBarColor = Colors.cyan[800]!;
  static const unselectedNavBarColor = Colors.black87;
  static const greyBlueColor= Color(0xFF9197A5);
  static const cartFontWeight = FontWeight.bold;

  /////////////////////////////////////////////////////////////
  //providing source id from where products are fetched
  static const userId = '667c4e8e2f6dec6e82d1ada9';
  static const bagHandelingCharges = 10;
  static String _shopCode = '';

  // Method to set shop code
  static void setShopCode(String code) {
    _shopCode = code;
  }

  // Method to get shop code
  static String get shopCode => _shopCode;

  static const List<String> carouselImages = [
    'https://res.cloudinary.com/dybzzlqhv/image/upload/fl_preserve_transparency/v1720322974/shop/vpwpnauloikyllwymymj.jpg?_s=public-apps',
    'https://res.cloudinary.com/dybzzlqhv/image/upload/fl_preserve_transparency/v1720322974/shop/p1d5wqzq1plbclov5wbh.jpg?_s=public-apps',
    'https://res.cloudinary.com/dybzzlqhv/image/upload/fl_preserve_transparency/v1720322974/shop/vtegngurflbmk0cfmnl9.jpg?_s=public-apps',
  ];


static const List<OnboardingItem> onboardAssets = [
  OnboardingItem(
    image: 'assets/images/offer.png',
    title: 'Exclusive Offers',
    description: 'Discover amazing deals and exclusive offers just for you.',
  ),
  OnboardingItem(
    image: 'assets/images/offer.png',
    title: 'Fast Delivery',
    description: 'Get your products delivered quickly and safely.',
  ),
  OnboardingItem(
    image: 'assets/images/offer.png',
    title: 'Secure Payment',
    description: 'Enjoy easy and secure payment options.',
  ),
];

  static const List<Map<String, String>> categoryImages = [
    {
      'title': 'BreakFast',
      'image': 'images/breakfast.png',
    },
    {
      'title': 'Snacks',
      'image': 'images/food.png',
    },
    {
      'title': 'Drinks',
      'image': 'images/drinks.png',
    },
    {
      'title': 'Meal',
      'image': 'images/meal.png',
    },
  ];

  static const List<Map<String, dynamic>> groceryImages = [
    {
      'title': 'Atta, Rice & Dal',
      'image': 'https://res.cloudinary.com/dybzzlqhv/image/upload/v1722340399/vegetables/shop/fyqees3efjam9g8ojqpw.png',
      'sub-title': ['Lehenga', 'cloths', 'dress','watch','shivprasad','Atta', 'Rice','Dal'],
    },
    {
      'title': 'Oil, Ghee & Masala',
      'image': 'https://res.cloudinary.com/dybzzlqhv/image/upload/v1722340397/vegetables/shop/orxnyiphkdxp6pcgojho.png',
      'sub-title': ['Oil', 'Ghee', 'Masala'],
    },
    {
      'title': 'Tea, Coffee & Biscuits',
      'image': 'https://res.cloudinary.com/dybzzlqhv/image/upload/v1722340399/vegetables/shop/uifpttlsexudsljshddx.png',
      'sub-title': ['Tea', 'Coffee', 'Biscuits'],
    },
    {
      'title': 'Dry Fruits & Millet',
      'image': 'https://res.cloudinary.com/dybzzlqhv/image/upload/v1722340398/vegetables/shop/uithcn1aubkhyha51vs6.png',
      'sub-title': ['Dry Fruits', 'Millet'],
    },
    {
      'title': 'Snacks & Sauces',
      'image': 'https://res.cloudinary.com/dybzzlqhv/image/upload/v1722340399/vegetables/shop/docwo7fyzs6xpgedbnv3.png',
      'sub-title': ['Snacks', 'Sauces'],
    },
    {
      'title': 'Sweet & Namkeen',
      'image': 'https://res.cloudinary.com/dybzzlqhv/image/upload/v1722341313/vegetables/shop/bvsbjyepuugf3ntildat.png',
      'sub-title': ['Sweets', 'Chocolates', 'Namkeen'],
    },
  ];



  static const List<Map<String, dynamic>> beautyImages = [
    {
      'title': 'Bath & Body',
      'image': 'https://res.cloudinary.com/dybzzlqhv/image/upload/v1722340398/vegetables/shop/o6fkuqd033risyy2mpna.png',
      'sub-title': ['soaps', 'Toothpest','Handwash'],
    },
    {
      'title': 'Skin, Face & Hair',
      'image': 'https://res.cloudinary.com/dybzzlqhv/image/upload/v1722340398/vegetables/shop/awso6u49jh3yoyi2cw9e.png',
      'sub-title': ['Hair Oil', 'Shampoo','Body Lotion', 'Face Cream/Wash'],
    },
    {
      'title': 'Others',
      'image': 'https://res.cloudinary.com/dybzzlqhv/image/upload/v1722340398/vegetables/shop/qdhgmtbf2oqz2u7edpyg.png',
      'sub-title': ['Detergent', 'Millet'],
    },
   
  ];

  

  static const List<Map<String, dynamic>> groceryAdminImages = [
    {
      'title': 'Atta, Rice & Dal',
      'image': 'images/PaniPuri.png',
      'sub-title': ['Atta', 'Rice', 'Dal', "all"],
    },
    {
      'title': 'Oil, Ghee & Masala',
      'image': 'images/PaniPuri.png',
      'sub-title': ['Oil', 'Ghee', 'Masala', 'all'],
    },
    {
      'title': 'Dry Fruits & Cereals',
      'image': 'images/PaniPuri.png',
      'sub-title': ['Dry Fruits', 'Cereals', 'all'],
    },
    {
      'title': 'Bakery & Biscuits',
      'image': 'images/PaniPuri.png',
      'sub-title': ['Bakery', 'Biscuits', 'all'],
    },
    {
      'title': 'Biscuits & Bread',
      'image': 'images/PaniPuri.png',
      'sub-title': ['Biscuits', 'Bread', 'all'],
    },
    {
      'title': 'Sweets & Chocolates',
      'image': 'images/PaniPuri.png',
      'sub-title': ['Sweets', 'Chocolates', 'all'],
    },
  ];

}
