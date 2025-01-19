import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:farstore/constants/utils.dart';
import 'package:farstore/features/admin/services/admin_services.dart';
import 'package:farstore/models/category.dart';
import 'package:farstore/widgets/color_picker.dart';
import 'package:farstore/widgets/custom_dropdown_field.dart';
import 'package:farstore/widgets/custom_text_field.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = '/add-product';

  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController discountPriceController = TextEditingController();
  final TextEditingController basePriceController = TextEditingController();
  bool _trackQuantity = false;

  final AdminServices adminServices = AdminServices();
  Color currentColor = Colors.green;

  Box<dynamic>? categoriesBox;
  List<Category> categories = [];
  String? category;
  String? subCategory;
  List<File> images = [];
  List<String> selectedColors = [];
  final _addProductFormKey = GlobalKey<FormState>();
  bool isLoading = true;
  String? errorMessage;
  bool isBoxInitialized = false;

  final List<String> offerTexts = [
    "Limited Stock Available!",
    "Special Offer: Limited Time Only!",
    "Last Chance to Save!",
    "One-Day-Only Deal!",
    "End-of-Season Sale!",
    "Limited Edition Savings!",
    "Mega Discount!",
    "Limited time deal",
  ];
  String selectedOffer = "";

  @override
  void initState() {
    super.initState();
    _initializeHiveBox();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load categories here instead of initState
    if (isLoading) {
      _loadCategories();
    }
  }

  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Allow only digits and one decimal point
    if (newValue.text.contains('.')) {
      // Split by decimal point and check decimals
      final parts = newValue.text.split('.');
      // Allow only two decimal places
      if (parts.length == 2 && parts[1].length > 2) {
        return oldValue;
      }
    }

    // Validate the format
    if (!RegExp(r'^\d*\.?\d{0,2}$').hasMatch(newValue.text)) {
      return oldValue;
    }

    return newValue;
  }

  Future<void> _initializeHiveBox() async {
    try {
      // First check if Hive is initialized
      if (!Hive.isAdapterRegistered(4)) {
        // Use your actual adapter type ID
        Hive.registerAdapter(CategoryAdapter());
      }

      // Check if the box is already open
      if (Hive.isBoxOpen('categories')) {
        categoriesBox = Hive.box<Category>('categories');
      } else {
        categoriesBox = await Hive.openBox<Category>('categories');
      }

      setState(() {
        isBoxInitialized = true;
      });

      await _loadCategories();
    } catch (e) {
      print('Error initializing Hive box: $e');
      if (mounted) {
        setState(() {
          errorMessage =
              'Failed to initialize database. Please restart the app.';
          isLoading = false;
        });
      }
    }
  }

  Future<void> _loadCategories() async {
    if (!mounted) return;

    try {
      if (!isBoxInitialized) {
        throw HiveError('Categories box is not initialized');
      }

      // Safely get categories from the box
      List<Category> loadedCategories = [];

      // Use toList() to create a snapshot of the data
      final boxValues = categoriesBox!.values.toList();

      for (var item in boxValues) {
        if (item is Category) {
          loadedCategories.add(item);
        } else {
          print(
              'Warning: Invalid data type found in categories box: ${item.runtimeType}');
        }
      }

      if (mounted) {
        setState(() {
          categories = loadedCategories;
          isLoading = false;
          errorMessage = null;
        });
      }
    } catch (e) {
      print('Error loading categories: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load categories. Please try again.';
        });
      }
    }
  }

  List<String> getSubcategories() {
    if (category == null || categories.isEmpty) return [];

    try {
      final selectedCategory = categories.firstWhere(
        (cat) => cat.categoryName == category,
        orElse: () => Category(
          id: '',
          categoryName: '',
          subcategories: [],
        ),
      );
      return selectedCategory.subcategories;
    } catch (e) {
      print('Error getting subcategories: $e');
      return [];
    }
  }

  @override
  void dispose() {
    productNameController.dispose();
    descriptionController.dispose();
    noteController.dispose();
    priceController.dispose();
    discountPriceController.dispose();
    basePriceController.dispose();
    quantityController.dispose();
    if (isBoxInitialized && Hive.isBoxOpen('categories')) {
      categoriesBox!.close();
    }
    super.dispose();
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  List<int> selectedNumbers = []; // To hold selected sizes

  // List of sizes and corresponding numbers
  final List<Map<String, dynamic>> sizes = [
    {'label': 'S', 'number': 1},
    {'label': 'M', 'number': 2},
    {'label': 'L', 'number': 3},
    {'label': 'XL', 'number': 4},
    {'label': 'XXL', 'number': 5},
  ];

  // Function to toggle selection
  void toggleSelection(int number) {
    setState(() {
      if (selectedNumbers.contains(number)) {
        selectedNumbers.remove(number); // Unselect if already selected
      } else {
        selectedNumbers.add(number); // Add to selected array
      }
    });
  }

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
    });
  }

  void addOrRemoveColor(Color color) {
    String hexColor = '#${color.value.toRadixString(16).padLeft(8, '0')}';
    setState(() {
      if (selectedColors.contains(hexColor)) {
        selectedColors.remove(hexColor);
      } else {
        selectedColors.add(hexColor);
      }
    });
  }

  String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0')}';
  }

  void addProduct() {
    if (_addProductFormKey.currentState!.validate() &&
        images.isNotEmpty &&
        category != null) {
      // Check if category is not null

      List<String> colorHexCodes = selectedColors;

      List<String> selectedSizes = selectedNumbers.map((number) {
        return sizes.firstWhere((size) => size['number'] == number)['label']
            as String;
      }).toList();

      // Debug print the final data
      print("Final product data: ${{
        'name': productNameController.text,
        'description': descriptionController.text,
        'price': priceController.text,
        'discountPrice': discountPriceController.text,
        'basePrice': basePriceController.text,
        'quantity': quantityController.text,
        'category': category,
        'subCategory': subCategory ?? 'Default SubCategory',
        'images': images.map((file) => file.path).toList(),
        'colors': colorHexCodes,
        'size': selectedSizes,
        'offer': 'No Offer',
        'note': noteController.text,
        
      }}");

      // Since we've already checked category != null, we can use the ! operator
      adminServices.addProduct(
        context: context,
        name: productNameController.text,
        description: descriptionController.text,
        price: int.tryParse(priceController.text) ?? 0,
        discountPrice: int.tryParse(discountPriceController.text) ?? 0,
        basePrice: int.tryParse(basePriceController.text) ?? 0,
        quantity: int.tryParse(quantityController.text) ?? -1,
        category: category!, // Add the ! operator here to assert non-null
        subCategory: subCategory ?? 'Default SubCategory',
        images: images.map((file) => file.path).toList(),
        colors: colorHexCodes,
        size: selectedSizes,
        offer: selectedOffer.isNotEmpty ? selectedOffer : 'No Offer',
        note: noteController.text,
      );

      Navigator.pop(context);
    } else {
      String errorMessage = '';
      if (images.isEmpty) {
        errorMessage += 'Please select at least one image. ';
      }
      if (category == null) {
        errorMessage += 'Please select a category. ';
      }
      if (!_addProductFormKey.currentState!.validate()) {
        errorMessage += 'Please fill all required fields correctly. ';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage.trim()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Color hexToColor(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(color: Colors.white),
          ),
          title: const Text(
            'Add Product',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addProductFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                images.isNotEmpty
                    ? CarouselSlider(
                        items: images.map(
                          (i) {
                            return Builder(
                              builder: (BuildContext context) => Image.file(
                                i,
                                fit: BoxFit.cover,
                                height: 200,
                              ),
                            );
                          },
                        ).toList(),
                        options: CarouselOptions(
                          viewportFraction: 1,
                          height: 200,
                        ),
                      )
                    : GestureDetector(
                        onTap: selectImages,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          dashPattern: const [10, 4],
                          strokeCap: StrokeCap.round,
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.folder_open,
                                  size: 40,
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  'Select Product Images',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 30),
                CustomTextField(
                  controller: productNameController,
                  hintText: 'Product Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Product name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: descriptionController,
                  hintText: 'Description',
                  maxLines: 7,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: basePriceController,
                  hintText: 'Base Price',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    PriceInputFormatter(),
                    // Prevent entering negative values
                    FilteringTextInputFormatter.deny(
                      RegExp(r'^0+(?=\d)'), // Prevent leading zeros
                    )
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Base Price is required';
                    }
                    final price = double.tryParse(value);
                    if (price == null) {
                      return 'Please enter a valid Base price';
                    }
                    if (price <= 0) {
                      return 'Base price must be greater than 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: priceController,
                  hintText: 'Selling Price',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    PriceInputFormatter(),
                    FilteringTextInputFormatter.deny(
                      RegExp(r'^0+(?=\d)'), // Prevent leading zeros
                    )
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null; // Discount is optional
                    }
                    final discountPrice = double.tryParse(value);
                    if (discountPrice == null) {
                      return 'Please enter a valid selling price';
                    }
                    if (discountPrice <= 0) {
                      return 'Selling price must be greater than 0';
                    }

                    // Check if discount price is less than original price
                    final originalPrice =
                        double.tryParse(basePriceController.text) ?? 0;
                    if (discountPrice <= originalPrice) {
                      return 'Selling price should be less than original price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: discountPriceController,
                  hintText: 'Offer / Discount Price',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    PriceInputFormatter(),
                    FilteringTextInputFormatter.deny(
                      RegExp(r'^0+(?=\d)'), // Prevent leading zeros
                    )
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null; // Discount is optional
                    }
                    final discountPrice = double.tryParse(value);
                    if (discountPrice == null) {
                      return 'Please enter a valid price';
                    }
                    if (discountPrice <= 0) {
                      return 'Discount price must be greater than 0';
                    }

                    // Check if discount price is less than original price
                    final originalPrice =
                        double.tryParse(priceController.text) ?? 0;
                    if (discountPrice >= originalPrice) {
                      return 'Discount price should be less than original price';
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(3), // Rounded corners
                      ),
                      fillColor: MaterialStateProperty.resolveWith<Color?>(
                        (states) {
                          if (states.contains(MaterialState.selected)) {
                            return Colors.green; // Green when selected
                          }
                          return null; // Default color when unselected
                        },
                      ),
                      value: _trackQuantity,
                      onChanged: (bool? value) {
                        setState(() {
                          _trackQuantity =
                              value ?? false; // Update checkbox state
                        });
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        // Toggle checkbox when text is tapped
                        setState(() {
                          _trackQuantity = !_trackQuantity;
                        });
                      },
                      child: const Text(
                        'Continue selling when out of stock',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                if (!_trackQuantity)
                  CustomTextField(
                    controller: quantityController,
                    hintText: 'Quantity',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      // Prevent leading zeros
                      FilteringTextInputFormatter.deny(RegExp(r'^0+(?=\d)')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Quantity is required';
                      }
                      final quantity = int.tryParse(value);
                      if (quantity == null) {
                        return 'Please enter a valid quantity';
                      }
                      if (quantity <= 0) {
                        return 'Quantity must be greater than 0';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 10),
                CustomDropdownField(
                  hintText: 'Category',
                  value: category,
                  items: categories
                      .map((Category cat) => cat.categoryName)
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      category = newValue;
                      subCategory =
                          null; // Reset subcategory when category changes
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                  isEnabled: true,
                  placeholderText: 'Select Category *',
                ),

                const SizedBox(height: 10),

                // Modified Subcategory Dropdown
                CustomDropdownField(
                  hintText: 'Sub-Category',
                  value: subCategory,
                  items: getSubcategories(),
                  onChanged: (String? newValue) {
                    if (category != null && newValue != null) {
                      // Add null check
                      setState(() {
                        subCategory = newValue;
                      });
                    }
                  },
                  validator: null,
                  isEnabled: category != null,
                  placeholderText: 'Select Sub-Category',
                ),

                const SizedBox(height: 30),
                const Text(
                  'ADDITIONAL INFORMATION',
                  style: TextStyle(
                      fontFamily: 'Regular',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                const Divider(
                  color: Colors.grey,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Offer',
                  style: TextStyle(
                      fontFamily: 'Regular',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 10),
                  child: Container(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: offerTexts.length,
                      itemBuilder: (context, index) {
                        final text = offerTexts[index];
                        final isSelected = selectedOffer == text;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedOffer = text; // Update selected text
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color:
                                  isSelected ? Colors.green : Colors.grey[300],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                text,
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Size:',
                  style: TextStyle(
                      fontFamily: 'Regular',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // Horizontal scrolling
                  child: Row(
                    children: sizes.map((size) {
                      bool isSelected =
                          selectedNumbers.contains(size['number']);
                      return Padding(
                        padding: const EdgeInsets.only(
                            right: 5.0), // Spacing between boxes
                        child: GestureDetector(
                          onTap: () {
                            toggleSelection(
                                size['number']); // Handle selection toggle
                          },
                          child: Container(
                            width: 100,
                            height: 40, // Set the height to 30
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.green
                                      .withOpacity(0.5) // Highlight selected
                                  : Colors.white,
                              border: Border.all(
                                color: Colors.green, // Border color
                                width: 2.0, // Border width
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                '${size['label']}', // Display size and number
                                style: const TextStyle(
                                  fontFamily: 'Regular',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Colors:',
                  style: TextStyle(
                      fontFamily: 'Regular',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Wrap(
                  spacing: 5.0,
                  children: selectedColors.map((hexColor) {
                    return Chip(
                      label: const Text('Color'),
                      backgroundColor: hexToColor(hexColor),
                      onDeleted: () {
                        setState(() {
                          selectedColors.remove(hexColor);
                        });
                      },
                    );
                  }).toList(),
                ),
                ColorPicker(
                  pickerColor: currentColor,
                  onColorChanged: (Color newColor) {
                    setState(() {
                      currentColor = newColor;
                    });
                    addOrRemoveColor(newColor);
                  },
                ),

                const SizedBox(height: 10),
                CustomTextField(
                  controller: noteController,
                  hintText: 'Note (Optional)',
                  maxLines: 7,
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: addProduct, // Action to perform on tap
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green, // Green background
                      borderRadius:
                          BorderRadius.circular(15), // Rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: const Center(
                      child: Text(
                        'Add Product',
                        style: TextStyle(
                          color: Colors.white, // White text color
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PriceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Allow only digits and one decimal point
    if (newValue.text.contains('.')) {
      // Split by decimal point and check decimals
      final parts = newValue.text.split('.');
      // Allow only two decimal places
      if (parts.length == 2 && parts[1].length > 2) {
        return oldValue;
      }
    }

    // Validate the format
    if (!RegExp(r'^\d*\.?\d{0,2}$').hasMatch(newValue.text)) {
      return oldValue;
    }

    return newValue;
  }
}
