import 'package:farstore/features/admin/services/admin_services.dart';
import 'package:farstore/models/bestProducts.dart';
import 'package:farstore/models/category.dart';
import 'package:farstore/models/charges.dart';
import 'package:farstore/models/coupon.dart';
import 'package:farstore/models/orderHive.dart';
import 'package:farstore/models/orderSettings.dart';
import 'package:farstore/providers/shopInfo_provider.dart';
import 'package:farstore/shop_setup/hive_storage/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ShopInfoDisplay extends StatefulWidget {
  static const String routeName = '/sample';
  @override
  _ShopInfoDisplayState createState() => _ShopInfoDisplayState();
}

class _ShopInfoDisplayState extends State<ShopInfoDisplay> {
  late Box<ShopInfoHive> shopInfoBox;
  ShopInfoHive? shopInfo;

  @override
  void initState() {
    super.initState();
    _fetchShopInfo();
  }

  Future<void> _fetchShopInfo() async {
    shopInfoBox = await Hive.openBox<ShopInfoHive>('shopInfo');

    // Retrieve the saved shop information
    final savedShopInfo = shopInfoBox.get('currentShop');

    setState(() {
      shopInfo = savedShopInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shop Info')),
      body: shopInfo == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Shop Name: ${shopInfo!.shopName}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Number: ${shopInfo!.number}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Address: ${shopInfo!.address}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Shop Code: ${shopInfo!.shopCode}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Delivery Price: \$${shopInfo!.delPrice}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text('Categories:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ...shopInfo!.categories.map((category) {
                    return Text(' - ${category['categoryName']}',
                        style: const TextStyle(fontSize: 16));
                  }).toList(),
                  const SizedBox(height: 8),
                  // const Text('Offers:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  // ...shopInfo!.offerDes!.map((offer) {
                  //   return Text(' - $offer', style: const TextStyle(fontSize: 16));
                  // }).toList(),
                  const SizedBox(height: 8),
                  Text(
                      'Last Updated: ${shopInfo!.lastUpdated.toLocal().toString().split(' ')[0]}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text('Social Links:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ...shopInfo!.socialLinks.entries.map((entry) {
                    return Text(' - ${entry.key}: ${entry.value}',
                        style: const TextStyle(fontSize: 16));
                  }).toList(),
                ],
              ),
            ),
    );
  }
}

// import 'package:farstore/constants/global_variables.dart';
// import 'package:farstore/providers/user_provider.dart';
// import 'package:farstore/shop_setup/create_collection_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'dart:io'; // For File

// class CategoriesSetupScreen extends StatefulWidget {
//   static const String routeName = '/setup-category';
//   const CategoriesSetupScreen({Key? key}) : super(key: key);

//   @override
//   State<CategoriesSetupScreen> createState() => _CategoriesSetupScreenState();
// }

// class _CategoriesSetupScreenState extends State<CategoriesSetupScreen> {
//   final TextEditingController _categoryController = TextEditingController();
//   final TextEditingController _subcategoryController = TextEditingController();

//   Map<String, List<String>> _categories = {};
//   Map<String, File?> _categoryImages = {};
//   bool _showCategoryInputField = false;
//   String? _selectedCategory;

//   final ImagePicker _picker = ImagePicker();
//   late Box<Map> _categoriesBox;

//   @override
//   void initState() {
//     super.initState();
//     _categoriesBox = Hive.box<Map>('categoriesBox');
//     _loadCategories();
//   }

//   void _loadCategories() {
//     final storedData = _categoriesBox.toMap();
//     setState(() {
//       _categories = Map<String, List<String>>.from(
//         storedData.map((key, value) =>
//             MapEntry(key, List<String>.from(value['subcategories'] ?? []))),
//       );
//       _categoryImages = Map<String, File?>.from(
//         storedData.map((key, value) => MapEntry(
//             key, value['imagePath'] != null ? File(value['imagePath']) : null)),
//       );
//     });
//   }

//   void _saveCategories() {
//     _categories.forEach((category, subcategories) {
//       _categoriesBox.put(category, {
//         'subcategories': subcategories,
//         'imagePath': _categoryImages[category]
//             ?.path, // Save the image path, not the File object itself
//       });
//     });
//   }

//   void _addCategory() {
//     final categoryName = _categoryController.text.trim();
//     if (categoryName.isNotEmpty) {
//       setState(() {
//         _categories[categoryName] = [];
//         _categoryImages[categoryName] = null;
//         _categoryController.clear();
//         _showCategoryInputField = false;
//       });
//       _saveCategories(); // Save the new category to Hive
//     }
//   }

//   Future<void> _selectImage(String category) async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _categoryImages[category] = File(pickedFile.path);
//       });
//       _saveCategories(); // Save the image for the category
//     }
//   }

//   void _addSubcategory() {
//     if (_selectedCategory != null && _subcategoryController.text.isNotEmpty) {
//       setState(() {
//         _categories[_selectedCategory!]!.add(_subcategoryController.text);
//         _subcategoryController.clear();
//         _selectedCategory = null;
//       });
//       _saveCategories(); // Save the updated subcategories to Hive
//     }
//   }

//   void _deleteCategory(String category) {
//     setState(() {
//       _categories.remove(category);
//       _categoryImages.remove(category);
//       _selectedCategory = null;
//     });
//     _categoriesBox.delete(category); // Remove from Hive
//   }

