import 'package:diary_app/constants/app_colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ItemAddImage extends StatelessWidget {
  final int index;
  final Function(List<Uint8List>) callback;

  const ItemAddImage({
    super.key,
    required this.index,
    required this.callback,
  });

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    List<XFile>? files = await picker.pickMultiImage();
    List<Uint8List> images = [];
    for (var file in files) {
      Uint8List image = await file.readAsBytes();
      images.add(image);
    }
    callback(images);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: pickImage,
      child: SizedBox(
        width: 80,
        height: 80,
        child: DottedBorder(
          dashPattern: const [8, 5],
          color: AppColors.selectedColor,
          borderType: BorderType.RRect,
          radius: const Radius.circular(12),
          padding: const EdgeInsets.all(0),
          child: Center(
            child: Icon(
              Icons.camera_alt,
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
