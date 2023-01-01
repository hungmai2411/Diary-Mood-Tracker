import 'package:diary_app/constants/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ItemImage extends StatelessWidget {
  final int index;
  final Uint8List image;
  final Function(int) callback;

  const ItemImage({
    super.key,
    required this.index,
    required this.image,
    required this.callback,
  });

  removeImage() {
    callback(index);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.memory(
            image,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          right: 3,
          top: 3,
          child: GestureDetector(
            onTap: removeImage,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.close,
                  color: AppColors.primaryColor,
                  size: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
