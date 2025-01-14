import 'package:farstore/constants/global_variables.dart';
import 'package:farstore/models/toggle_management.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/offerDes.dart';

class OfferScreenResult {
  final List<Map<String, dynamic>> offerDescriptions;
  final bool isToggled;

  OfferScreenResult({
    required this.offerDescriptions,
    required this.isToggled,
  });
}

class OffersScreen extends StatefulWidget {
  static const String routeName = '/offers';
  const OffersScreen({Key? key}) : super(key: key);

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  bool isAddingOfferDescription = false;
  final TextEditingController offerDescriptionController =
      TextEditingController();
  final TextEditingController offerTitleController = TextEditingController();
  bool isToggled = false;
  int? selectedIconIndex;
  late Box<offerDes>? offerBox;

  final List<IconData> offerIcons = [
    Icons.motorcycle,
    Icons.percent,
    Icons.shopping_bag,
    Icons.local_offer,
    Icons.card_giftcard,
    Icons.store,
    Icons.attach_money,
    Icons.discount,
    Icons.loyalty,
    Icons.flash_on,
  ];

  List<Map<String, dynamic>> offerDescriptions = [];

 @override
  void initState() {
    super.initState();
    isToggled = ToggleManager.getToggleState(ToggleType.offerDes);
    _initializeHive();
  }


Future<void> _initializeHive() async {
  // await Hive.initFlutter();
  // offerBox = await Hive.openBox<offerDes>('offerDes');

  if (!Hive.isBoxOpen('offerDes')) {
      offerBox = await Hive.openBox<offerDes>('offerDes');
    } else {
      offerBox = Hive.box<offerDes>('offerDes');
    }


  // Load existing offers from Hive
  // setState(() {
  //   offerDescriptions = offerBox.values.map((offer) {
  //     return {
  //       'title': offer.title,
  //       'description': offer.description,
  //       'icon': _getIconDataFromString(offer.icon),
  //     };
  //   }).toList();
  // });

  if (mounted) {
      setState(() {
        offerDescriptions = offerBox?.values.map((offer) {
          return {
            'title': offer.title,
            'description': offer.description,
            'icon': _getIconDataFromString(offer.icon),
          };
        }).toList() ?? [];
      });
    }

  print('Debug: Final offerDescriptions - $offerDescriptions');
}


  IconData _getIconDataFromString(String iconString) {
    // Default icon if conversion fails
    IconData defaultIcon = Icons.local_offer;

    // Map of icon strings to IconData
    final iconMap = {
      'Icons.motorcycle': Icons.motorcycle,
      'Icons.percent': Icons.percent,
      'Icons.shopping_bag': Icons.shopping_bag,
      'Icons.local_offer': Icons.local_offer,
      'Icons.card_giftcard': Icons.card_giftcard,
      'Icons.store': Icons.store,
      'Icons.attach_money': Icons.attach_money,
      'Icons.discount': Icons.discount,
      'Icons.loyalty': Icons.loyalty,
      'Icons.flash_on': Icons.flash_on,
    };

    return iconMap[iconString] ?? defaultIcon;
  }

  String _getIconStringFromIconData(IconData icon) {
    // Reverse mapping from IconData to string
    final iconMap = {
      Icons.motorcycle: 'Icons.motorcycle',
      Icons.percent: 'Icons.percent',
      Icons.shopping_bag: 'Icons.shopping_bag',
      Icons.local_offer: 'Icons.local_offer',
      Icons.card_giftcard: 'Icons.card_giftcard',
      Icons.store: 'Icons.store',
      Icons.attach_money: 'Icons.attach_money',
      Icons.discount: 'Icons.discount',
      Icons.loyalty: 'Icons.loyalty',
      Icons.flash_on: 'Icons.flash_on',
    };

    return iconMap[icon] ?? 'Icons.local_offer';
  }


  // void _saveOfferToHive(Map<String, dynamic> offer) {
  //   final offerDesObj = offerDes(
  //     title: offer['title'],
  //     description: offer['description'],
  //     icon: _getIconStringFromIconData(offer['icon']),
  //   );

  //   offerBox.add(offerDesObj);
  // }

  // void _deleteOfferFromHive(int index) {
  //   offerBox.deleteAt(index);
  // }

  void _saveOfferToHive(Map<String, dynamic> offer) {
    if (offerBox?.isOpen ?? false) {
      final offerDesObj = offerDes(
        title: offer['title'],
        description: offer['description'],
        icon: _getIconStringFromIconData(offer['icon']),
      );
      offerBox?.add(offerDesObj);
    }
  }

  void _deleteOfferFromHive(int index) {
    if (offerBox?.isOpen ?? false) {
      offerBox?.deleteAt(index);
    }
  }

