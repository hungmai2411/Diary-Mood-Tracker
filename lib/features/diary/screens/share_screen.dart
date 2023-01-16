import 'dart:io';
import 'dart:typed_data';

import 'package:cs214/constants/app_colors.dart';
import 'package:cs214/constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ShareScreen extends StatefulWidget {
  // Các tham số truyền vào để lấy dữ liệu từ widget và chuyển sang hình ảnh.
  final Uint8List bytes1;
  final Uint8List bytes2;
  const ShareScreen({
    Key? key,
    required this.bytes1,
    required this.bytes2,
  }) : super(key: key);

  static const String routeName = '/share_screen';
  @override
  ShareScreenState createState() => ShareScreenState();
}

class ShareScreenState extends State<ShareScreen> {
  // Các tham số truyền vào để lấy dữ liệu từ widget và chuyển sang hình ảnh.
  Uint8List? reportData1;
  Uint8List? reportData2;

  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    reportData1 = widget.bytes1;
    reportData2 = widget.bytes2;
  }

  @override
  void didUpdateWidget(covariant ShareScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    reportData1 = widget.bytes1;
    reportData2 = widget.bytes2;
  }

  shareImage() async {
    final imageFile = await screenshotController.capture();
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/diary.png');
    await image.writeAsBytes(imageFile!);
    await Share.shareXFiles(
      [
        XFile(image.path),
      ],
      subject: 'Diary',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundShareScreen,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Share',
          style: AppStyles.medium.copyWith(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            onPressed: shareImage,
            icon: const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
        ],
        centerTitle: true,
      ),
      body: Screenshot(
        controller: screenshotController,
        child: Container(
          color: AppColors.boxColor,
          margin: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 50,
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.memory(
                reportData1!,
                fit: BoxFit.cover,
                height: 20,
              ),
              const SizedBox(height: 15),
              Image.memory(
                reportData2!,
                fit: BoxFit.cover,
                cacheHeight: 654,
                cacheWidth: 590,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
