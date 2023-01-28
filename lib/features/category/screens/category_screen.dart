import 'package:diary_app/constants/app_colors.dart';
import 'package:diary_app/constants/app_styles.dart';
import 'package:diary_app/features/category/models/category.dart';
import 'package:diary_app/features/category/widgets/category_upload_group.dart';
import 'package:diary_app/providers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  static const String routeName = '/category_screen';

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    List<Category> categories =
        context.watch<CategoryProvider>().categories.cast<Category>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appbarColor,
        elevation: 0.3,
        automaticallyImplyLeading: false,
        title: Text(
          AppLocalizations.of(context)!.category,
          style: AppStyles.medium.copyWith(
            fontSize: 18,
            color: AppColors.textPrimaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: CategoryUploadGroup(categories: categories),
    );
  }
}
