import 'package:farstore/constants/global_variables.dart';
import 'package:farstore/features/admin/screens/categories.dart';
import 'package:farstore/features/admin/services/admin_services.dart';
import 'package:farstore/models/product.dart';
import 'package:farstore/providers/user_provider.dart';
import 'package:farstore/widgets/horizontal_line.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// class CategoryDeals extends StatefulWidget {
//   static const String routeName = '/category';
//   const CategoryDeals({Key? key}) : super(key: key);

//   @override
//   State<CategoryDeals> createState() => _CategoryDealsState();
// }

// class _CategoryDealsState extends State<CategoryDeals> {
//   List<Product>? products;
//   final AdminServices adminServices = AdminServices();

//   @override
//   void initState() {
//     super.initState();
//     // fetchAllProducts();
//   }


//   //   void navigateToSearchScreen() {
//   //   Navigator.pushNamed(
//   //     context,
//   //     SearchScreen.routeName,
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<UserProvider>(context).user;
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(60),
//         child: AppBar(
//           backgroundColor: GlobalVariables.backgroundColor,
//           elevation: 0.0,
//           title: Padding(
//             padding: EdgeInsets.only(bottom: 15,top: 30),
//             child: const Row(
//               // mainAxisAlignment: MainAxisAlignment.start,
//               // crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
          
//                 Icon(
//                   Icons.category,
//                   color: Colors.black,
//                   size: 25,
//                 ),
//                 SizedBox(
//                   width: 20,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(top: 0, bottom: 0),
//                   child: Text(
//                     'Categories',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.black,
//                       fontFamily: 'SemiBold',
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: Container(
//         color: GlobalVariables.backgroundColor,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 height: 260,
//                 decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(20),
//                       bottomRight: Radius.circular(
//                           20)),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20, right: 20,top: 5),
//                         child: GestureDetector(
//                           // onTap: () => navigateToSearchScreen(),
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
//                                           "Search 'Maggi",
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
//                       const SizedBox(height: 10),
//                       // const CarouselImage(),
//                       Center(
//                         child: Container(
//                           height: 203,
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
//                       // const SizedBox(
//                       //   height: 10,
//                       // ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 "Category",
//                 style: TextStyle(
//                     fontFamily: 'SemiBold',
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16),
//               ),
//               const HorizontalLine(),
//               const SizedBox(height: 20),
//               // Categories(userId: widg),
//               const SizedBox(height: 20),
//               Container(
//                 height: 300,
//                 color: GlobalVariables.backgroundColor,
//                 child: const Padding(
//                   padding: EdgeInsets.only(top: 30, left: 30, right: 30),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Center(
//                         child: Text(
//                           "India's  shoper connector app",
//                           style: TextStyle(
//                               fontFamily: 'SemiBold',
//                               fontWeight: FontWeight.bold,
//                               fontSize: 40,
//                               color: GlobalVariables.lightBlueTextColor),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 25,
//                       ),
//                       HorizontalLine1(),
//                       SizedBox(
//                         height: 25,
//                       ),
//                       Center(
//                         child: Text(
//                           'shopper',
//                           style: TextStyle(
//                               fontFamily: 'SemiBold',
//                               fontWeight: FontWeight.bold,
//                               fontSize: 25,
//                               color: GlobalVariables.lightBlueTextColor),
//                         ),
//                       ),
//                       Center(
//                         child: Text(
//                           'V14.127.3',
//                           style: TextStyle(
//                             fontFamily: 'Regular',
//                             color: Colors.grey,
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 50,
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