//   void _deleteSubcategory(String category, String subcategory) {
//     if (_categories.containsKey(category)) {
//       setState(() {
//         _categories[category]!.remove(subcategory); // Remove the subcategory
//         print('Removed subcategory: $subcategory from $category');
//       });
//       _saveCategories(); // Save the updated categories after deletion
//     } else {
//       // Optional: Show a dialog or Snackbar to inform the user
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Category not found for deletion.')),
//       );
//       print('No category found for the subcategory: $subcategory');
//     }
//   }

//   void _selectCategory(String category) {
//     setState(() {
//       _selectedCategory = category; // Set the selected category
//       _subcategoryController.clear(); // Clear the subcategory input field
//     });
//   }

//   List<Map<String, dynamic>> formatCategoriesForServer() {
//     return _categories.entries.map((entry) {
//       return {
//         "categoryName": entry.key,
//         "subcategories": entry.value,
//         "categoryImage": _categoryImages[entry.key]?.path ?? ''
//       };
//     }).toList();
//   }

//   void _sendDataBack() {
//     final formattedCategories = formatCategoriesForServer();

//     Navigator.pop(context, formattedCategories);
//     print('Data sent back to previous screen');
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userProvider = Provider.of<UserProvider>(context);
//     final user = userProvider.user;

//     if (user == null) {
//       return const Center(child: Text("User not found"));
//     }

