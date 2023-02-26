import 'package:cs214/constants/app_colors.dart';
import 'package:cs214/constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BoxSearch extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback callback;
  final Function(String) onChanged;

  const BoxSearch({
    super.key,
    required this.searchController,
    required this.callback,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: callback,
      controller: searchController,
      enabled: true,
      autocorrect: false,
      decoration: InputDecoration(
        hintText: 'Search',
        hintStyle:
            AppStyles.regular.copyWith(color: AppColors.textPrimaryColor),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            FontAwesomeIcons.magnifyingGlass,
            color: AppColors.textPrimaryColor,
            size: 15,
          ),
        ),
        filled: true,
        fillColor: AppColors.boxColor,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      ),
      style: AppStyles.medium.copyWith(color: AppColors.textPrimaryColor),
      onChanged: (value) {
        onChanged(value);
      },
      onSubmitted: (String submitValue) {},
    );
  }
}
