import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:farstore/constants/global_variables.dart';
import 'package:farstore/models/category.dart';
import 'package:farstore/providers/user_provider.dart';
import 'package:farstore/shop_setup/create_collection_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io'; // For File

class CategoriesSetupScreen extends StatefulWidget {
  static const String routeName = '/setup-category';
  const CategoriesSetupScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesSetupScreen> createState() => _CategoriesSetupScreenState();
}

class _CategoriesSetupScreenState extends State<CategoriesSetupScreen> {
  Map<String, List<String>> _categories = {};
  Map<String, File?> _categoryImages = {};
  List<Category> categories = [];
  Set<int> expandedIndices = {};
  final cloudinary = CloudinaryPublic('dybzzlqhv', 'se7irpmg');
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _loadCategoriesFromHive();
      _initializeCategories();
    });
  }

  Future<String?> uploadLocalImageToCloudinary(
      String localPath, String categoryName) async {
    try {
      final file = File(localPath);
      if (await file.exists()) {
        setState(() {
          isLoading = true;
        });

        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(
            file.path,
            folder: 'categories',
          ),
        );

        setState(() {
          isLoading = false;
        });

        return res.secureUrl;
      }
      return null;
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error uploading to Cloudinary: $e');
      throw Exception('Failed to upload image to Cloudinary: $e');
    }
  }

  Future<void> _initializeCategories() async {
    try {
      // Open the Hive box for categories
      final box = await Hive.openBox<Category>('categories');

      // Load existing categories from Hive into the state
      setState(() {
        categories = box.values.toList();
      });

      // Print loaded categories for debugging
      for (var category in categories) {
        print(
            'Loaded category: ${category.categoryName} with image: ${category.categoryImage}');
      }

      if (categories.isEmpty) {
        // If no categories are available, show a message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No categories available in Hive storage.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      // Handle errors and show a message if something goes wrong
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading categories: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      print('Error initializing categories: $e');
    }
  }

  Future<void> _pickAndUploadImage(Category category, int index) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      try {
        final imageUrl = await uploadLocalImageToCloudinary(
            image.path, category.categoryName);

        if (imageUrl != null) {
          final box = await Hive.openBox<Category>('categories');

          final updatedCategory = Category(
            id: category.id,
            categoryName: category.categoryName,
            subcategories: category.subcategories,
            categoryImage: imageUrl, // Store the Cloudinary URL
          );

          await box.putAt(index, updatedCategory);

          setState(() {
            categories[index] = updatedCategory;
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Image uploaded to cloud successfully'),
                backgroundColor: Colors.green,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to upload image: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _loadCategoriesFromHive() async {
    final box = await Hive.openBox<Category>('categories');
    setState(() {
      categories = box.values.toList();
    });
  }

  Future<void> _deleteCategory(int index) async {
    final box = await Hive.openBox<Category>('categories');

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text('Delete Category'),
          content: Text(
              'Are you sure you want to delete "${categories[index].categoryName}"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirm ?? false) {
      await box.deleteAt(index);

      setState(() {
        categories.removeAt(index);
        if (expandedIndices.contains(index)) {
          expandedIndices.remove(index);
        }
        final newExpandedIndices = Set<int>();
        for (final expandedIndex in expandedIndices) {
          if (expandedIndex > index) {
            newExpandedIndices.add(expandedIndex - 1);
          } else {
            newExpandedIndices.add(expandedIndex);
          }
        }
        expandedIndices = newExpandedIndices;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Category deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void toggleExpanded(int index) {
    setState(() {
      if (expandedIndices.contains(index)) {
        expandedIndices.remove(index);
      } else {
        expandedIndices.add(index);
      }
    });
  }

  List<Map<String, dynamic>> formatCategoriesForServer() {
    return _categories.entries.map((entry) {
      return {
        "categoryName": entry.key,
        "subcategories": entry.value,
        "categoryImage": _categoryImages[entry.key]?.path ?? ''
      };
    }).toList();
  }

  void _sendDataBack() {
    final formattedCategories = formatCategoriesForServer();
    Navigator.pop(context, formattedCategories);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    if (user == null) {
      return const Center(child: Text("User not found"));
    }

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(
              120.0), // Adjust the height to fit the search box
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Collections',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Regular',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateCollectionScreen(initialCategory: null,),
                      ),
                    ).then((_) => _loadCategoriesFromHive());
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: GlobalVariables.greenColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            flexibleSpace: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      // navigateToSearchScreen();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.arrow_downward, color: Colors.black),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.black38, width: 1),
                            ),
                            child: const Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Search name',
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
                        const SizedBox(width: 5),
                        const Icon(Icons.filter_list, color: Colors.black),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                // Categories List
                if (categories.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final isExpanded = expandedIndices.contains(index);

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateCollectionScreen(
                                  initialCategory: category,
                                ),
                              ),
                            ).then((_) => _loadCategoriesFromHive());
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      if (category.categoryImage != null)
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.network(
                                            category.categoryImage!,
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (BuildContext context,
                                                Widget child,
                                                ImageChunkEvent?
                                                    loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              } else {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            (loadingProgress
                                                                .expectedTotalBytes!)
                                                        : null,
                                                  ),
                                                );
                                              }
                                            },
                                            errorBuilder: (BuildContext context,
                                                Object error,
                                                StackTrace? stackTrace) {
                                              return const Center(
                                                  child: Icon(Icons.error));
                                            },
                                          ),
                                        ),
                                      if (category.categoryImage == null)
                                        Icon(
                                          Icons.image,
                                          size: 40,
                                        ),
                        
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          category.categoryName,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      // Add delete button
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: const Text(
                                          'Manual',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                        
                                      Padding(
                                      padding: EdgeInsets.all(0),
                                      child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade100,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      padding: const EdgeInsets.all(0),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                        onPressed: () => _deleteCategory(index),
                                      ),
                                    ),
                                    ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ));
  }
}
