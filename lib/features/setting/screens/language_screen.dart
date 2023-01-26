import 'package:cs214/constants/app_assets.dart';
import 'package:cs214/constants/app_colors.dart';
import 'package:cs214/constants/app_styles.dart';
import 'package:cs214/features/setting/models/language.dart';
import 'package:cs214/features/setting/models/setting.dart';
import 'package:cs214/providers/setting_provider.dart';
import 'package:cs214/widgets/box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});
  static const String routeName = '/language_screen';

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final List languages = [
    Language(AppAssets.iconEnglish, 'English'),
    Language(AppAssets.iconVietnamese, 'Tiếng Việt'),
  ];

  chooseLanguage(Language language) {
    final settingProvider = context.read<SettingProvider>();
    Setting setting = settingProvider.setting;
    setting = setting.copyWith(language: language.language);
    settingProvider.setSetting(setting);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = context.read<SettingProvider>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.textPrimaryColor,
            size: 21,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.appbarColor,
        elevation: 0.3,
        title: Text(
          AppLocalizations.of(context)!.language,
          style: AppStyles.regular.copyWith(
            fontSize: 18,
            color: AppColors.textPrimaryColor,
          ),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          Language language = languages[index];

          return GestureDetector(
            onTap: () => chooseLanguage(language),
            child: Box(
              margin: const EdgeInsets.only(
                top: 10.0,
                left: 20,
                right: 20,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              child: Row(
                children: [
                  Image.asset(
                    language.img,
                    fit: BoxFit.cover,
                    width: 40,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    language.language,
                    style: AppStyles.medium.copyWith(
                      fontSize: 15,
                      color: AppColors.textPrimaryColor,
                    ),
                  ),
                  const Spacer(),
                  settingProvider.setting.language == language.language
                      ? Icon(
                          Icons.check,
                          color: AppColors.selectedColor,
                        )
                      : const SizedBox()
                ],
              ),
            ),
          );
        },
        itemCount: languages.length,
      ),
    );
  }
}