//     DateTime now = DateTime.now();
//     String formattedDate = DateFormat('EEEE, dd MMM yy').format(now);

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: const Text(
//           'Collection',
//           style: TextStyle(
//               fontFamily: 'Regular',
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//               color: Colors.black),
//         ),
//       ),
//       body: Container(
//         color: Colors.white,
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(
//                   left: 15, right: 15, bottom: 20, top: 15),
//               child: Row(
//                 children: [
//                   const Text(
//                     'Collection',
//                     style: TextStyle(
//                       fontFamily: 'Regular',
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const Spacer(),
//                   GestureDetector(
//                     onTap: () {
//                       // setState(() {
//                       //   _showCategoryInputField = !_showCategoryInputField;
//                       // });
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => CreateCollectionScreen()));
//                     },
//                     child: const Row(
//                       children: [
//                         Icon(
//                           Icons.add,
//                           color: GlobalVariables.greenColor,
//                         ),
//                         SizedBox(width: 5),
//                         Text(
//                           'Add',
//                           style: TextStyle(
//                               fontFamily: 'Regular',
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: GlobalVariables.greenColor),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const Padding(
//                 padding: EdgeInsets.only(left: 15, right: 15),
//                 child: Divider(
//                   color: Colors.grey,
//                 )),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 15),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       if (_showCategoryInputField)
//                         Row(
//                           children: [
//                             Expanded(
//                               child: TextFormField(
//                                 controller: _categoryController,
//                                 decoration: const InputDecoration(
//                                   hintText: "Enter category",
//                                   border: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(15)),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 10),
//                             ElevatedButton(
//                               onPressed: _addCategory,
//                               child: const Text('Add'),
//                             ),
//                           ],
//                         ),
//                       const SizedBox(height: 20),
//                       // Display added categories
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: _categories.keys.map((category) {
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 5),
//                             child: Container(
//                               padding: const EdgeInsets.all(15),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15),
//                                 color: Colors.white,
//                                 border: Border.all(
//                                   color: Colors.grey.shade300,
//                                   width: 1,
//                                 ),
//                               ),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       // Image picker section
//                                       _categoryImages[category] != null
//                                           ? ClipRRect(
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                               child: Image.file(
//                                                 _categoryImages[category]!,
//                                                 height: 60,
//                                                 width: 60,
//                                                 fit: BoxFit.cover,
//                                               ),
//                                             )
//                                           : GestureDetector(
//                                               onTap: () =>
//                                                   _selectImage(category),
//                                               child: Container(
//                                                 width: 60,
//                                                 height: 60,
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(10),
//                                                   border: Border.all(
//                                                     color: Colors.grey.shade300,
//                                                     width: 1,
//                                                   ),
//                                                 ),
//                                                 child: const Icon(
//                                                   Icons
//                                                       .add_photo_alternate_outlined,
//                                                   color: Colors.grey,
//                                                 ),
//                                               ),
//                                             ),
//                                       const SizedBox(width: 15),

//                                       // Category name and actions
//                                       Expanded(
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 Expanded(
//                                                   child: Text(
//                                                     category,
//                                                     style: const TextStyle(
//                                                       fontSize: 16,
//                                                       fontFamily: 'Regular',
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 IconButton(
//                                                   icon: const Icon(Icons.delete,
//                                                       color: Colors.red,
//                                                       size: 20),
//                                                   onPressed: () =>
//                                                       _deleteCategory(category),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),

//                                   const Divider(height: 20),

//                                   // Subcollections header with dropdown
//                                   ExpansionTile(
//                                     tilePadding: EdgeInsets.zero,
//                                     title: Row(
//                                       children: [
//                                         const Text(
//                                           'Sub-collection',
//                                           style: TextStyle(
//                                             fontFamily: 'Regular',
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                         const Spacer(),
//                                         Text(
//                                           '${_categories[category]!.length} items',
//                                           style: TextStyle(
//                                             color: Colors.grey.shade600,
//                                             fontSize: 12,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     children: [
//                                       // Add subcategory button
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             vertical: 8),
//                                         child: Row(
//                                           children: [
//                                             const Text(
//                                               'Sub-collection',
//                                               style: TextStyle(
//                                                 fontFamily: 'Regular',
//                                                 fontSize: 14,
//                                                 color: Colors.grey,
//                                               ),
//                                             ),
//                                             const Spacer(),
//                                             GestureDetector(
//                                               onTap: () {
//                                                 setState(() {
//                                                   _selectedCategory = category;
//                                                   _subcategoryController
//                                                       .clear();
//                                                 });
//                                               },
//                                               child: const Row(
//                                                 children: [
//                                                   Icon(
//                                                     Icons.add,
//                                                     color: GlobalVariables
//                                                         .greenColor,
//                                                     size: 20,
//                                                   ),
//                                                   SizedBox(width: 4),
//                                                   Text(
//                                                     'ADD',
//                                                     style: TextStyle(
//                                                       fontFamily: 'Regular',
//                                                       fontSize: 14,
//                                                       color: GlobalVariables
//                                                           .greenColor,
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),

//                                       // Subcategory input field
//                                       if (_selectedCategory == category)
//                                         Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               vertical: 8),
//                                           child: Row(
//                                             children: [
//                                               Expanded(
//                                                 child: TextFormField(
//                                                   controller:
//                                                       _subcategoryController,
//                                                   decoration:
//                                                       const InputDecoration(
//                                                     hintText:
//                                                         "Enter subcategory",
//                                                     contentPadding:
//                                                         EdgeInsets.symmetric(
//                                                             horizontal: 12,
//                                                             vertical: 8),
//                                                     border: OutlineInputBorder(
//                                                       borderRadius:
//                                                           BorderRadius.all(
//                                                               Radius.circular(
//                                                                   10)),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               const SizedBox(width: 8),
//                                               IconButton(
//                                                 icon: const Icon(Icons.check,
//                                                     color: Colors.green),
//                                                 onPressed: _addSubcategory,
//                                               ),
//                                             ],
//                                           ),
//                                         ),

//                                       // List of subcategories
//                                       Column(
//                                         children: _categories[category]!
//                                             .map((subcategory) {
//                                           return Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 vertical: 4),
//                                             child: Row(
//                                               children: [
//                                                 const Icon(
//                                                   Icons
//                                                       .subdirectory_arrow_right,
//                                                   color: Colors.grey,
//                                                   size: 20,
//                                                 ),
//                                                 const SizedBox(width: 8),
//                                                 Text(
//                                                   subcategory,
//                                                   style: const TextStyle(
//                                                     fontSize: 14,
//                                                     color: Colors.black87,
//                                                   ),
//                                                 ),
//                                                 const Spacer(),
//                                                 IconButton(
//                                                   icon: const Icon(
//                                                     Icons.delete,
//                                                     color: Colors.red,
//                                                     size: 18,
//                                                   ),
//                                                   onPressed: () =>
//                                                       _deleteSubcategory(
//                                                           category,
//                                                           subcategory),
//                                                 ),
//                                               ],
//                                             ),
//                                           );
//                                         }).toList(),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(15),
//               child: GestureDetector(
//                 onTap: () {
//                   _sendDataBack();
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.all(15),
//                   decoration: BoxDecoration(
//                     color: Colors.green,
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: const Center(
//                     child: Text(
//                       'Continue',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontFamily: 'SemiBold',
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class SampleCollectionScreen extends StatefulWidget {
  const SampleCollectionScreen({Key? key}) : super(key: key);

  @override
  _SampleCollectionScreenState createState() => _SampleCollectionScreenState();
}

class _SampleCollectionScreenState extends State<SampleCollectionScreen> {
  late Box<Category> categoryBox;

  @override
  void initState() {
    super.initState();
    openHiveBox();
  }

  Future<void> openHiveBox() async {
    categoryBox = await Hive.openBox<Category>('categories');
    setState(() {}); // Refresh UI after opening the box
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: FutureBuilder(
        future: Hive.openBox<Category>('categories'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ValueListenableBuilder(
              valueListenable: categoryBox.listenable(),
              builder: (context, Box<Category> box, _) {
                if (box.isEmpty) {
                  return const Center(child: Text('No categories found.'));
                }

                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final category = box.getAt(index);

                    if (category == null) return const SizedBox();

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        leading: category.categoryImage != null
                            ? Image.network(
                                category.categoryImage!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.category),
                        title: Text(category.categoryName),
                        subtitle: Text(
                          'Subcategories: ${category.subcategories.join(', ')}',
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    categoryBox.close(); // Ensure the box is closed when the screen is disposed
    super.dispose();
  }
}

class ShopInfoDisplayWidget extends StatefulWidget {
  const ShopInfoDisplayWidget({Key? key}) : super(key: key);

  @override
  _ShopInfoDisplayWidgetState createState() => _ShopInfoDisplayWidgetState();
}

class _ShopInfoDisplayWidgetState extends State<ShopInfoDisplayWidget> {
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
    final shopInfo = Provider.of<ShopInfoProvider>(context).shopInfo;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Information'),
        centerTitle: true,
      ),
      body: shopInfo == null
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.store, size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No shop information available',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                            icon: Icons.store,
                            label: 'Shop Name',
                            value: shopInfo.shopName,
                          ),
                          _buildDivider(),
                          _buildInfoRow(
                            icon: Icons.phone,
                            label: 'Phone Number',
                            value: shopInfo.number.toString(),
                          ),
                          _buildDivider(),
                          _buildInfoRow(
                            icon: Icons.location_on,
                            label: 'Address',
                            value: shopInfo.address,
                          ),
                          _buildDivider(),
                          _buildInfoRow(
                            icon: Icons.code,
                            label: 'Shop Code',
                            value: shopInfo.shopCode,
                          ),
                          _buildDivider(),
                          _buildInfoRow(
                            icon: Icons.delivery_dining,
                            label: 'Delivery Price',
                            value: '₹${shopInfo.delPrice!.toStringAsFixed(2)}',
                          ),
                          if (shopInfo.offertime != null) _buildDivider(),
                          if (shopInfo.offertime != null)
                            _buildInfoRow(
                              icon: Icons.timer,
                              label: 'Offer Time',
                              value: DateFormat('dd MMM yyyy HH:mm')
                                  .format(shopInfo.offertime!),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (shopInfo.categories != null &&
                      shopInfo.categories!.isNotEmpty)
                    _buildCategoriesSection(shopInfo.categories!),
                  const SizedBox(height: 16),
                  // if (shopInfo.coupon != null && shopInfo.coupon!.isNotEmpty)
                  //   Card(
                  //     elevation: 4,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(16.0),
                  //       child: _buildCouponSection(shopInfo.coupon!),
                  //     ),
                  //   ),
                ],
              ),
            ),
    );
  }

  Widget _buildCategoriesSection(List<Category> categories) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final category = categories[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (category.categoryImage != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              category.categoryImage!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported),
                                );
                              },
                            ),
                          ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category.categoryName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (category.subcategories.isNotEmpty)
                                const SizedBox(height: 8),
                              if (category.subcategories.isNotEmpty)
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children:
                                      category.subcategories.map((subcategory) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue[50],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        subcategory,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue[700],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Divider(height: 1, color: Colors.grey),
    );
  }

  Widget _buildCouponSection(List<Coupon> coupons) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Coupons',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        ...coupons.map((coupon) => Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                children: [
                  const Icon(Icons.discount, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${coupon.couponCode} - ${coupon.off}% off on purchases above ₹${coupon.price}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}

// class OrderStorageScreen extends StatelessWidget {
//   const OrderStorageScreen({Key? key}) : super(key: key);

//   // Convert status code to human-readable string
//   String _getStatusText(int status) {
//     switch (status) {
//       case 0:
//         return 'Accepted';
//       case 1:
//         return 'Shipped';
//       default:
//         return 'Unknown';
//     }
//   }

//   // Get status color based on status code
//   Color _getStatusColor(int status) {
//     switch (status) {
//       case 0:
//         return Colors.orange;
//       case 1:
//         return Colors.blue;
//       case 2:
//         return Colors.purple;
//       case 3:
//         return Colors.green;
//       case 4:
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Order Storage'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               // Trigger rebuild of ValueListenableBuilder
//               Hive.box<OrderHive>('orderBox').listenable();
//             },
//           ),
//         ],
//       ),
//       body: ValueListenableBuilder(
//         valueListenable: Hive.box<OrderHive>('orderBox').listenable(),
//         builder: (context, Box<OrderHive> box, _) {
//           if (box.isEmpty) {
//             return const Center(
//               child: Text(
//                 'No orders found',
//                 style: TextStyle(fontSize: 18),
//               ),
//             );
//           }

//           return ListView.builder(
//             itemCount: box.length,
//             itemBuilder: (context, index) {
//               final order = box.getAt(index);
//               if (order == null) return const SizedBox.shrink();

//               return Card(
//                 margin: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 8,
//                 ),
//                 child: ListTile(
//                   leading: CircleAvatar(
//                     backgroundColor: _getStatusColor(order.status),
//                     child: Text(
//                       order.status.toString(),
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                   ),
//                   title: Text(
//                     'Order ID: ${order.orderId}',
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   subtitle: Text(
//                     'Status: ${_getStatusText(order.status)}',
//                     style: TextStyle(
//                       color: _getStatusColor(order.status),
//                     ),
//                   ),
//                   trailing: PopupMenuButton<int>(
//                     onSelected: (int newStatus) {
//                       order.updateStatus(newStatus);
//                     },
//                     itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
//                       const PopupMenuItem<int>(
//                         value: 0,
//                         child: Text('Accept'),
//                       ),
//                       const PopupMenuItem<int>(
//                         value: 1,
//                         child: Text('Shipped'),
//                       ),
//                     ],
//                   ),
//                   onTap: () {
//                     // Show order details
//                     showDialog(
//                       context: context,
//                       builder: (context) => AlertDialog(
//                         title: Text('Order ${order.orderId}'),
//                         content: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('Status: ${_getStatusText(order.status)}'),
//                             const SizedBox(height: 8),
//                             Text('JSON Data: ${order.toJson()}'),
//                           ],
//                         ),
//                         actions: [
//                           TextButton(
//                             onPressed: () => Navigator.pop(context),
//                             child: const Text('Close'),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

class OrderStorageScreen extends StatefulWidget {
  static const String routeName = '/order-storage';

  const OrderStorageScreen({Key? key}) : super(key: key);

  @override
  State<OrderStorageScreen> createState() => _OrderStorageScreenState();
}

class _OrderStorageScreenState extends State<OrderStorageScreen> {
  late Box<OrderHive> _orderHiveBox;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    try {
      _orderHiveBox = await Hive.openBox<OrderHive>('orderBox');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load stored orders: $e';
          _isLoading = false;
        });
      }
    }
  }

  String getStatusText(int status) {
    switch (status) {
      case 0:
        return 'Accepted';
      case 1:
        return 'Preparing';
      case 2:
        return 'Ready';
      case 3:
        return 'Delivered';
      default:
        return 'Unknown';
    }
  }

  Color getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stored Orders',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Regular',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : ValueListenableBuilder(
                  valueListenable: _orderHiveBox.listenable(),
                  builder: (context, Box<OrderHive> box, _) {
                    if (box.isEmpty) {
                      return const Center(
                        child: Text('No orders stored locally'),
                      );
                    }

                    return ListView.builder(
                      itemCount: box.length,
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        final order = box.getAt(index);
                        if (order == null) return const SizedBox.shrink();

                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Order ID: ${order.orderId.substring(0, 8)}',
                                      style: const TextStyle(
                                        fontFamily: 'SemiBold',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: getStatusColor(order.status)
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        getStatusText(order.status),
                                        style: TextStyle(
                                          color: getStatusColor(order.status),
                                          fontFamily: 'Regular',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Divider(),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      height: 8,
                                      width: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: getStatusColor(order.status),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Status Code: ${order.status}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'Regular',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }

  @override
  void dispose() {
    _orderHiveBox.close();
    super.dispose();
  }
}

class ChargesScreens extends StatefulWidget {
  @override
  _ChargesScreensState createState() => _ChargesScreensState();
}

class _ChargesScreensState extends State<ChargesScreens> {
  Charges? _charges;

  @override
  void initState() {
    super.initState();
    _loadCharges();
  }

  Future<void> _loadCharges() async {
    try {
      final charges = await Charges.getFromHive();
      setState(() {
        _charges = charges;
      });
    } catch (e) {
      print('Error loading charges: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Charges Details'),
      ),
      body: _charges == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  _buildChargesTile(
                    'Delivery Charges Enabled',
                    _charges!.isDeliveryChargesEnabled ? 'Yes' : 'No',
                  ),
                  _buildChargesTile(
                    'Delivery Charges',
                    _charges!.deliveryCharges?.toStringAsFixed(2) ?? 'Not set',
                  ),
                  _buildChargesTile(
                    'Start Date',
                    _charges!.startDate != null
                        ? _charges!.startDate!
                            .toLocal()
                            .toString()
                            .split(' ')[0]
                        : 'Not set',
                  ),
                  _buildChargesTile(
                    'End Date',
                    _charges!.endDate != null
                        ? _charges!.endDate!.toLocal().toString().split(' ')[0]
                        : 'Not set',
                  ),
                  _buildChargesTile(
                    'Start Time',
                    _charges!.startTime != null
                        ? _charges!.startTime!.format(context)
                        : 'Not set',
                  ),
                  _buildChargesTile(
                    'End Time',
                    _charges!.endTime != null
                        ? _charges!.endTime!.format(context)
                        : 'Not set',
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildChargesTile(String title, String value) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
      leading: Icon(Icons.info, color: Colors.blueAccent),
    );
  }
}


class ChargesTestScreen extends StatefulWidget {
  const ChargesTestScreen({Key? key}) : super(key: key);

  @override
  _ChargesTestScreenState createState() => _ChargesTestScreenState();
}

class _ChargesTestScreenState extends State<ChargesTestScreen> {
  Charges? charges;

  @override
  void initState() {
    super.initState();
    _loadCharges();
  }

  Future<void> _loadCharges() async {
    try {
      final retrievedCharges = await Charges.getFromHive();
      setState(() {
        charges = retrievedCharges;
      });
    } catch (e) {
      print('Error loading charges: $e');
    }
  }

  Widget _buildChargesDetails() {
    if (charges == null) {
      return const Center(child: Text('No charges found in Hive.'));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery Charges Enabled: ${charges!.isDeliveryChargesEnabled}',
            style: const TextStyle(fontSize: 16),
          ),
          if (charges!.deliveryCharges != null)
            Text(
              'Delivery Charges: ₹${charges!.deliveryCharges!.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16),
            ),
          if (charges!.startDate != null)
            Text(
              'Start Date: ${charges!.startDate!.toLocal().toString().split(' ')[0]}',
              style: const TextStyle(fontSize: 16),
            ),
          if (charges!.endDate != null)
            Text(
              'End Date: ${charges!.endDate!.toLocal().toString().split(' ')[0]}',
              style: const TextStyle(fontSize: 16),
            ),
          if (charges!.startTime != null)
            Text(
              'Start Time: ${charges!.startTime!.format(context)}',
              style: const TextStyle(fontSize: 16),
            ),
          if (charges!.endTime != null)
            Text(
              'End Time: ${charges!.endTime!.format(context)}',
              style: const TextStyle(fontSize: 16),
            ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await Charges.deleteFromHive();
              setState(() {
                charges = null;
              });
            },
            child: const Text('Clear Charges'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Charges Details'),
      ),
      body: charges == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(child: _buildChargesDetails()),
    );
  }
}





class ChargessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final shopInfoProvider = Provider.of<ShopInfoProvider>(context);
    final charges = shopInfoProvider.shopInfo?.charges;
    print('---Charges data: ${charges!.startDate}');


    return Scaffold(
      appBar: AppBar(
        title: Text('Charges Details'),
      ),
      body: charges != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Delivery Charges Enabled:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Switch(
                        value: charges.isDeliveryChargesEnabled,
                        onChanged: null,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Delivery Charges:',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        charges.deliveryCharges != null
                            ? '${charges.deliveryCharges!.toStringAsFixed(2)}'
                            : 'N/A',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Active Duration:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
  charges.startDate != null
      ? DateFormat('yyyy-MM-dd').format(charges.startDate!)
      : 'No Start Date Available',
  style: TextStyle(fontSize: 16),
),
Text(
  charges.endDate != null
      ? DateFormat('yyyy-MM-dd').format(charges.endDate!)
      : 'No End Date Available',
  style: TextStyle(fontSize: 16),
),

                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'End Date:',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        charges.endDate != null
                            ? DateFormat('yyyy-MM-dd').format(charges.endDate!)
                            : 'N/A',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Active Time:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Start Time:',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        charges.startTimeMinutes != null
                            ? _formatMinutes(charges.startTimeMinutes!)
                            : 'N/A',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'End Time:',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        charges.endTimeMinutes != null
                            ? _formatMinutes(charges.endTimeMinutes!)
                            : 'N/A',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : Center(
              child: Text(
                'No Charges Data Available',
                style: TextStyle(fontSize: 16),
              ),
            ),
    );
  }

  String _formatMinutes(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}';
  }
}



