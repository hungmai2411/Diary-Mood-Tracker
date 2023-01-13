import 'package:cs214/constants/app_assets.dart';
import 'package:cs214/constants/app_styles.dart';
import 'package:cs214/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cs214/constants/app_colors.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.theDiaryHasBeenRecorded,
          style: AppStyles.medium.copyWith(
            color: AppColors.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 15),
        Image.asset(
          AppAssets.imgGold,
          fit: BoxFit.cover,
        ),
        Text(
          '100 ${AppLocalizations.of(context)!.coin}',
          style: AppStyles.bold.copyWith(
            color: AppColors.orange,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 20),
        AppButton(
          textButton: AppLocalizations.of(context)!.claim,
          onTap: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
