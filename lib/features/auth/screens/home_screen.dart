// // ignore_for_file: dead_code

// import 'dart:async';

// import 'package:farstore/constants/global_variables.dart';
// import 'package:farstore/features/admin/orders/orders_screen.dart';
// import 'package:farstore/features/admin/screens/add_product_screen.dart';
// import 'package:farstore/features/admin/screens/categories.dart';
// import 'package:farstore/features/admin/screens/sales_screen.dart';
// import 'package:farstore/providers/user_provider.dart';
// import 'package:farstore/shop_setup/categories_setup_screen.dart';
// import 'package:farstore/welcome/shop_details_screen.dart';
// import 'package:farstore/widgets/horizontal_line.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class HomeScreen extends StatefulWidget {
//   static const String routeName = '/home';
//   final String shopCode;
//   const HomeScreen({Key? key, required this.shopCode}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   String currentHint = 'Search Fruits';
//   // List<Product>? products;
//   bool _isFloatingContainerOpen = false;
//   List<Map<String, dynamic>> carts = [];

//   Stream<String> hintStream() async* {
//     while (true) {
//       yield 'Search "Maggi"';
//       await Future.delayed(const Duration(seconds: 2));
//       yield 'Search "Biscuits"';
//       await Future.delayed(const Duration(seconds: 2));
//       yield 'Search "Sweet"';
//       await Future.delayed(const Duration(seconds: 2));
//       yield 'Search "Dryfruits"';
//       await Future.delayed(const Duration(seconds: 2));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (carts.isNotEmpty && !_isFloatingContainerOpen) {
//       setState(() {
//         _isFloatingContainerOpen = true;
//       });
//     }