class BestProductsScreen extends StatefulWidget {
  @override
  _BestProductsScreenState createState() => _BestProductsScreenState();
}

class _BestProductsScreenState extends State<BestProductsScreen> {
  late Box<BestProduct> _bestProductsBox;
  List<BestProduct> _bestProductsList = [];

  @override
  void initState() {
    super.initState();
    _loadBestProducts();
  }

  // Method to load products from Hive
  Future<void> _loadBestProducts() async {
    // Open the box
    _bestProductsBox = await Hive.openBox<BestProduct>('bestProductsBox');
    
    // Get all products in the box and log the values
    List<BestProduct> products = _bestProductsBox.values.toList();
    debugPrint("Loaded Products: $products");

    setState(() {
      _bestProductsList = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stored Products'),
      ),
      body: _bestProductsList.isEmpty
          ? Center(child: CircularProgressIndicator())  
          : ListView.builder(
              itemCount: _bestProductsList.length,
              itemBuilder: (context, index) {
                final product = _bestProductsList[index];

                // Debugging print statement to check each product
                debugPrint("Displaying product: ${product.name}, Quantity: ${product.quantity}, Total Amount: ${product.discountPrice}");

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(product.name),
                    subtitle: Text('Quantity: ${product.quantity}, Total Amount: ${product.discountPrice}'),
                  ),
                );
              },
            ),
    );
  }
}


