import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:barcode_widget/barcode_widget.dart';
import 'package:clipboard/clipboard.dart';
import 'package:farstore/constants/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class QRCreateScreen extends StatefulWidget {
  static const String routeName = '/create';

  @override
  _QRCreateScreenState createState() => _QRCreateScreenState();
}

class _QRCreateScreenState extends State<QRCreateScreen> {
  final GlobalKey _globalKey = GlobalKey();
  String message = 'Scan and shop with ShopEz';

  shareImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    Share.shareXFiles([image], text: message);
  }

  Future<void> _downloadQrCode(BuildContext context) async {
    // Retrieve the boundary of the QR code widget
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    // Capture the image of the QR code
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    // Save image to device
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/qr_code.png';
    await File(imagePath).writeAsBytes(pngBytes);

    // Save to gallery
    final response = await ImageGallerySaver.saveFile(imagePath);
    print("QR Code saved to gallery: $response");

    // Show SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('QR Code downloaded successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'QR Code',
            style: TextStyle(
              fontFamily: 'Regular',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: GlobalVariables.greenColor,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.download,
                color: Colors.black,
              ),
              onPressed: () {
                _downloadQrCode(context);
              },
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: GlobalVariables.blueBackground, // Yellow background color
                  borderRadius:
                      BorderRadius.circular(20), // Border radius of 20
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(
                                20), // Border radius for large container
                          ),
                          child: const Center(
                            child: Text(
                              'S',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text('Shivprasad Rahulwad',
                            style: TextStyle(
                                fontFamily: 'SemiBold',
                                fontWeight: FontWeight.bold,
                                fontSize: 16))
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    // Center(
                    //   child: BarcodeWidget(
                    //     barcode: Barcode.qrCode(),
                    //     color: Colors.black,
                    //     data: '123456',
                    //     width: 200,
                    //     height: 200,
                    //   ),
                    // ),

                    RepaintBoundary(
                      key: _globalKey,
                      child: Center(
                        child: BarcodeWidget(
                          barcode: Barcode.qrCode(),
                          color: Colors.black,
                          data: '123456',
                          width: 200,
                          height: 200,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    const Text(
                      'Scan this code to shop with us',
                      style: TextStyle(
                          fontFamily: 'Regular',
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Shop ID: 123456',
                      style: TextStyle(
                          fontFamily: 'SemiBold',
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  FlutterClipboard.copy('123456');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Copied successfully!'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                                child: const Icon(Icons.copy,
                                    size: 20, color: Colors.blue)),
                            const SizedBox(
                                width: 8), // Space between icon and text
                            const Text(
                              'Copy Shop ID',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Regular',
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: GlobalVariables.blueTextColor,
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  shareImage();
                                },
                                child: const Icon(Icons.share,
                                    size: 20, color: Colors.white)),
                            const SizedBox(
                                width: 8), // Space between icon and text
                            const Text(
                              'Share QR code',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Regular',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Center(
                    child: Text(
                      '-- ShopEz --',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'SemiBold',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
