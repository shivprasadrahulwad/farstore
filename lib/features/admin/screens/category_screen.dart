import 'package:farstore/constants/global_variables.dart';
import 'package:farstore/features/admin/screens/edit_info.dart';
import 'package:farstore/features/admin/services/admin_services.dart';
import 'package:farstore/models/product.dart';
import 'package:farstore/providers/admin_provider.dart';
import 'package:farstore/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';


class CategoryScreen extends StatefulWidget {
  static const String routeName = '/shopScreen';
  final Map<String, dynamic>? category;
  final String shopCode;

  const CategoryScreen({Key? key, required this.category, required this.shopCode}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  int _page = 0;
  String _selectedSortOption = 'Default';
  List<Product>? products;
  bool _isFloatingContainerOpen = false;
  final AdminServices adminServices = AdminServices();
  late String shopCode;

    @override
  void initState() {
    super.initState();
    fetchSubCategoryProducts();
  }

    @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    shopCode = args['shopCode'];
  }



void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Sort by', style: TextStyle(fontFamily: 'SemiBold', fontSize: 20, fontWeight: FontWeight.bold)),
                  const Divider(color: Colors.grey),
                  _buildSortOption(setState, 'Default'),
                  _buildSortOption(setState, 'Price (Low to High)'),
                  _buildSortOption(setState, 'Price (High to Low)'),
                  _buildSortOption(setState, 'Popular'),
                  _buildSortOption(setState, 'Discount (High to Low)'),
                  ElevatedButton(
                    onPressed: () {
                      _sortProducts();
                      Navigator.pop(context);
                    },
                    child: const Text('Apply'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  Widget _buildSortOption(StateSetter setState, String option) {
    return Row(
      children: [
        Radio<String>(
          value: option,
          groupValue: _selectedSortOption,
          onChanged: (value) {
            setState(() {
              _selectedSortOption = value!;
            });
          },
        ),
        Text(option, style: const TextStyle(fontFamily: 'Regular', fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  void _sortProducts() {
    if (products == null) return;

    setState(() {
      switch (_selectedSortOption) {
        case 'Price (Low to High)':
          products!.sort((a, b) => a.discountPrice!.compareTo(b.discountPrice!));
          break;
        case 'Price (High to Low)':
          products!.sort((a, b) => b.discountPrice!.compareTo(a.discountPrice!));
          break;
        case 'Popular':
          break;
        case 'Discount (High to Low)':
          products!.sort((a, b) {
            double discountA = ((a.price - a.discountPrice!) / a.price * 100).abs();
            double discountB = ((b.price - b.discountPrice!) / b.price * 100).abs();
            return discountB.compareTo(discountA);
          });
          break;
        default:
          products!.sort((a, b) => a.id!.compareTo(b.id!));
      }
    });
  }

    Future<void> fetchSubCategoryProducts() async {
    if (widget.category == null || 
        widget.category!['subcategories'] == null ||
        widget.category!['subcategories'].isEmpty) {
      return;
    }

    try {
      products = await adminServices.fetchUserSubCategoryProducts(
        context: context,
        subCategory: widget.category!['subcategories'][_page],
        shopCode: '234567', // Access extracted shopCode
        category: widget.category!['categoryName'],
      );

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error fetching products: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading products: ${e.toString()}')),
        );
      }
    }
  }

  void updatePage(int page) {
    setState(() {
      _page = page;
      fetchSubCategoryProducts();
    });
  }



  Widget _buildProductList() {
  if (products != null) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 10,
            // Remove childAspectRatio to allow automatic height
            mainAxisExtent: MediaQuery.of(context).size.height * 0.4, // Approximate initial height
          ),
          padding: const EdgeInsets.all(0),
          itemCount: products!.length,
          itemBuilder: (context, index) {
            return _buildProductCard(products![index]);
          },
        );
      },
    );
  } else {
    return const Center(child: CircularProgressIndicator());
  }
}

Widget _buildProductCard(Product product) {
  final productInfo = context.watch<AdminProvider>().admin.productsInfo;
  int discount = ((product.price - product.discountPrice!) / product.price * 100)
      .abs()
      .toInt();

  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisSize: MainAxisSize.min, // Important: allows column to wrap content
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image container with fixed aspect ratio
            AspectRatio(
              aspectRatio: 1, // Square image
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: InkWell(
                      onTap: () {},
                      child: Image.network(
                        product.images.isNotEmpty ? product.images[0] : '',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Discount tag
                  Positioned(
                    left: 5,
                    top: 0,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.network(
                          'https://res.cloudinary.com/dybzzlqhv/image/upload/v1727670900/fmvqjdmtzq5chmeqsyhb.png',
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${discount}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const Text(
                              'OFF',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 3),
                          ],
                        )
                      ],
                    ),
                  ),
                  // Edit button
                  Positioned(
                    right: 5,
                    top: 2,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditProductScreen(
                              product: product,
                              onProductUpdated: (Product updatedProduct) {
                                setState(() {
                                  int index = products!.indexWhere(
                                      (p) => p.id == updatedProduct.id);
                                  if (index != -1) {
                                    products![index] = updatedProduct;
                                  }
                                });
                              },
                            ),
                          ),
                        );
                      },
                      child: const Icon(Icons.edit_location_alt),
                    ),
                  ),
                ],
              ),
            ),
            // Product details with flexible height
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '10% off above ₹149',
                      style: TextStyle(
                        fontSize: 12,
                        color: GlobalVariables.blueTextColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SemiBold',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Text(
                      '- - - - - - - - - - -',
                      style: TextStyle(
                        fontSize: 12,
                        color: GlobalVariables.blueTextColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Regular',
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      product.name ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SemiBold',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '₹${(product.discountPrice?.toInt()).toString()}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SemiBold',
                              ),
                            ),
                            Stack(
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'MRP ',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontFamily: 'Regular',
                                        color: GlobalVariables.greyTextColor,
                                      ),
                                    ),
                                    Text(
                                      '₹${product.price?.toInt()}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Regular',
                                        color: GlobalVariables.greyTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const Positioned(
                                  left: 30,
                                  right: 0,
                                  bottom: 0,
                                  child: Divider(
                                    color: GlobalVariables.greyTextColor,
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        DeleteProduct(
                          productId: product.id!,
                          onDelete: (productId) {
                            AdminServices().deleteProductFromProductInfo(
                              context: context,
                              productId: productId,
                              onSuccess: () {
                                context
                                    .read<AdminProvider>()
                                    .removeProductFromInfo(productId);
                                setState(() {
                                  products!.removeWhere((p) => p.id == productId);
                                });
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final carts = context.watch<AdminProvider>().admin.productsInfo;
    final adminProvider = context.watch<AdminProvider?>();
    final productsInfo = adminProvider?.admin.productsInfo;
    if (productsInfo != null && productsInfo.length >= 1 && !_isFloatingContainerOpen) {
      _isFloatingContainerOpen = true;
    }

    if (carts.length >= 1 && !_isFloatingContainerOpen) {
      _isFloatingContainerOpen = true;
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(),
          ),
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
                color: Color.fromARGB(255, 0, 0, 0),
                size: 25,
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(
              top: 30,
            ),
            child: Text(
              widget.category?['categoryName'] ?? 'No Title',
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Regular',
                  color: Colors.black),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                // Handle search action
              },
              icon: const Padding(
                padding: EdgeInsets.only(top: 20, right: 10),
                child: Icon(
                  Icons.search_rounded,
                  color: Color.fromARGB(255, 0, 0, 0),
                  size: 25,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50, // Set a fixed height for the scrollable row
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            Color pickerColor = Colors.blue; // Initial color

                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // Corner radius of 20
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    16), // Padding around the content
                                child: Column(
                                  mainAxisSize: MainAxisSize
                                      .min, // Wraps the content height
                                  children: [
                                    const Text(
                                      'Pick a color',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 16),
                                    BlockPicker(
                                      pickerColor: pickerColor,
                                      onColorChanged: (Color color) {
                                        // Do something with the selected color
                                        pickerColor = color;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          'Close',
                                          style: TextStyle(
                                            color: Colors
                                                .black, // Text color set to black
                                            fontSize: 16, // Font size set to 16
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        height: 30,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(3),
                          child: Row(
                            children: [
                              Icon(Icons.sort, size: 15),
                              SizedBox(width: 5),
                              Text(
                                'Filters',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                ),
                              ),
                              Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Sort Container
                    GestureDetector(
                      onTap: () {
                        _showBottomSheet(context);
                      },
                      child: Container(
                        height: 30,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(3),
                          child: Row(
                            children: [
                              Icon(Icons.sort, size: 15),
                              SizedBox(width: 5),
                              Text(
                                'Sort',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                ),
                              ),
                              Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Sub-title Row, which is scrollable
                    if (widget.category?['subcategories'] != null)
                    Row(
                      children: List.generate(
                        widget.category?['subcategories'].length ?? 0,
                        (index) => GestureDetector(
                          onTap: () => updatePage(index),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 3, vertical: 10),
                            decoration: BoxDecoration(
                              color: _page == index
                                  ? const Color.fromARGB(255, 243, 253, 244)
                                  : const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color:
                                    _page == index ? Colors.green : Colors.grey,
                              ),
                            ),
                            child: Text(
                              widget.category?['subcategories'][index] ??
                                  'No Sub-Title',
                              style: TextStyle(
                                color: _page == index
                                    ? const Color.fromARGB(255, 0, 0, 0)
                                    : Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: _buildProductList(), // List of products
            ),
          ],
        ),
      ),
    );
  }
}