  void toggleButton() {
    setState(() {
      isToggled = !isToggled;
      ToggleManager.saveToggleState(ToggleType.offerDes, isToggled);
    });
  }

@override
  void dispose() {
    if (offerBox?.isOpen ?? false) {
      offerBox?.close();
    }
    offerDescriptionController.dispose();
    offerTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Offer',
            style: TextStyle(
                fontFamily: 'Regular',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black),
          ),
        ),
        body: Container(
            color: Colors.white,
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Description",
                                style: TextStyle(
                                    fontFamily: 'Regular',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: toggleButton,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 47.0,
                                  height: 25.0,
                                  padding: const EdgeInsets.all(2.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: isToggled
                                        ? Colors.green
                                        : Colors.grey[300],
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      AnimatedPositioned(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        left: isToggled ? 24.0 : 4.0,
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          width: 15.0,
                                          height: 15.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isToggled
                                                ? Colors.white
                                                : Colors.transparent,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          if (!isToggled) const Divider(color: Colors.grey),
                          if (isToggled)
                            const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10),
                                  Text(
                                    'OFFER DESCRIPTION ',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Divider(color: Colors.grey),
                                ]),
                          if (isToggled)
                            Column(children: [
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                padding: const EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black12),
                                  color: GlobalVariables.blueBackground,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: const EdgeInsets.all(10),
                                          child: const Icon(
                                            Icons.motorcycle,
                                            color: Colors.blue,
                                          ),
                                        )),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          // color: Colors.blue[100],
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.all(10),
                                        child: const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Get Free delivery',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: GlobalVariables
                                                      .blueTextColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'on shopping product worth 99',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 0),
                                padding: const EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black12),
                                  color: GlobalVariables.blueBackground,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: const EdgeInsets.all(10),
                                          child: const Icon(
                                            Icons.shopping_bag,
                                            color: Colors.blue,
                                          ),
                                        )),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          // color: Colors.blue[100],
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.all(10),
                                        child: const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Get 50% OFF',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: GlobalVariables
                                                      .blueTextColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'on shopping products above 1499',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isAddingOfferDescription =
                                        !isAddingOfferDescription;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey),
                                      padding: const EdgeInsets.all(8),
                                      child: const Icon(
                                        Icons.info_outline_rounded,
                                        color: Colors.grey,
                                        size: 15,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      "Add Offer Description",
                                      style: TextStyle(
                                        fontFamily: 'Regular',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.green,
                                        size: 25,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isAddingOfferDescription)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    TextField(
                                      controller: offerTitleController,
                                      maxLength: 40,
                                      decoration: const InputDecoration(
                                        hintText: 'Offer Title',
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.title),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    TextField(
                                      controller: offerDescriptionController,
                                      maxLength: 40,
                                      decoration: const InputDecoration(
                                        hintText: 'Offer Description',
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.description),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    const Text('Select an Icon for the Offer'),
                                    GridView.builder(
                                      shrinkWrap: true,
                                      itemCount: offerIcons.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 5,
                                        mainAxisSpacing: 8.0,
                                        crossAxisSpacing: 8.0,
                                      ),
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedIconIndex = index;
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: selectedIconIndex == index
                                                  ? Colors.green[100]
                                                  : Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Icon(
                                              offerIcons[index],
                                              color: selectedIconIndex == index
                                                  ? Colors.green
                                                  : Colors.black,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          String offerTitle =
                                              offerTitleController.text;
                                          String offerDescription =
                                              offerDescriptionController.text;

                                          if (offerTitle.isNotEmpty &&
                                              offerDescription.isNotEmpty &&
                                              selectedIconIndex != null) {
                                            final newOffer = {
                                              'title': offerTitle,
                                              'description': offerDescription,
                                              'icon': offerIcons[
                                                  selectedIconIndex!],
                                            };

                                            setState(() {
                                              offerDescriptions.add(newOffer);
                                              _saveOfferToHive(
                                                  newOffer); // Save to Hive

                                              offerTitleController.clear();
                                              offerDescriptionController
                                                  .clear();
                                              selectedIconIndex = null;
                                              isAddingOfferDescription = false;
                                            });

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Offer added successfully! (${offerDescriptions.length}/6)',
                                                ),
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Please fill in the title, description, and select an icon!'),
                                              ),
                                            );
                                          }
                                        },
                                        child: const Text('Add Offer'),
                                      ),
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 20),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: offerDescriptions.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    padding: const EdgeInsets.all(0),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black12),
                                      color: GlobalVariables.blueBackground,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              padding: const EdgeInsets.all(10),
                                              child: Icon(
                                                offerDescriptions[index]
                                                    ['icon'],
                                                color: Colors.blue,
                                              ),
                                            )),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              // color: Colors.blue[100],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${offerDescriptions[index]['title']}',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: GlobalVariables
                                                          .blueTextColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  '${offerDescriptions[index]['description']}',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () {
                                              setState(() {
                                                _deleteOfferFromHive(
                                                    index); // Delete from Hive
                                                offerDescriptions
                                                    .removeAt(index);
                                              });
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Offer removed successfully!'),
                                                ),
                                              );
                                            }),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: () {
                                  // Navigate back and pass both offers and toggle state
                                  Navigator.pop(
                                    context,
                                    OfferScreenResult(
                                      offerDescriptions: offerDescriptions,
                                      isToggled: isToggled,
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
                            ]),
                        ])))));
  }
}
