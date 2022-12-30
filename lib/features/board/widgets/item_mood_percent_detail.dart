import 'package:diary_app/constants/app_colors.dart';
import 'package:diary_app/constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ItemMoodPercentDetail extends StatelessWidget {
  final String imgMood;
  final int percent;

  const ItemMoodPercentDetail({
    super.key,
    required this.imgMood,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imgMood),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          '${percent.round().toString()}%',
          style: AppStyles.regular.copyWith(
            color: AppColors.textPrimaryColor,
          ),
        ),
      ],
    );
  }
}
