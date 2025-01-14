import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:farstore/models/category.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

// class CreateCollectionScreen extends StatefulWidget {
//     final Category? initialCategory;
//   static const String routeName = '/create-collection';

//   const CreateCollectionScreen({Key? key, required this.initialCategory}) : super(key: key);

//   @override
//   State<CreateCollectionScreen> createState() => _CreateCollectionScreenState();
// }

// class _CreateCollectionScreenState extends State<CreateCollectionScreen> {
//   final TextEditingController _collectionNameController =
//       TextEditingController();
//   final TextEditingController _subCollectionController =
//       TextEditingController();
//   final List<String> _subCollections = [];
//   File? _selectedImage;
//   final ImagePicker _picker = ImagePicker();
//   final Uuid uuid = const Uuid();
//   final CloudinaryPublic cloudinary = CloudinaryPublic('dybzzlqhv', 'se7irpmg');
//   late TextEditingController _categoryNameController;

//   bool _showSubCollectionSection = false;
//   bool _showSubCollectionInput = false;

//    @override
//   void initState() {
//     super.initState();
//      _collectionNameController.addListener(() {
//       setState(() {
//         _checkAndShowSubCollectionSection();
//       });
//     });
//     _categoryNameController = TextEditingController(
//       text: widget.initialCategory?.categoryName ?? ''
//     );

//     // You can also pre-fill other fields based on the initial category
//   }

//   // Check if collection details are complete
//   bool get _isCollectionComplete {
//     return _collectionNameController.text.trim().isNotEmpty &&
//         _selectedImage != null;
//   }

//   Future<void> _selectImage() async {
//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       setState(() {
//         _selectedImage = File(image.path);
//       });
//       // Check if we can show sub-collection section
//       _checkAndShowSubCollectionSection();
//     }
//   }


//   Future<String> _uploadImageToCloudinary(File imageFile) async {
//     try {
//       CloudinaryResponse res = await cloudinary.uploadFile(
//         CloudinaryFile.fromFile(imageFile.path, folder: 'collections'),
//       );
//       return res.secureUrl;
//     } catch (e) {
//       print('Cloudinary upload error: $e');
//       throw Exception('Failed to upload image to Cloudinary');
//     }
//   }

//   Future<void> _saveToHive() async {
//     try {
//       final box = await Hive.openBox<Category>('categories');
//       final String imageUrl = await _uploadImageToCloudinary(_selectedImage!);

//       final category = Category(
//         id: uuid.v4(),
//         categoryName: _collectionNameController.text.trim(),
//         subcategories: List<String>.from(_subCollections),
//         categoryImage: imageUrl, // Store Cloudinary URL instead of local path
//       );

//       await box.add(category);

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Collection saved successfully!')),
//         );
//         Navigator.pop(context, true);
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error saving collection: ${e.toString()}')),
//         );
//       }
//     }
//   }

//   void _checkAndShowSubCollectionSection() {
//     if (_isCollectionComplete && !_showSubCollectionSection) {
//       setState(() {
//         _showSubCollectionSection = true;
//       });
//     }
//   }

//   void _addSubCollection() {
//     final subCollection = _subCollectionController.text.trim();
//     if (subCollection.isNotEmpty) {
//       setState(() {
//         _subCollections.add(subCollection);
//         _subCollectionController.clear();
//         _showSubCollectionInput = false;
//       });
//     }
//   }