// class CouponsScreen extends StatefulWidget {
//   const CouponsScreen({Key? key}) : super(key: key);

//   @override
//   State<CouponsScreen> createState() => _CouponsScreenState();
// }

// class _CouponsScreenState extends State<CouponsScreen> {
//   Box<Coupon>? _couponBox;
//   bool _isHiveInitialized = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeHive();
//   }

//   Future<void> _initializeHive() async {
//     await Hive.initFlutter();

//     // Register the adapter if not already registered
//     if (!Hive.isAdapterRegistered(12)) {
//       Hive.registerAdapter(CouponAdapter());
//     }

//     // Open the box
//     _couponBox = await Hive.openBox<Coupon>('coupons');

//     // Update the state to indicate initialization is complete
//     setState(() {
//       _isHiveInitialized = true;
//     });
//   }

//   @override
//   void dispose() {
//     _couponBox?.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Coupon Details'),
//         centerTitle: true,
//       ),
//       body: _isHiveInitialized
//           ? ValueListenableBuilder(
//               valueListenable: _couponBox!.listenable(),
//               builder: (context, Box<Coupon> box, _) {
//                 if (box.isEmpty) {
//                   return const Center(
//                     child: Text('No coupons available'),
//                   );
//                 }

//                 return ListView.builder(
//                   itemCount: box.length,
//                   itemBuilder: (context, index) {
//                     final coupon = box.getAt(index);

