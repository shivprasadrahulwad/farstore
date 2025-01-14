// ignore_for_file: dead_code

import 'dart:async';

import 'package:farstore/constants/global_variables.dart';
import 'package:farstore/features/admin/newAccount/screens/account_create_screen.dart';
import 'package:farstore/features/admin/orders/orders_screen.dart';
import 'package:farstore/features/admin/screens/ProductSaleListScreen.dart';
import 'package:farstore/features/admin/screens/categories.dart';
import 'package:farstore/features/admin/screens/load_store_data_screen.dart';
import 'package:farstore/features/admin/services/admin_services.dart';
import 'package:farstore/features/auth/screens/sample.dart';
import 'package:farstore/onboard/email_account_screen.dart';
import 'package:farstore/onboard/onboard_check_list_screen.dart';
import 'package:farstore/onboard/onboard_screen.dart';
import 'package:farstore/onboard/survey_screen.dart';
import 'package:farstore/payment/add_card_details_screen.dart';
import 'package:farstore/payment/razorpay_payment_gateway.dart';
import 'package:farstore/providers/shopInfo_provider.dart';
import 'package:farstore/shop_setup/coupon/create_coupon_screen.dart';
import 'package:farstore/shop_setup/offers/offer_image_screen.dart';
import 'package:farstore/subscription/subscription_plan_screen.dart';
import 'package:farstore/welcome/shopSetup_guide.dart';
import 'package:farstore/welcome/shop_details_screen.dart';
import 'package:farstore/widgets/Count_down_Stopwatch.dart';
import 'package:farstore/widgets/custom_banner.dart';
import 'package:farstore/widgets/horizontal_line.dart';
import 'package:farstore/widgets/poll_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  final String shopCode;
  const HomeScreen({Key? key, required this.shopCode}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List<Product>? products;
  bool _isFloatingContainerOpen = false;
  List<Map<String, dynamic>> carts = [];

  @override
  void initState() {
    super.initState();
    _fetchShopInfo();
  }

  Future<void> _fetchShopInfo() async {
    try {
      AdminServices adminServices = AdminServices();
      await adminServices.fetchShopDetails(context);
    } catch (e) {
      print('Error fetching shop info: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch shop details: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (carts.isNotEmpty && !_isFloatingContainerOpen) {
      setState(() {
        _isFloatingContainerOpen = true;
      });
    }

    final shopInfoProvider = Provider.of<ShopInfoProvider>(context);
    final timeDifference = shopInfoProvider.calculateTimeDifference();

    double averageRating = shopInfoProvider.averageRating;

    final shopCode = context.watch<ShopInfoProvider>().shopInfo?.shopCode;

    return Scaffold(
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  image: DecorationImage(
                    image:
                        AssetImage('assets/images/welcome.png'), // Local image
                    fit:
                        BoxFit.cover, // Adjust image fit (cover, contain, etc.)
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Ready in",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'SemiBold',
                                      fontSize: 14,
                                    ),
                                  ),
                                  // Text(context.formatString(LocalData.body, ["Shiv"]),),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                "8 minutes",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25,
                                                  fontFamily: 'SemiBold',
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.star,
                                                    color: Colors.yellow,
                                                  ),
                                                  Text(
                                                    averageRating.toStringAsFixed(
                                                        1), // Rounded to 1 decimal
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          const Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: ' SHOP - ',
                                                  style: TextStyle(
                                                    fontFamily: 'SemiBold',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      'Shiv, Behind Apurv Hospital, Nanded',
                                                  style: TextStyle(
                                                    fontFamily: 'Medium',
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, '/account');
                                            },
                                            child: const Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 10),
                                              child: Icon(
                                                Icons.account_circle,
                                                color: Colors.black,
                                                size: 35,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: GestureDetector(
                          onTap: () => {
                            // navigateToSearchScreen()
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 246, 230, 82),
                                        width: 1),
                                  ),
                                  child: const Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 10,top: 10,bottom: 10,right: 5),
                                        child: Icon(
                                          Icons.search,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '|  Search products',
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 17,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Center(
                      //   child: Container(
                      //     height: 150,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(20),
                      //     ),
                      //     clipBehavior: Clip.antiAlias,
                      //     child: Image.network(
                      //       'https://res.cloudinary.com/dybzzlqhv/image/upload/v1720875098/vegetables/swya6iwpohlynuq1r9td.gif',
                      //       fit: BoxFit.cover,
                      //     ),
                      //   ),
                      // ),

                      const Padding(
                        padding: EdgeInsets.only(left: 10, top: 70, right: 10),
                        child: CustomContainerBanner(
                          imageUrl:
                              'https://res.cloudinary.com/dybzzlqhv/image/upload/v1727670900/fmvqjdmtzq5chmeqsyhb.png',
                          titleText: 'Flat ₹50 OFF',
                          subtitleText: 'On first order above ₹299',
                        ),
                      ),
                      // SizedBox(height: 60,),
                      // const Text.rich(
                      //   TextSpan(
                      //     children: [
                      //       TextSpan(
                      //         text: 'Enjoy ',
                      //         style: TextStyle(
                      //             color: Colors.black,
                      //             fontSize: 20,
                      //             fontWeight: FontWeight.bold),
                      //       ),
                      //       TextSpan(
                      //         text: 'Free Delivery!',
                      //         style: TextStyle(
                      //             color: GlobalVariables.greenColor,
                      //             fontSize: 20,
                      //             fontWeight: FontWeight.bold),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(height: 10,),
                      // const Text(
                      //   'ON YOUR FIRST ORDER',
                      //   style: TextStyle(
                      //       color: Colors.black,
                      //       fontSize: 12,
                      //       fontWeight: FontWeight.bold),
                      // ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              if (timeDifference != null)
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: CountdownStopwatch(
                    initialDuration: Duration(
                      days: timeDifference['days'] ?? 0,
                      hours: timeDifference['hours'] ?? 0,
                      minutes: timeDifference['minutes'] ?? 0,
                      seconds: timeDifference['seconds'] ?? 0,
                    ),
                  ),
                ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const EmailOnboardingScreen()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey, // Grey color
                        borderRadius: BorderRadius.circular(15), // Radius of 15
                      ),
                      padding: const EdgeInsets.all(
                          16.0), // Padding inside the container
                      child: const Row(
                        mainAxisSize: MainAxisSize.min, // Use minimum space
                        children: [
                          Icon(Icons.add, color: Colors.white), // Add icon
                          SizedBox(width: 8.0), // Spacing between icon and text
                          Text(
                            'Email',
                            style: TextStyle(
                              color: Colors.white, // Text color
                              fontSize: 12, // Text size
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        ShopDetailsScreen.routeName,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey, // Grey color
                        borderRadius: BorderRadius.circular(15), // Radius of 15
                      ),
                      padding: const EdgeInsets.all(
                          16.0), // Padding inside the container
                      child: const Row(
                        mainAxisSize: MainAxisSize.min, // Use minimum space
                        children: [
                          Icon(Icons.add, color: Colors.white), // Add icon
                          SizedBox(width: 8.0), // Spacing between icon and text
                          Text(
                            'Info',
                            style: TextStyle(
                              color: Colors.white, // Text color
                              fontSize: 12, // Text size
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.pushReplacement(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => EmailOnboardingScreen()),
                  //     );
                  //   },
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       color: Colors.grey, // Grey color
                  //       borderRadius: BorderRadius.circular(15), // Radius of 15
                  //     ),
                  //     padding: const EdgeInsets.all(
                  //         16.0), // Padding inside the container
                  //     child: const Row(
                  //       mainAxisSize: MainAxisSize.min, // Use minimum space
                  //       children: [
                  //         Icon(Icons.add, color: Colors.white), // Add icon
                  //         SizedBox(width: 8.0), // Spacing between icon and text
                  //         Text(
                  //           'Email',
                  //           style: TextStyle(
                  //             color: Colors.white, // Text color
                  //             fontSize: 12, // Text size
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SurveyScreen()),
                      );
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => SampleCollectionScreen()),
                      // );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey, // Grey color
                        borderRadius: BorderRadius.circular(15), // Radius of 15
                      ),
                      padding: const EdgeInsets.all(
                          16.0), // Padding inside the container
                      child: const Row(
                        mainAxisSize: MainAxisSize.min, // Use minimum space
                        children: [
                          Text(
                            'Survey',
                            style: TextStyle(
                              color: Colors.white, // Text color
                              fontSize: 12, // Text size
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OnboardScreen()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey, // Grey color
                        borderRadius: BorderRadius.circular(15), // Radius of 15
                      ),
                      padding: const EdgeInsets.all(
                          16.0), // Padding inside the container
                      child: const Row(
                        mainAxisSize: MainAxisSize.min, // Use minimum space
                        children: [
                          Text(
                            'onboard sc',
                            style: TextStyle(
                              color: Colors.white, // Text color
                              fontSize: 12, // Text size
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "Bestsellers",
                            style: TextStyle(
                              fontSize: 16, // Adjust font size as needed
                              fontWeight: FontWeight
                                  .bold, // Adjust font weight as needed
                              fontFamily: 'SemiBold',
                            ),
                          ),
                          const SizedBox(width: 10),
                          const HorizontalLine(),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const OfferImageScreen()),
                              );
                            },
                            child: const Text(
                              "Offer image",
                              style: TextStyle(
                                  fontFamily: 'SemiBold',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // const BestSellers(),
                    const SizedBox(
                      height: 10,
                    ),
                    // fshopProducts(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SubscriptionPlanScreen()),
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: GlobalVariables.greyBlueBackgroundColor),
                            padding: const EdgeInsets.all(
                                8), // Adjust padding as needed
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
                            "subscri",
                            style: TextStyle(
                                fontFamily: 'Medium',
                                fontSize: 16,
                                color: Colors.black),
                          ),
                          const Spacer(),
                          Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(
                                8), // Adjust padding as needed
                            child: const Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: GlobalVariables.greyBlueColor,
                              size: 15,
                            ),
                          ),
                        ],
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CreateCouponScreen()),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey, // Grey color
                          borderRadius:
                              BorderRadius.circular(15), // Radius of 15
                        ),
                        padding: const EdgeInsets.all(
                            16.0), // Padding inside the container
                        child: const Row(
                          mainAxisSize: MainAxisSize.min, // Use minimum space
                          children: [
                            Text(
                              'create coupon',
                              style: TextStyle(
                                color: Colors.white, // Text color
                                fontSize: 12, // Text size
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CreateAccountScreen()),
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: GlobalVariables.greyBlueBackgroundColor),
                            padding: const EdgeInsets.all(
                                8), // Adjust padding as needed
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
                            "create account",
                            style: TextStyle(
                                fontFamily: 'Medium',
                                fontSize: 16,
                                color: Colors.black),
                          ),
                          const Spacer(),
                          Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(
                                8), // Adjust padding as needed
                            child: const Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: GlobalVariables.greyBlueColor,
                              size: 15,
                            ),
                          ),
                        ],
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoadStoreDataScreen(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: GlobalVariables.greyBlueBackgroundColor),
                            padding: const EdgeInsets.all(
                                8), // Adjust padding as needed
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
                            "load shopdetails storage",
                            style: TextStyle(
                                fontFamily: 'Regular',
                                fontSize: 16,
                                color: Colors.black),
                          ),
                          const Spacer(),
                          Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(
                                8), // Adjust padding as needed
                            child: const Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: GlobalVariables.greyBlueColor,
                              size: 15,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => CreatedCouponsScreen(),
                    //       ),
                    //     );
                    //   },
                    //   child: Row(
                    //     children: [
                    //       Container(
                    //         decoration: const BoxDecoration(
                    //             shape: BoxShape.circle,
                    //             color: GlobalVariables.greyBlueBackgroundColor),
                    //         padding: const EdgeInsets.all(
                    //             8), // Adjust padding as needed
                    //         child: const Icon(
                    //           Icons.info_outline_rounded,
                    //           color: GlobalVariables.greyBlueColor,
                    //           size: 15,
                    //         ),
                    //       ),
                    //       const SizedBox(
                    //         width: 10,
                    //       ),
                    //       const Text(
                    //         "coupons hive",
                    //         style: TextStyle(
                    //             fontFamily: 'Regular',
                    //             fontSize: 16,
                    //             color: Colors.black),
                    //       ),
                    //       const Spacer(),
                    //       Container(
                    //         decoration: const BoxDecoration(
                    //           shape: BoxShape.circle,
                    //         ),
                    //         padding: const EdgeInsets.all(
                    //             8), // Adjust padding as needed
                    //         child: const Icon(
                    //           Icons.arrow_forward_ios_outlined,
                    //           color: GlobalVariables.greyBlueColor,
                    //           size: 15,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddCardScreen(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: GlobalVariables.greyBlueBackgroundColor),
                            padding: const EdgeInsets.all(
                                8), // Adjust padding as needed
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
                            "Add card details",
                            style: TextStyle(
                                fontFamily: 'Regular',
                                fontSize: 16,
                                color: Colors.black),
                          ),
                          const Spacer(),
                          Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(
                                8), // Adjust padding as needed
                            child: const Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: GlobalVariables.greyBlueColor,
                              size: 15,
                            ),
                          ),
                        ],
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RazorPaymentScreen(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: GlobalVariables.greyBlueBackgroundColor),
                            padding: const EdgeInsets.all(
                                8), // Adjust padding as needed
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
                            "razor pay",
                            style: TextStyle(
                                fontFamily: 'Regular',
                                fontSize: 16,
                                color: Colors.black),
                          ),
                          const Spacer(),
                          Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(
                                8), // Adjust padding as needed
                            child: const Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: GlobalVariables.greyBlueColor,
                              size: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreatePollScreen(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: GlobalVariables.greyBlueBackgroundColor),
                            padding: const EdgeInsets.all(
                                8), // Adjust padding as needed
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
                            "poll screen",
                            style: TextStyle(
                                fontFamily: 'Regular',
                                fontSize: 16,
                                color: Colors.black),
                          ),
                          const Spacer(),
                          Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(
                                8), // Adjust padding as needed
                            child: const Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: GlobalVariables.greyBlueColor,
                              size: 15,
                            ),
                          ),
                        ],
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BestProductsScreen(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: GlobalVariables.greyBlueBackgroundColor),
                            padding: const EdgeInsets.all(
                                8), // Adjust padding as needed
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
                            "best hive products ",
                            style: TextStyle(
                                fontFamily: 'Regular',
                                fontSize: 16,
                                color: Colors.black),
                          ),
                          const Spacer(),
                          Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(
                                8), // Adjust padding as needed
                            child: const Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: GlobalVariables.greyBlueColor,
                              size: 15,
                            ),
                          ),
                        ],
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProductSaleListScreen(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: GlobalVariables.greyBlueBackgroundColor),
                            padding: const EdgeInsets.all(
                                8), // Adjust padding as needed
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
                            "products sales table ",
                            style: TextStyle(
                                fontFamily: 'Regular',
                                fontSize: 16,
                                color: Colors.black),
                          ),
                          const Spacer(),
                          Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(
                                8), // Adjust padding as needed
                            child: const Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: GlobalVariables.greyBlueColor,
                              size: 15,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => ChargessScreen(),
                    //       ),
                    //     );
                    //   },
                    //   child: Row(
                    //     children: [
                    //       Container(
                    //         decoration: const BoxDecoration(
                    //             shape: BoxShape.circle,
                    //             color: GlobalVariables.greyBlueBackgroundColor),
                    //         padding: const EdgeInsets.all(
                    //             8), // Adjust padding as needed
                    //         child: const Icon(
                    //           Icons.info_outline_rounded,
                    //           color: GlobalVariables.greyBlueColor,
                    //           size: 15,
                    //         ),
                    //       ),
                    //       const SizedBox(
                    //         width: 10,
                    //       ),
                    //       const Text(
                    //         "charges hive ",
                    //         style: TextStyle(
                    //             fontFamily: 'Regular',
                    //             fontSize: 16,
                    //             color: Colors.black),
                    //       ),
                    //       const Spacer(),
                    //       Container(
                    //         decoration: const BoxDecoration(
                    //           shape: BoxShape.circle,
                    //         ),
                    //         padding: const EdgeInsets.all(
                    //             8), // Adjust padding as needed
                    //         child: const Icon(
                    //           Icons.arrow_forward_ios_outlined,
                    //           color: GlobalVariables.greyBlueColor,
                    //           size: 15,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OnboardCheckListScreen()),
                        );
                      },
                      child: const Text(
                        "Grocery & Kitchen",
                        style: TextStyle(
                            fontFamily: 'SemiBold',
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const HorizontalLine(),

                    const SizedBox(height: 20),
                    // GroceryCategories(shopCode: widget.shopCode),
                    Categories(shopCode: '${shopCode}'),

                    const SizedBox(
                      height: 30,
                    ),
                    // fshopProducts(),
                    const Text(
                      "Beauty & Personal Care",
                      style: TextStyle(
                          fontFamily: 'SemiBold',
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const HorizontalLine(),

                    const SizedBox(height: 20),
                    SetupGuideWidget(),
                    const SizedBox(
                      height: 20,
                    ),

                    Container(
                      height: 400,
                      color: GlobalVariables.blueBackground,
                      child: const Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 50,
                            ),
                            Text(
                              "India's  time and cost saving app",
                              style: TextStyle(
                                  fontFamily: 'SemiBold',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40,
                                  color: GlobalVariables.lightBlueTextColor),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Center(
                              child: Text(
                                'shoper',
                                style: TextStyle(
                                    fontFamily: 'SemiBold',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    color: GlobalVariables.lightBlueTextColor),
                              ),
                            ),
                            Center(
                              child: Text(
                                'V14.127.3',
                                style: TextStyle(
                                  fontFamily: 'Regular',
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // SizedBox(
                            //   height: 50,
                            // ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),

              Container(
                height: 50,
                color: GlobalVariables.blueBackground,
              )

              // Orders(),
            ],
          ),
        ),
      ]),
    );
  }
}