//   void _removeSubCollection(int index) {
//     setState(() {
//       _subCollections.removeAt(index);
//     });
//   }

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   _collectionNameController.addListener(() {
//   //     setState(() {
//   //       _checkAndShowSubCollectionSection();
//   //     });
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: const Text(
//                 'Cancel',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 14,
//                   fontFamily: 'Regular',
//                 ),
//               ),
//             ),
//             const Text(
//               'Create Collection',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: 'Regular',
//               ),
//             ),
//             GestureDetector(
//               onTap: _isCollectionComplete ? () => _saveToHive() : null,
//               child: Text(
//                 'Save',
//                 style: TextStyle(
//                   color: _isCollectionComplete ? Colors.black : Colors.grey,
//                   fontSize: 16,
//                   fontFamily: 'Regular',
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: Container(
//         color: Colors.white,
//         child: Column(
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       TextFormField(
//                         controller: _collectionNameController,
//                         decoration: const InputDecoration(
//                           hintText: 'Collection Name',
//                           contentPadding: EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 12,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),

//                       // Image Picker
//                       GestureDetector(
//                         onTap: _selectImage,
//                         child: DottedBorder(
//                           borderType: BorderType.RRect,
//                           radius: const Radius.circular(12),
//                           dashPattern: const [8, 4],
//                           strokeWidth: 2,
//                           color: Colors.grey,
//                           child: Container(
//                             height: 200,
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                               color: Colors.grey[50],
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: _selectedImage != null
//                                 ? ClipRRect(
//                                     borderRadius: BorderRadius.circular(12),
//                                     child: Image.file(
//                                       _selectedImage!,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   )
//                                 : Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Icon(
//                                         Icons.add_photo_alternate_outlined,
//                                         size: 40,
//                                         color: Colors.grey[400],
//                                       ),
//                                       const SizedBox(height: 8),
//                                       Text(
//                                         'Add Collection Image',
//                                         style: TextStyle(
//                                           color: Colors.grey[400],
//                                           fontSize: 14,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                           ),
//                         ),
//                       ),

//                       // Sub-collections Section
//                       if (_showSubCollectionSection) ...[
//                         const SizedBox(height: 24),
//                         const Text(
//                           'Sub-collections',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey,
//                             fontFamily: 'Regular',
//                           ),
//                         ),
//                         const Divider(color: Colors.grey),
//                         const SizedBox(height: 16),

//                         // Add Sub-collection Button
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               _showSubCollectionInput = true;
//                             });
//                           },
//                           child: const Row(
//                             children: [
//                               Text(
//                                 'Add Sub-collection',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   fontFamily: 'Regular',
//                                 ),
//                               ),
//                               Spacer(),
//                               Icon(
//                                 Icons.add,
//                                 color: Colors.green,
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 16),

//                         // Sub-collection Input Field
//                         if (_showSubCollectionInput)
//                           Column(
//                             children: [
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: TextFormField(
//                                       controller: _subCollectionController,
//                                       decoration: const InputDecoration(
//                                         hintText: 'Sub-collection Name',
//                                         contentPadding:
//                                             EdgeInsets.symmetric(
//                                           horizontal: 16,
//                                           vertical: 12,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 8),
//                                   IconButton(
//                                     icon: const Icon(Icons.check,
//                                         color: Colors.green),
//                                     onPressed: _addSubCollection,
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 16),
//                             ],
//                           ),

//                         // List of added sub-collections
//                         ..._subCollections.asMap().entries.map((entry) {
//                           return Padding(
//                               padding: const EdgeInsets.only(bottom: 8),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                         color:
//                                             Colors.grey[100], 
//                                         borderRadius: BorderRadius.circular(
//                                             15), 
//                                       ),
//                                 child: Padding(
//                                   padding: EdgeInsets.only(left: 10),
//                                   child: Row(
//                                     children: [
//                                        Text(
//                                           entry.value,
//                                           style: const TextStyle(
//                                             fontSize: 16,
//                                             fontFamily: 'Regular',
//                                             color: Colors
//                                                 .black, 
//                                                 fontWeight: FontWeight.bold
//                                           ),
//                                       ),
//                                       const Spacer(),
//                                       IconButton(
//                                         icon: const Icon(
//                                           Icons.delete_outline,
//                                           color: Colors.red,
//                                           size: 20,
//                                         ),
//                                         onPressed: () =>
//                                             _removeSubCollection(entry.key),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ));
//                         }),
//                       ],
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _collectionNameController.dispose();
//     _subCollectionController.dispose();
//     super.dispose();
//   }
// }


class CreateCollectionScreen extends StatefulWidget {
  final Category? initialCategory;
  static const String routeName = '/create-collection';

  const CreateCollectionScreen({Key? key, required this.initialCategory}) : super(key: key);

  @override
  State<CreateCollectionScreen> createState() => _CreateCollectionScreenState();
}

class _CreateCollectionScreenState extends State<CreateCollectionScreen> {
  final TextEditingController _collectionNameController = TextEditingController();
  final TextEditingController _subCollectionController = TextEditingController();
  final List<String> _subCollections = [];
  File? _selectedImage;
  String? _existingImageUrl;
  final ImagePicker _picker = ImagePicker();
  final Uuid uuid = const Uuid();
  final CloudinaryPublic cloudinary = CloudinaryPublic('dybzzlqhv', 'se7irpmg');

  bool _showSubCollectionSection = false;
  bool _showSubCollectionInput = false;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _initializeCategory();
    _collectionNameController.addListener(() {
      setState(() {
        _checkAndShowSubCollectionSection();
      });
    });
  }

   void _checkAndShowSubCollectionSection() {
    if (_collectionNameController.text.trim().isNotEmpty && (_selectedImage != null || _existingImageUrl != null)) {
      setState(() {
        _showSubCollectionSection = true;
      });
    } else {
      setState(() {
        _showSubCollectionSection = false;
        _showSubCollectionInput = false;
      });
    }
  }

  void _addSubCollection() {
    final subCollectionName = _subCollectionController.text.trim();
    if (subCollectionName.isNotEmpty) {
      setState(() {
        _subCollections.add(subCollectionName);
        _subCollectionController.clear();
        _showSubCollectionInput = false;
      });
    }
  }

  void _removeSubCollection(int index) {
    setState(() {
      _subCollections.removeAt(index);
    });
  }

  void _initializeCategory() {
    if (widget.initialCategory != null) {
      _isEditMode = true;
      // Set the collection name
      _collectionNameController.text = widget.initialCategory!.categoryName;
      
      // Set the existing image URL
      _existingImageUrl = widget.initialCategory!.categoryImage;
      
      // Set the subcollections
      setState(() {
        _subCollections.addAll(widget.initialCategory!.subcategories);
        _showSubCollectionSection = true;
      });
    }
  }

  // Check if collection details are complete
  bool get _isCollectionComplete {
    return _collectionNameController.text.trim().isNotEmpty &&
        (_selectedImage != null || _existingImageUrl != null);
  }

  Future<void> _selectImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
      _checkAndShowSubCollectionSection();
    }
  }

  Future<String> _uploadImageToCloudinary(File imageFile) async {
    try {
      CloudinaryResponse res = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(imageFile.path, folder: 'collections'),
      );
      return res.secureUrl;
    } catch (e) {
      print('Cloudinary upload error: $e');
      throw Exception('Failed to upload image to Cloudinary');
    }
  }

  Future<void> _saveToHive() async {
    try {
      final box = await Hive.openBox<Category>('categories');
      String imageUrl = _existingImageUrl ?? '';
      
      if (_selectedImage != null) {
        imageUrl = await _uploadImageToCloudinary(_selectedImage!);
      }

      final category = Category(
        id: widget.initialCategory?.id ?? uuid.v4(),
        categoryName: _collectionNameController.text.trim(),
        subcategories: List<String>.from(_subCollections),
        categoryImage: imageUrl,
      );

      if (_isEditMode && widget.initialCategory != null) {
        // Find and update the existing category
        final index = box.values.toList().indexWhere(
          (cat) => cat.id == widget.initialCategory!.id
        );
        if (index != -1) {
          await box.putAt(index, category);
        }
      } else {
        // Add new category
        await box.add(category);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditMode 
              ? 'Collection updated successfully!' 
              : 'Collection saved successfully!'
            ),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving collection: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Regular',
                ),
              ),
            ),
            Text(
              _isEditMode ? 'Edit Collection' : 'Create Collection',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Regular',
              ),
            ),
            GestureDetector(
              onTap: _isCollectionComplete ? () => _saveToHive() : null,
              child: Text(
                'Save',
                style: TextStyle(
                  color: _isCollectionComplete ? Colors.black : Colors.grey,
                  fontSize: 16,
                  fontFamily: 'Regular',
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _collectionNameController,
                        decoration: const InputDecoration(
                          hintText: 'Collection Name',
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Image Picker
                      GestureDetector(
                        onTap: _selectImage,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(12),
                          dashPattern: const [8, 4],
                          strokeWidth: 2,
                          color: Colors.grey,
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: _selectedImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      _selectedImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : _existingImageUrl != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          _existingImageUrl!,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_photo_alternate_outlined,
                                            size: 40,
                                            color: Colors.grey[400],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Add Collection Image',
                                            style: TextStyle(
                                              color: Colors.grey[400],
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                          ),
                        ),
                      ),

                      // Sub-collections Section
                      if (_showSubCollectionSection || _isEditMode) ...[
                        const SizedBox(height: 24),
                        const Text(
                          'Sub-collections',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontFamily: 'Regular',
                          ),
                        ),
                        const Divider(color: Colors.grey),
                        const SizedBox(height: 16),

                        // Add Sub-collection Button
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _showSubCollectionInput = true;
                            });
                          },
                          child: const Row(
                            children: [
                              Text(
                                'Add Sub-collection',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Regular',
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.add,
                                color: Colors.green,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Sub-collection Input Field
                        if (_showSubCollectionInput)
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _subCollectionController,
                                      decoration: const InputDecoration(
                                        hintText: 'Sub-collection Name',
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.check, color: Colors.green),
                                    onPressed: _addSubCollection,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),

                        // List of added sub-collections
                        ..._subCollections.asMap().entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      entry.value,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Regular',
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: EdgeInsets.all(10),
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
                                        onPressed: () => _removeSubCollection(entry.key),
                                      ),
                                    ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _collectionNameController.dispose();
    _subCollectionController.dispose();
    super.dispose();
  }
}