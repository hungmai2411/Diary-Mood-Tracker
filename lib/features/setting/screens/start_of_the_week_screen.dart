import 'package:cs214/constants/app_colors.dart';
import 'package:cs214/constants/app_styles.dart';
import 'package:cs214/extensions/string_ext.dart';
import 'package:cs214/features/setting/models/setting.dart';
import 'package:cs214/providers/setting_provider.dart';
import 'package:cs214/widgets/box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StartOfTheWeekScreen extends StatefulWidget {
  const StartOfTheWeekScreen({super.key});
  static const String routeName = '/start_of_the_week_screen';

  @override
  State<StartOfTheWeekScreen> createState() => _StartOfTheWeekScreenState();
}

class _StartOfTheWeekScreenState extends State<StartOfTheWeekScreen> {
  List days = [];

  @override
  void initState() {
    super.initState();
  }

  void setDays() {
    days = [
      AppLocalizations.of(context)!.monday,
      AppLocalizations.of(context)!.tuesday,
      AppLocalizations.of(context)!.wednesday,
      AppLocalizations.of(context)!.thursday,
      AppLocalizations.of(context)!.friday,
      AppLocalizations.of(context)!.saturday,
      AppLocalizations.of(context)!.sunday,
    ];
  }

  chooseStartDayOfTheWeek(String day) {
    if (day.checkIsVietNam) {
      day = day.convertEnglish;
    }
    final settingProvider = context.read<SettingProvider>();
    Setting setting = settingProvider.setting;
    setting = setting.copyWith(startingDayOfWeek: day);
    settingProvider.setSetting(setting);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = context.read<SettingProvider>();
    Setting setting = settingProvider.setting;
    setDays();

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
        backgroundColor: AppColors.appbarColor,
        elevation: 0.3,
        title: Text(
          AppLocalizations.of(context)!.startOfTheWeek,
          style: AppStyles.regular.copyWith(
            fontSize: 18,
            color: AppColors.textPrimaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          String day = days[index];

          return GestureDetector(
            onTap: () => chooseStartDayOfTheWeek(day),
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
                  Text(
                    day,
                    style: AppStyles.medium.copyWith(
                      fontSize: 15,
                      color: AppColors.textPrimaryColor,
                    ),
                  ),
                  const Spacer(),
                  (setting.language == 'Tiếng Việt' &&
                                  !setting.startingDayOfWeek!.checkIsVietNam
                              ? setting.startingDayOfWeek!.convertVietNam
                              : setting.startingDayOfWeek!.checkIsVietNam
                                  ? setting.startingDayOfWeek!.convertEnglish
                                  : setting.startingDayOfWeek!) ==
                          day
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
        itemCount: days.length,
      ),
    );
  }
}
