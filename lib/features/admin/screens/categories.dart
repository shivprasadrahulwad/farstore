import 'dart:math';
import 'package:farstore/features/admin/screens/category_screen.dart';
import 'package:farstore/models/category.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


class Categories extends StatefulWidget {
  final String shopCode;

  const Categories({Key? key, required this.shopCode}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> with AutomaticKeepAliveClientMixin {
  List<Category> _categories = [];
  bool _isLoading = true;
  String? _error;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadCategoriesFromHive();
  }

  Future<void> _loadCategoriesFromHive() async {
    try {
      // Open the categories box
      final box = await Hive.openBox<Category>('categories');

      // Listen for changes in the box
      box.listenable().addListener(_onHiveBoxChanged);

      // Check if the box is empty
      if (box.isEmpty) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _error = 'No categories found';
          });
        }
        return;
      }

      // Retrieve all categories from the box
      final loadedCategories = box.values.toList();

      // Update state if mounted
      if (mounted) {
        setState(() {
          _categories = loadedCategories;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading categories: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Failed to load categories';
        });
      }
    }
  }

  void _onHiveBoxChanged() {
    // This method will be called whenever the Hive box changes
    if (mounted) {
      setState(() {
        _categories = Hive.box<Category>('categories').values.toList();
      });
    }
  }

  void _navigateToCategoryPage(BuildContext context, Category category) {
    if (category == null) return;

    try {
      Navigator.pushNamed(
        context,
        CategoryScreen.routeName,
        arguments: {
          'category': {
            'categoryName': category.categoryName ?? '',
            'categoryImage': category.categoryImage ?? '',
            'subcategories': category.subcategories,
            '_id': category.id ?? '',
          },
          'shopCode': widget.shopCode,
        }
      );
    } catch (e) {
      print('Navigation error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to open category: ${category.categoryName}'))
      );
    }
  }

  @override
  void dispose() {
    // Remove the listener when the widget is disposed
    Hive.box<Category>('categories').listenable().removeListener(_onHiveBoxChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Show loading indicator while fetching categories
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Show error message if any
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: _loadCategoriesFromHive,
              child: const Text('Retry'),
            )
          ],
        ),
      );
    }

    // If no categories, show a message
    if (_categories.isEmpty) {
      return const Center(child: Text('No categories available'));
    }

    final List<Category> categories = _categories;
    final List<List<Widget>> categoryRows = [];
    final chunkSize = 3;

    // Calculate how many complete rows we need
    final numberOfRows = (categories.length / chunkSize).ceil();

    for (var rowIndex = 0; rowIndex < numberOfRows; rowIndex++) {
      final startIndex = rowIndex * chunkSize;
      final endIndex = min(startIndex + chunkSize, categories.length);
      final List<Widget> rowChildren = [];

      for (var i = startIndex; i < endIndex; i++) {
        final category = categories[i];
        rowChildren.add(
          Expanded(
            child: GestureDetector(
              onTap: () => _navigateToCategoryPage(context, category),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: category.categoryImage != null
                        ? Image.network(
                            category.categoryImage!,
                            fit: BoxFit.cover,
                            height: 40,
                            width: 40,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.error),
                              );
                            },
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.image_not_supported),
                          )
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 80,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      category.categoryName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Medium'
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Add spacing between items
        if (i < endIndex - 1) {
          rowChildren.add(const SizedBox(width: 10));
        }
      }

      // If the row is not complete, add empty expanded widgets to maintain spacing
      while (rowChildren.length < (chunkSize * 2 - 1)) {
        rowChildren.add(Expanded(child: Container()));
        if (rowChildren.length < (chunkSize * 2 - 1)) {
          rowChildren.add(const SizedBox(width: 10));
        }
      }

      categoryRows.add(rowChildren);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: categoryRows.map((rowChildren) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: rowChildren,
            ),
          );
        }).toList(),
      ),
    );
  }
}