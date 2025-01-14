import 'package:farstore/constants/global_variables.dart';
import 'package:farstore/features/admin/account/services/account_services.dart';
import 'package:farstore/features/admin/services/admin_services.dart';
import 'package:farstore/providers/admin_provider.dart';
import 'package:farstore/welcome/shop_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class AccountScreen extends StatefulWidget {
  static const String routeName = '/account';
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // List<Order>? orders;
  final AdminServices accountServices = AdminServices();

  @override
  void initState() {
    super.initState();
    // fetchOrders();
  }

  // void fetchOrders() async {
  //   orders = await accountServices.fetchMyOrders(context: context);
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Padding(
                padding: EdgeInsets.only(
                  top: 20,
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 25,
                ),
              ),
            ),
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(0),
            child: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 0.0),
                      child: Consumer<AdminProvider>(
                        builder: (context, adminProvider, _) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment
                                    .bottomCenter, // Start at the bottom
                                end: Alignment.topCenter, // End at the top
                                colors: [
                                  GlobalVariables.blueBackground.withOpacity(
                                      1), // Fully opaque yellow at the bottom
                                  GlobalVariables.blueBackground.withOpacity(
                                      0), // Transparent yellow at the top
                                ],
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 20, right: 20, bottom: 30, top: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          color: GlobalVariables
                                              .blueBackground, // Light blue background
                                          borderRadius: BorderRadius.circular(
                                              20), // Border radius of 20
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 12, right: 12),
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
                                                  color: Colors
                                                      .white, // Icon color
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
                                                  color: Colors
                                                      .black, // Text color
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Center(
                                    child: Column(
                                      children: [
                                        Center(
                                          child: Stack(
                                            clipBehavior: Clip
                                                .none, // Ensures nothing is clipped
                                            alignment: Alignment.center,
                                            children: [
                                              // Big Container with BorderRadius of 35
                                              Container(
                                                width: 90,
                                                height: 90,
                                                decoration: BoxDecoration(
                                                  color: Colors.blueGrey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50), // Border radius for large container
                                                ),
                                                child: const Center(
                                                  child: Text(
                                                    'S',
                                                    style: TextStyle(
                                                      fontSize: 45,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // Small Container with BorderRadius of 20
                                              Positioned(
                                                  right:
                                                      -5, // Proper offset to make sure it's on the border
                                                  bottom: -5,
                                                  child: Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      border: Border.all(
                                                        color: Colors.black87,
                                                        width: 2,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.pushNamed(
                                                              context,
                                                              '/create');
                                                        },
                                                        child: Icon(
                                                          Icons.qr_code,
                                                          color: Colors.black,
                                                          size: 25,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "YOUR INFORMATION",
                            style: TextStyle(
                                fontFamily: 'Regular',
                                fontSize: 14,
                                color: GlobalVariables.greyBlueColor,
                                fontWeight: FontWeight.bold),
                          ),
                          const Divider(
                            thickness: 0.5,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              // if (orders != null) {
                              //   // Navigator.push(
                              //   //   context,
                              //   //   MaterialPageRoute(
                              //   //     builder: (context) => UserPastOrders(userId: '',)

                              //   //   ),
                              //   // );
                              // }
                              Navigator.pushNamed(context, '/create');
                            },
                            child: Row(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: GlobalVariables
                                          .greyBlueBackgroundColor),
                                  padding: const EdgeInsets.all(8),
                                  child: const Icon(
                                    Icons.shopping_bag_outlined,
                                    color: GlobalVariables.greyBlueColor,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  "Your shops",
                                  style: TextStyle(
                                      fontFamily: 'Medium', fontSize: 16),
                                ),
                                const Spacer(), // This pushes the text to the leftmost side
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
                                    builder: (context) => ShopDetailsScreen()

                                  ),
                                );
                            },
                            child: Row(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: GlobalVariables
                                          .greyBlueBackgroundColor),
                                  padding: const EdgeInsets.all(
                                      8), // Adjust padding as needed
                                  child: const Icon(
                                    Icons.notes_outlined,
                                    color: GlobalVariables.greyBlueColor,
                                    size: 15,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "Shop details",
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
                          const SizedBox(
                            height: 40,
                          ),
                          const Text("OTHER INFORMATION",
                              style: TextStyle(
                                  fontFamily: 'Regular',
                                  fontSize: 14,
                                  color: GlobalVariables.greyBlueColor,
                                  fontWeight: FontWeight.bold)),
                          const Divider(
                            thickness: 0.5,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              Share.share("mess");
                              print("Share tapped");
                            },
                            child: Row(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: GlobalVariables
                                          .greyBlueBackgroundColor),
                                  padding: const EdgeInsets.all(
                                      8), // Adjust padding as needed
                                  child: const Icon(
                                    Icons.share_outlined,
                                    color: GlobalVariables.greyBlueColor,
                                    size: 15,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "Share the app",
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
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/aboutUs');
                            },
                            child: Row(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: GlobalVariables
                                          .greyBlueBackgroundColor),
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
                                  "About Us",
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
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Row(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: GlobalVariables
                                          .greyBlueBackgroundColor),
                                  padding: const EdgeInsets.all(
                                      8), // Adjust padding as needed
                                  child: const Icon(
                                    Icons.star_border_outlined,
                                    color: GlobalVariables.greyBlueColor,
                                    size: 15,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "Rate us on the Play Store",
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
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/accountPrivacy');
                            },
                            child: Row(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: GlobalVariables
                                          .greyBlueBackgroundColor),
                                  padding: const EdgeInsets.all(
                                      8), // Adjust padding as needed
                                  child: const Icon(
                                    Icons.privacy_tip_outlined,
                                    color: GlobalVariables.greyBlueColor,
                                    size: 15,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "Account privacy",
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
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/accountPrivacy');
                            },
                            child: Row(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: GlobalVariables
                                          .greyBlueBackgroundColor),
                                  padding: const EdgeInsets.all(
                                      8), // Adjust padding as needed
                                  child: const Icon(
                                    Icons.notifications_outlined,
                                    color: GlobalVariables.greyBlueColor,
                                    size: 15,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "Notification preferences",
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
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () => AccountServices().logOut(context),
                            child: Row(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: GlobalVariables
                                          .greyBlueBackgroundColor),
                                  padding: const EdgeInsets.all(
                                      8), // Adjust padding as needed
                                  child: const Icon(
                                    Icons.logout_outlined,
                                    color: GlobalVariables.greyBlueColor,
                                    size: 15,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "Logout",
                                  style: TextStyle(
                                    fontFamily: 'Medium',
                                    fontSize: 15,
                                  ),
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
                          const SizedBox(
                            height: 30,
                          ),
                          const Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'farcon',
                                  style: TextStyle(
                                    fontFamily: 'SemiBold',
                                    color: GlobalVariables.greyBlueColor,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'V14.127.3',
                                  style: TextStyle(
                                    fontFamily: 'Regular',
                                    color: GlobalVariables.greyBlueColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    )
                  ]),
            ),
          ),
        ));
  }
}
