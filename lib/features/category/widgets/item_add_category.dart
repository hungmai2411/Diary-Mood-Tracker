import 'package:diary_app/constants/app_colors.dart';
import 'package:diary_app/constants/app_styles.dart';
import 'package:diary_app/features/category/screens/create_category_screen.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/category.dart';

class ItemAddCategory extends StatelessWidget {
  final int index;
  final Function(Category) callback;

  const ItemAddCategory({
    super.key,
    required this.index,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, CreateCategoryScreen.routeName);
      },
      child: SizedBox(
        child: DottedBorder(
          dashPattern: const [9, 9],
          color: AppColors.selectedColor,
          borderType: BorderType.RRect,
          radius: const Radius.circular(12),
          padding: const EdgeInsets.all(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.add_to_photos_outlined,
                color: AppColors.primaryColor,
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.createCategory,
                textAlign: TextAlign.center,
                style: AppStyles.medium.copyWith(
                  color: AppColors.textPrimaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
