import 'package:diary_app/constants/app_colors.dart';
import 'package:diary_app/constants/app_styles.dart';
import 'package:diary_app/features/board/widgets/item_mood_percent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmptyMoodBar extends StatelessWidget {
  const EmptyMoodBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.boxColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context)!.moodBar,
            style: AppStyles.medium.copyWith(
              color: AppColors.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Row(
              children: [
                // Mood 1
                ItemMoodPercent(
                  flex: 4,
                  color: AppColors.moodBarEmptyPrimary,
                ),
                // Mood 2
                ItemMoodPercent(
                  flex: 1,
                  color: AppColors.moodBarEmptySecondary,
                ),
                // Mood 3
                ItemMoodPercent(
                  flex: 3,
                  color: AppColors.moodBarEmptyPrimary,
                ),
                // Mood 4
                ItemMoodPercent(
                  flex: 6,
                  color: AppColors.moodBarEmptySecondary,
                ),
                // Mood 5
                ItemMoodPercent(
                  flex: 2,
                  color: AppColors.moodBarEmptyPrimary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              5,
              (index) => Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.moodBarEmptyPrimary,
                  shape: BoxShape.circle,
                ),
              ),
            ).toList(),
          ),
        ],
      ),
    );
  }
}
