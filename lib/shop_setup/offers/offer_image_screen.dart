import 'package:carousel_slider/carousel_slider.dart';
import 'package:farstore/models/offerImage.dart';
import 'package:farstore/models/toggle_management.dart';
import 'package:farstore/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class OfferImageScreen extends StatefulWidget {
  const OfferImageScreen({Key? key}) : super(key: key);

  @override
  _OfferImageScreenState createState() => _OfferImageScreenState();
}

class _OfferImageScreenState extends State<OfferImageScreen> {
  bool isToggled = false;
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _urlController = TextEditingController();
  OfferImage? _currentOfferImages;
  final OfferImageService _offerImageService = OfferImageService();

   @override
  void initState() {
    super.initState();
    _initHive();
    _loadStoredImages();
    _initScreen();
  }

  Future<void> _initScreen() async {
    // Initialize both Hive boxes
    await Future.wait([
      _initHive(),
      ToggleManager.init(),
    ]);
    
    // Load the toggle state
    setState(() {
      isToggled = ToggleManager.getToggleState(ToggleType.offerImage);
    });
  }

  Future<void> _initHive() async {
    await _offerImageService.init();
    await _loadStoredImages();
  }

  @override
  void dispose() {
    _urlController.dispose();
    _offerImageService.close(); // Close the box when disposing
    super.dispose();
  }

  Future<void> _loadStoredImages() async {
    final images = await _offerImageService.getOfferImages();
    setState(() {
      _currentOfferImages = images;
    });
  }

  void _toggleVisibility() async {
    final newState = !isToggled;
    // Save the new toggle state
    await ToggleManager.saveToggleState(ToggleType.offerImage, newState);
    setState(() {
      isToggled = newState;
    });
  }

  Future<void> _addImageUrl(String url) async {
    if (url.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    try {
      final success = await _offerImageService.addImage(url);
      if (success) {
        setState(() {
          _urlController.clear();
        });
        await _loadStoredImages();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image URL added successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Maximum 3 images allowed')),
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  Future<void> _pickImages() async {
    try {
      final currentLength = _currentOfferImages?.imageUrls.length ?? 0;
      if (currentLength >= 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Maximum 3 images allowed')),
        );
        return;
      }

      final List<XFile>? pickedFiles = await _picker.pickMultiImage();
      
      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        final remainingSlots = 3 - (_currentOfferImages?.imageUrls.length ?? 0);
        final selectedImages = pickedFiles.take(remainingSlots).toList();

        for (var image in selectedImages) {
          try {
            final cloudinaryUrl = await _offerImageService.uploadToCloudinary(image.path);
            if (cloudinaryUrl != null) {
              await _offerImageService.addImage(cloudinaryUrl);
            }
          } catch (e) {
            print('Error uploading image: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error uploading image: $e')),
            );
          }
        }

        await _loadStoredImages();
      }
    } catch (e) {
      print('Error picking images: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking images: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _removeImage(String imageUrl) async {
    await _offerImageService.removeImage(imageUrl);
    await _loadStoredImages();
  }

  Widget _buildUrlList() {
    if (_currentOfferImages == null || _currentOfferImages!.imageUrls.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          'No URLs added yet',
          style: TextStyle(
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Added URLs:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _currentOfferImages!.imageUrls.length,
          itemBuilder: (context, index) {
            final url = _currentOfferImages!.imageUrls[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      url,
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red, size: 20),
                    onPressed: () => _removeImage(url),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Offer banner',style: TextStyle(color: Colors.black, fontSize: 20),),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.white,
              child: Row(
                children: [
                  const Text(
                    'Offer image',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _toggleVisibility,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 47.0,
                      height: 25.0,
                      padding: const EdgeInsets.only(top:5,right: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: isToggled ? Colors.green : Colors.grey[300],
                      ),
                      child: Stack(
                        children: [
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 200),
                            left: isToggled ? 24.0 : 4.0,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 15.0,
                              height: 15.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isToggled ? Colors.white : Colors.transparent,
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
            ),
            if (isToggled) ...[
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // URL Input Container
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Input Guidelines:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildGuideline('Accept image URLs only (jpg, png, jpeg)'),
                          _buildGuideline('URL must be publicly accessible'),
                          _buildGuideline('Maximum image size: 5MB'),
                          _buildGuideline('Recommended resolution: 1024x1024px'),
                          const SizedBox(height: 16),
                          // TextField(
                          //   controller: _urlController,
                          //   decoration: InputDecoration(
                          //     hintText: 'Image URL',
                          //     filled: true,
                          //     fillColor: Colors.grey[50],
                          //     border: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(8),
                          //       borderSide: BorderSide(
                          //         color: Colors.grey[300]!,
                          //       ),
                          //     ),
                          //     enabledBorder: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(8),
                          //       borderSide: BorderSide(
                          //         color: Colors.grey[300]!,
                          //       ),
                          //     ),
                          //     focusedBorder: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(8),
                          //       borderSide: const BorderSide(
                          //         color: Colors.blue,
                          //       ),
                          //     ),
                          //     suffixIcon: IconButton(
                          //       icon: const Icon(Icons.add_photo_alternate),
                          //       onPressed: () {
                          //         if (_urlController.text.isNotEmpty) {
                          //           _addImageUrl(_urlController.text);
                          //         }
                          //       },
                          //     ),
                          //   ),
                          //   onSubmitted: (value) {
                          //     if (value.isNotEmpty) {
                          //       _addImageUrl(value);
                          //     }
                          //   },
                          // ),

                          CustomTextField(
  controller: _urlController,
  hintText: 'Image URL',
  fillColor: Colors.grey[50],
  suffixIcon: Icons.add_photo_alternate,
  onSuffixIconTap: () {
    if (_urlController.text.isNotEmpty) {
      _addImageUrl(_urlController.text);
    }
  },
  onChanged: (value) {
    // If you want to handle changes
  },
  // To handle form submission
  onTap: () {
    if (_urlController.text.isNotEmpty) {
      _addImageUrl(_urlController.text);
    }
  },
),
                          _buildUrlList(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Image Display Container
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildInstructionRow('Select up to three images'),
                                  const SizedBox(height: 10),
                                  _buildInstructionRow('Displayed on home screen'),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: _pickImages,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.blueAccent,
                                          width: 3,
                                        ),
                                        borderRadius: BorderRadius.circular(35),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(12),
                                        child: Icon(
                                          Icons.image,
                                          size: 30,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'Tap to select',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blueGrey,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(color: Colors.black12),
                          const SizedBox(height: 16),
                          if (_currentOfferImages != null && 
                              _currentOfferImages!.imageUrls.isNotEmpty) ...[
                            Text(
                              'Selected Images (${_currentOfferImages!.imageUrls.length}/3)',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 16),
                            CarouselSlider(
    items: _currentOfferImages!.imageUrls.map((imageUrl) {
      return Builder(
        builder: (BuildContext context) {
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => _removeImage(imageUrl),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          );
        },
      );
    }).toList(),
    options: CarouselOptions(
      viewportFraction: 1,
      height: 200,
    ),
  ),
                          ] else
                            const Center(
                              child: Text(
                                'No images selected',
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGuideline(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 16,
            color: Colors.green,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionRow(String text) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color.fromARGB(255, 90, 228, 44),
          ),
          child: const Padding(
            padding: EdgeInsets.all(3),
            child: Icon(
              Icons.done,
              size: 10,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}