import 'package:diary_app/constants/app_colors.dart';
import 'package:diary_app/constants/app_styles.dart';
import 'package:diary_app/features/category/models/category.dart';
import 'package:diary_app/providers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeleteCategoryDialog extends StatelessWidget {
  final Category category;

  const DeleteCategoryDialog({
    super.key,
    required this.category,
  });

  void deleteDiary(BuildContext context) {
    context.read<CategoryProvider>().deleteCategory(category);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      backgroundColor: AppColors.boxColor,
      title: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.deleteCategory,
              style:
                  AppStyles.medium.copyWith(color: AppColors.textPrimaryColor),
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.undone,
              style: AppStyles.medium.copyWith(
                color: AppColors.deleteColor,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => deleteDiary(context),
                  child: Text(
                    AppLocalizations.of(context)!.delete,
                    style: AppStyles.regular.copyWith(
                      fontSize: 16,
                      color: AppColors.deleteColor,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.selectedColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.cancel,
                      style: AppStyles.regular.copyWith(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
