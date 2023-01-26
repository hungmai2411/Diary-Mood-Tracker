import 'package:cs214/constants/app_colors.dart';
import 'package:cs214/constants/app_styles.dart';
import 'package:cs214/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PinSuccessDialog extends StatelessWidget {
  const PinSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.pinSet,
          style: AppStyles.medium.copyWith(color: AppColors.textPrimaryColor),
        ),
        const SizedBox(height: 15),
        AppButton(
          onTap: () => Navigator.pop(context),
          textButton: AppLocalizations.of(context)!.ok,
        ),
      ],
    );
  }
}
