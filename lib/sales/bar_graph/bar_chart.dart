// import 'package:farstore/constants/global_variables.dart';
// import 'package:farstore/sales/bar_graph/bar_chat.dart';
// import 'package:flutter/material.dart';

// class HomeBarGraph extends StatefulWidget {
//   final List<int> weeklyOrders;
//   final int totalWeeklyOrders;
//   final double weeklyGrowth;

//   const HomeBarGraph({Key? key, required this.weeklyOrders, required this.totalWeeklyOrders ,required this.weeklyGrowth}) : super(key: key);

//   @override
//   _HomeBarGraphState createState() => _HomeBarGraphState();
// }

// class _HomeBarGraphState extends State<HomeBarGraph> {
//   late int totalSum;

//   @override
//   void initState() {
//     super.initState();
//     totalSum = calculateTotalSum();
//   }

//   int calculateTotalSum() {
//     int sum = 0;
//     for (int order in widget.weeklyOrders) {
//       sum += order;
//     }
//     return sum;
//   }

//   @override
//   void didUpdateWidget(covariant HomeBarGraph oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.weeklyOrders != widget.weeklyOrders) {
//       totalSum = calculateTotalSum();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: SizedBox(
//           height: 300,
//           child: Card(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Container(
//               height: 200,
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Weekly Orders',
//                           style: TextStyle(
//                             fontFamily: 'Regular',
//                             fontSize: 16,
//                             color: GlobalVariables.greyTextColor,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Row(
//                           children: [
//                             Text(
//                               widget.totalWeeklyOrders.toString(), // Use widget property for total weekly orders
//                               style: TextStyle(
//                                 fontFamily: 'Regular',
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(
//                               width: 30,
//                             ),
//                             Container(
//                               height: 15,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 color: const Color(0xFF82D2BA),
//                               ),
//                               child: const Padding(
//                                 padding: EdgeInsets.all(2),
//                                 child: Icon(
//                                   Icons.arrow_outward,
//                                   size: 10,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(
//                               width: 10,
//                             ),
//                             Text(
//                               '100%',
//                               style: TextStyle(
//                                 fontFamily: 'Regular',
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),

//                             // Text(
//                             //   '0%',
//                             //   style: TextStyle(
//                             //     fontFamily: 'Regular',
//                             //     fontSize: 12,
//                             //     fontWeight: FontWeight.bold,
//                             //   ),
//                             // ),
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.only(bottom: 30.0),
//                       child: MyBargraph(
//                         weeklySummary: widget.weeklyOrders.map((e) => e.toDouble()).toList(),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
