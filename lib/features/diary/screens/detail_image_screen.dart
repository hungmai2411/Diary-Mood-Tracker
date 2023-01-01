import 'package:diary_app/constants/app_colors.dart';
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
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: MemoryImage(
                  image,
                ),
                fit: BoxFit.cover,
              ),
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
