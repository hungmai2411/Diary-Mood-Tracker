import 'package:cs214/constants/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DetailImageScreen extends StatelessWidget {
  static const String routeName = '/detail_image_screen';
  const DetailImageScreen({
    super.key,
    required this.image,
  });
  final Uint8List image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            child: Image.memory(
              image,
              fit: BoxFit.cover,
              cacheWidth: 1284,
              cacheHeight: 2778,
            ),
          ),
          Positioned(
            child: SafeArea(
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.close_rounded,
                  color: AppColors.selectedColor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