//     return Scaffold(
//       body: Stack(children: [
//         SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 decoration: const BoxDecoration(
//                     color:
//                         // Colors.grey.withOpacity(0.4), // Set background color here
//                         Colors.white,
//                     borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(20),
//                         bottomRight: Radius.circular(20))),
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(
//                           left: 10,
//                           right: 10,
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const Text(
//                                     "Ready in",
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontFamily: 'SemiBold',
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                   // Text(context.formatString(LocalData.body, ["Shiv"]),),
//                                   Row(
//                                     children: [
//                                       const Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Row(
//                                             children: [
//                                               Text(
//                                                 "8 minutes",
//                                                 style: TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                   fontSize: 25,
//                                                   fontFamily: 'SemiBold',
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           Text.rich(
//                                             TextSpan(
//                                               children: [
//                                                 TextSpan(
//                                                   text: ' SHOP - ',
//                                                   style: TextStyle(
//                                                     fontFamily: 'SemiBold',
//                                                     fontSize: 14,
//                                                     fontWeight: FontWeight.bold,
//                                                   ),
//                                                 ),
//                                                 TextSpan(
//                                                   text:
//                                                       'Shiv, Behind Apurv Hospital, Nanded',
//                                                   style: TextStyle(
//                                                     fontFamily: 'Medium',
//                                                     fontSize: 14,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             maxLines: 1,
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ],
//                                       ),
//                                       const Spacer(),
//                                       Column(
//                                         children: [
//                                           GestureDetector(
//                                             onTap: () {
//                                               Navigator.pushNamed(
//                                                   context, '/account');
//                                             },
//                                             child: const Padding(
//                                               padding:
//                                                   EdgeInsets.only(bottom: 10),
//                                               child: Icon(
//                                                 Icons.account_circle,
//                                                 color: Colors.black,
//                                                 size: 35,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       )
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20, right: 20),
//                         child: GestureDetector(
//                           onTap: () => {
//                             // navigateToSearchScreen()
//                           },
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(15),
//                                     color: Colors.white,
//                                     border: Border.all(
//                                         color: Colors.black38, width: 1),
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       const Padding(
//                                         padding: EdgeInsets.all(10.0),
//                                         child: Icon(
//                                           Icons.search,
//                                           color: Colors.black,
//                                           size: 20,
//                                         ),
//                                       ),
//                                       Expanded(
//                                         child: Text(
//                                           currentHint,
//                                           style: const TextStyle(
//                                             fontWeight: FontWeight.normal,
//                                             fontSize: 17,
//                                             color: Colors.black54,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Center(
//                         child: Container(
//                           height: 150,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           clipBehavior: Clip.antiAlias,
//                           child: Image.network(
//                             'https://res.cloudinary.com/dybzzlqhv/image/upload/v1720875098/vegetables/swya6iwpohlynuq1r9td.gif',
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pushNamed(
//                         context,
//                         AddProductScreen.routeName,
//                       );
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.grey, // Grey color
//                         borderRadius: BorderRadius.circular(15), // Radius of 15
//                       ),
//                       padding: const EdgeInsets.all(
//                           16.0), // Padding inside the container
//                       child: const Row(
//                         mainAxisSize: MainAxisSize.min, // Use minimum space
//                         children: [
//                           Icon(Icons.add, color: Colors.white), // Add icon
//                           SizedBox(width: 8.0), // Spacing between icon and text
//                           Text(
//                             'Add',
//                             style: TextStyle(
//                               color: Colors.white, // Text color
//                               fontSize: 16, // Text size
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pushNamed(
//                         context,
//                         ShopDetailsScreen.routeName,
//                       );
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.grey, // Grey color
//                         borderRadius: BorderRadius.circular(15), // Radius of 15
//                       ),
//                       padding: const EdgeInsets.all(
//                           16.0), // Padding inside the container
//                       child: const Row(
//                         mainAxisSize: MainAxisSize.min, // Use minimum space
//                         children: [
//                           Icon(Icons.add, color: Colors.white), // Add icon
//                           SizedBox(width: 8.0), // Spacing between icon and text
//                           Text(
//                             'Info',
//                             style: TextStyle(
//                               color: Colors.white, // Text color
//                               fontSize: 16, // Text size
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       // Navigator.pushNamed(
//                       //   context,
//                       //   OrdersScreen.routeName,
//                       // );
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(builder: (context) => OrdersScreen()),
//                       );
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.grey, // Grey color
//                         borderRadius: BorderRadius.circular(15), // Radius of 15
//                       ),
//                       padding: const EdgeInsets.all(
//                           16.0), // Padding inside the container
//                       child: const Row(
//                         mainAxisSize: MainAxisSize.min, // Use minimum space
//                         children: [
//                           Icon(Icons.shopping_bag,
//                               color: Colors.white), // Add icon
//                           SizedBox(width: 8.0), // Spacing between icon and text
//                           Text(
//                             'Orders',
//                             style: TextStyle(
//                               color: Colors.white, // Text color
//                               fontSize: 16, // Text size
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pushNamed(context, SalesScreen.routeName);
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.grey, // Grey color
//                         borderRadius: BorderRadius.circular(15), // Radius of 15
//                       ),
//                       padding: const EdgeInsets.all(
//                           16.0), // Padding inside the container
//                       child: const Row(
//                         mainAxisSize: MainAxisSize.min, // Use minimum space
//                         children: [
//                           Icon(Icons.pie_chart,
//                               color: Colors.white), // Chart icon
//                           SizedBox(width: 8.0), // Spacing between icon and text
//                           Text(
//                             'Report',
//                             style: TextStyle(
//                               color: Colors.white, // Text color
//                               fontSize: 16, // Text size
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               Container(
//                 color: Colors.white,
//                 child: Column(
//                   children: [
//                     const Padding(
//                       padding: EdgeInsets.only(
//                         left: 10,
//                       ),
//                     ),

//                     const Padding(
//                       padding: EdgeInsets.only(
//                         left: 10,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Bestsellers",
//                             style: TextStyle(
//                               fontSize: 16, // Adjust font size as needed
//                               fontWeight: FontWeight
//                                   .bold, // Adjust font weight as needed
//                               fontFamily: 'SemiBold',
//                             ),
//                           ),
//                           SizedBox(width: 10),
//                           HorizontalLine(),
                          
//                         ],
//                       ),
//                     ),
//                     // const BestSellers(),
//                     const SizedBox(
//                       height: 10,
//                     ),

//                     // fshopProducts(),
//                     const Text(
//                       "Grocery & Kitchen",
//                       style: TextStyle(
//                           fontFamily: 'SemiBold',
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     const HorizontalLine(),

//                     const SizedBox(height: 20),
//                     // GroceryCategories(shopCode: widget.shopCode),
//                     // const Categories(userId: '66f911889b7e68decf9f8c0a'),
//                     const SizedBox(
//                       height: 30,
//                     ),
//                     // fshopProducts(),
//                     const Text(
//                       "Beauty & Personal Care",
//                       style: TextStyle(
//                           fontFamily: 'SemiBold',
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     const HorizontalLine(),

//                     const SizedBox(height: 20),
//                     // const GroceryCategories(userId: '667c4e8e2f6dec6e82d1ada9'),
//                     // BeautyCategories(userId: '6652bfc64e869c021acf688c'),

//                     const SizedBox(
//                       height: 20,
//                     ),
//                     // Text("Fruits"),
//                     // HorizontalLine(),

//                     // SizedBox(height: 20),
//                     // Vegetables(userId: '667c4e8e2f6dec6e82d1ada9'),

//                     Container(
//                       height: 400,
//                       color: GlobalVariables.blueBackground,
//                       child: const Padding(
//                         padding: EdgeInsets.only(left: 15, right: 15),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                               height: 50,
//                             ),
//                             Text(
//                               "India's  time and cost saving app",
//                               style: TextStyle(
//                                   fontFamily: 'SemiBold',
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 40,
//                                   color: GlobalVariables.lightBlueTextColor),
//                             ),
//                             SizedBox(
//                               height: 50,
//                             ),
//                             Center(
//                               child: Text(
//                                 'shoper',
//                                 style: TextStyle(
//                                     fontFamily: 'SemiBold',
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 25,
//                                     color: GlobalVariables.lightBlueTextColor),
//                               ),
//                             ),
//                             Center(
//                               child: Text(
//                                 'V14.127.3',
//                                 style: TextStyle(
//                                   fontFamily: 'Regular',
//                                   color: Colors.grey,
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             // SizedBox(
//                             //   height: 50,
//                             // ),
//                           ],
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),

//               Container(
//                 height: 50,
//                 color: GlobalVariables.blueBackground,
//               )

//               // Orders(),
//             ],
//           ),
//         ),
//       ]),
//     );
//   }
// }