//                     if (coupon == null) return const SizedBox.shrink();

//                     return Card(
//                       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                       child: ExpansionTile(
//                         title: Text(
//                           coupon.couponCode,
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         subtitle: Text('Discount: ${coupon.off}%'),
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 // Date and Time Section with Enhanced Visibility
//                                 if (coupon.startDate != null && coupon.endDate != null)
//                                   Container(
//                                     padding: const EdgeInsets.symmetric(vertical: 8),
//                                     decoration: BoxDecoration(
//                                       color: Colors.blue.shade50,
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     child: Column(
//                                       children: [
//                                         Text(
//                                           'Coupon Validity',
//                                           style: TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.blue.shade800,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 8),
//                                         Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                           children: [
//                                             Column(
//                                               children: [
//                                                 Text(
//                                                   'Start Date',
//                                                   style: TextStyle(color: Colors.blue.shade700),
//                                                 ),
//                                                 Text(
//                                                   coupon.startDate!.toLocal().toString().split(' ')[0],
//                                                   style: const TextStyle(fontWeight: FontWeight.bold),
//                                                 ),
//                                               ],
//                                             ),
//                                             Column(
//                                               children: [
//                                                 Text(
//                                                   'End Date',
//                                                   style: TextStyle(color: Colors.blue.shade700),
//                                                 ),
//                                                 Text(
//                                                   coupon.endDate!.toLocal().toString().split(' ')[0],
//                                                   style: const TextStyle(fontWeight: FontWeight.bold),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                         const Divider(),
//                                         Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                           children: [
//                                             Column(
//                                               children: [
//                                                 Text(
//                                                   'Start Time',
//                                                   style: TextStyle(color: Colors.blue.shade700),
//                                                 ),
//                                                 Text(
//                                                   '${coupon.startTime!.hour}:${coupon.startTime!.minute.toString().padLeft(2, '0')}',
//                                                   style: const TextStyle(fontWeight: FontWeight.bold),
//                                                 ),
//                                               ],
//                                             ),
//                                             Column(
//                                               children: [
//                                                 Text(
//                                                   'End Time',
//                                                   style: TextStyle(color: Colors.blue.shade700),
//                                                 ),
//                                                 Text(
//                                                   '${coupon.endTime!.hour}:${coupon.endTime!.minute.toString().padLeft(2, '0')}',
//                                                   style: const TextStyle(fontWeight: FontWeight.bold),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),

//                                 const SizedBox(height: 16),

//                                 // Existing detail rows
//                                 _buildDetailRow('Discount', '${coupon.off}%'),
                                
//                                 if (coupon.price != null)
//                                   _buildDetailRow('Minimum Purchase', 
//                                     '\$${coupon.price!.toStringAsFixed(2)}'),
                                
//                                 // Limit Details
//                                 if (coupon.customLimit != null)
//                                   _buildDetailRow('Custom Limit', 
//                                     '${coupon.customLimit}'),
                                
//                                 if (coupon.limit != null)
//                                   _buildDetailRow('Limit Enabled', 
//                                     coupon.limit! ? 'Yes' : 'No'),
                                
//                                 // Validation Checks
//                                 _buildDetailRow('Date Range Valid', 
//                                   coupon.isValidDateRange() ? 'Yes' : 'No'),
                                
//                                 _buildDetailRow('Time Range Valid', 
//                                   coupon.isValidTimeRange() ? 'Yes' : 'No'),
//                               ],
//                             ),
//                           ),
//                           ButtonBar(
//                             children: [
//                               TextButton(
//                                 onPressed: () => _deleteCoupon(index),
//                                 child: const Text('Delete', style: TextStyle(color: Colors.red)),
//                               ),
//                               TextButton(
//                                 onPressed: () => _editCoupon(coupon),
//                                 child: const Text('Edit'),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               },
//             )
//           : const Center(child: CircularProgressIndicator()),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _addDummyCoupon,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   // Helper method to create consistent detail rows
//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(fontWeight: FontWeight.w600),
//           ),
//           Text(value),
//         ],
//       ),
//     );
//   }

//   void _deleteCoupon(int index) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Coupon'),
//         content: const Text('Are you sure you want to delete this coupon?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               _couponBox?.deleteAt(index);
//               Navigator.of(context).pop();
//             },
//             child: const Text('Delete', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }

//   void _editCoupon(Coupon coupon) {
//     // Placeholder for edit functionality
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Edit functionality not implemented')),
//     );
//   }

//   void _addDummyCoupon() {
//     final dummyCoupon = Coupon(
//       couponCode: 'SAVE10',
//       off: 10.0,
//       price: 50.0,
//       customLimit: 100,
//       limit: true,
//       startDate: DateTime.now(),
//       endDate: DateTime.now().add(const Duration(days: 30)),
//       startTime: const TimeOfDay(hour: 9, minute: 0),
//       endTime: const TimeOfDay(hour: 18, minute: 0),
//     ); 
//     _couponBox?.add(dummyCoupon);
//   }
// }




// class CouponDisplayScreen extends StatefulWidget {
//   const CouponDisplayScreen({Key? key}) : super(key: key);

//   @override
//   _CouponDisplayScreenState createState() => _CouponDisplayScreenState();
// }

// class _CouponDisplayScreenState extends State<CouponDisplayScreen> {
//   Coupon? _coupon;
//   bool _isLoading = true;
//   String _errorMessage = '';

//   @override
//   void initState() {
//     super.initState();
//     _loadCouponFromHive();
//   }

//   Future<void> _loadCouponFromHive() async {
//     try {
//       final coupon = await Coupon.getFromHive();
//       setState(() {
//         _coupon = coupon;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Failed to load coupon: $e';
//         _isLoading = false;
//       });
//     }
//   }

//   String? _formatDate(DateTime? date) {
//     if (date == null) return null;
//     return DateFormat('yyyy-MM-dd').format(date);
//   }

//   String? _formatTime(TimeOfDay? time) {
//     if (time == null) return null;
//     return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Coupon Details'),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _errorMessage.isNotEmpty
//               ? Center(child: Text(_errorMessage))
//               : _coupon == null
//                   ? const Center(child: Text('No coupon found'))
//                   : ListView(
//                       padding: const EdgeInsets.all(16.0),
//                       children: [
//                         _buildDetailRow('Coupon Code', _coupon!.couponCode),
//                         _buildDetailRow('Discount Off', '${_coupon!.off}%'),
//                         _buildDetailRow('Price', _coupon!.price?.toStringAsFixed(2) ?? 'N/A'),
//                         _buildDetailRow('Custom Limit', _coupon!.customLimit?.toString() ?? 'N/A'),
//                         _buildDetailRow('Limit', _coupon!.limit == true ? 'Yes' : 'No'),
//                         _buildDetailRow('Start Date', _formatDate(_coupon!.startDate) ?? 'N/A'),
//                         _buildDetailRow('End Date', _formatDate(_coupon!.endDate) ?? 'N/A'),
//                         _buildDetailRow('Start Time', _formatTime(_coupon!.startTime) ?? 'N/A'),
//                         _buildDetailRow('End Time', _formatTime(_coupon!.endTime) ?? 'N/A'),
//                       ],
//                     ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           Text(value),
//         ],
//       ),
//     );
//   }
// }




class CreatedCouponsScreen extends StatefulWidget {
  @override
  _CreatedCouponsScreenState createState() => _CreatedCouponsScreenState();
}

class _CreatedCouponsScreenState extends State<CreatedCouponsScreen> {
  late Box<Coupon> _couponBox;

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  void _initializeHive() async {
    // Open the Hive box for coupons (ensure it is initialized elsewhere in your app)
    _couponBox = await Hive.openBox<Coupon>('coupons');
    setState(() {}); // Refresh the UI after the box is opened
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Created Coupons'),
      ),
      body: _couponBox.isOpen
          ? ValueListenableBuilder(
              valueListenable: _couponBox.listenable(),
              builder: (context, Box<Coupon> box, _) {
                if (box.isEmpty) {
                  return const Center(
                    child: Text('No coupons available.'),
                  );
                }

                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final coupon = box.getAt(index);

                    return ListTile(
                      title: Text(coupon?.couponCode ?? 'Unknown Code'),
                      subtitle: Text(
                          'Off: ${coupon?.off.toStringAsFixed(2)} | Price: ${coupon?.price?.toStringAsFixed(2) ?? 'N/A'}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteCoupon(index),
                      ),
                      onTap: () => _showCouponDetails(coupon),
                    );
                  },
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  void _deleteCoupon(int index) {
    setState(() {
      _couponBox.deleteAt(index);
    });
  }

  void _showCouponDetails(Coupon? coupon) {
    if (coupon == null) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Details of ${coupon.couponCode}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Off: ${coupon.off.toStringAsFixed(2)}'),
              Text('Price: ${coupon.price?.toStringAsFixed(2) ?? 'N/A'}'),
              Text('Custom Limit: ${coupon.customLimit ?? 'N/A'}'),
              Text('Limit: ${coupon.limit ?? false}'),
              Text('Start Date: ${coupon.startDate ?? 'N/A'}'),
              Text('End Date: ${coupon.endDate ?? 'N/A'}'),
              Text('Start Time Minutes: ${coupon.startTimeMinutes ?? 'N/A'}'),
              Text('End Time Minutes: ${coupon.endTimeMinutes ?? 'N/A'}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _couponBox.close();
    super.dispose();
  }
}



class OrderSettingsScreens extends StatefulWidget {
  @override
  _OrderSettingsScreensState createState() => _OrderSettingsScreensState();
}

class _OrderSettingsScreensState extends State<OrderSettingsScreens> {
  late Box<OrderSettings> orderSettingsBox;
  OrderSettings? settings;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    orderSettingsBox = await Hive.openBox<OrderSettings>('order_settings');
    if (orderSettingsBox.isNotEmpty) {
      settings = orderSettingsBox.getAt(0);
    } else {
      settings = OrderSettings(); // Load default if none exist
      await orderSettingsBox.add(settings!);
    }
    setState(() {});
  }

  @override
  void dispose() {
    orderSettingsBox.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Settings'),
      ),
      body: settings == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildSettingTile('Order Acceptance Enabled', settings!.isOrderAcceptanceEnabled),
                _buildSettingTile('Notifications Enabled', settings!.isNotificationEnabled),
                _buildSettingTile('Auto Accept Enabled', settings!.isAutoAcceptEnabled),
                _buildSettingTile('Order Accept Enabled', settings!.isOrderAcceptEnabled),
                _buildSettingTile('Order Confirmation Enabled', settings!.isOrderConfirmationEnabled),
                _buildSettingTile('WhatsApp Updates Enabled', settings!.isWhatsAppUpdatesEnabled),
                _buildSettingTile('Order Cancellation Allowed', settings!.isOrderCancellationAllowed),
                _buildSettingTile('Selected Delivery Mode', settings!.selectedDeliveryMode),
                _buildSettingTile('Selected Payment Type', settings!.selectedPaymentType),
                _buildSettingTile('Cancellation Policy', settings!.cancellationPolicy ?? 'None'),
              ],
            ),
    );
  }

  Widget _buildSettingTile(String title, dynamic value) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(title),
        subtitle: Text(value.toString()),
        leading: Icon(
          value is bool ? (value ? Icons.check_circle : Icons.cancel) : Icons.info,
          color: value is bool ? (value ? Colors.green : Colors.red) : Colors.blue,
        ),
      ),
    );
  }
}