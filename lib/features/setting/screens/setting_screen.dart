import 'package:cs214/constants/app_colors.dart';
import 'package:cs214/constants/app_styles.dart';
import 'package:cs214/extensions/string_ext.dart';
import 'package:cs214/features/setting/models/setting.dart';
import 'package:cs214/features/setting/screens/language_screen.dart';
import 'package:cs214/features/setting/screens/passcode_screen.dart';
import 'package:cs214/features/setting/screens/select_theme_screen.dart';
import 'package:cs214/features/setting/screens/start_of_the_week_screen.dart';
import 'package:cs214/providers/setting_provider.dart';
import 'package:cs214/services/notification_services.dart';
import 'package:cs214/widgets/box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});
  static const String routeName = '/setting_screen';
  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool hasPasscode = false;
  final ScrollController settingController = ScrollController();

  TimeOfDay reminderTime = const TimeOfDay(
    hour: 20,
    minute: 00,
  );

  Theme _buildThemeReminderTime(Widget child) {
    return Theme(
      data: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          surface: AppColors.boxColor,
          // change the border color
          primary: AppColors.selectedColor,
          // change the text color
          onSurface: AppColors.textPrimaryColor,
        ),
        // button colors
        buttonTheme: ButtonThemeData(
          colorScheme: ColorScheme.light(
            primary: Colors.green,
          ),
        ),
      ),
      child: child,
    );
  }

  chooseReminderTime(BuildContext context, String locale) async {
    final settingProvider = context.read<SettingProvider>();
    final TimeOfDay? value = await showTimePicker(
      context: context,
      initialTime: reminderTime,
      builder: (BuildContext context, Widget? child) {
        if (MediaQuery.of(context).alwaysUse24HourFormat) {
          return _buildThemeReminderTime(child!);
        } else {
          return Localizations.override(
            context: context,
            locale: Locale(locale),
            child: _buildThemeReminderTime(child!),
          );
        }
      },
    );

    if (value != null) {
      Setting setting = settingProvider.setting;
      setting = setting.copyWith(
        reminderHour: value.hour,
        reminderMinute: value.minute,
      );
      settingProvider.setSetting(setting);
      DateTime now = DateTime.now();
      await NotificationsServices.init(initScheduled: true);
      await NotificationsServices.showScheduledNotification(
        scheduledDate: DateTime(
          now.year,
          now.month,
          now.day,
        ),
        minute: value.minute,
        hour: value.hour,
        payload: 'hihi',
        title: 'Diary Application',
        body: 'Don\'t forget to check in your mood today.\nHave a good night!',
      );
    }
  }

  navigateToStartOfTheWeekScreen() {
    Navigator.pushNamed(
      context,
      StartOfTheWeekScreen.routeName,
    );
  }

  navigateToSelectThemeScreen() {
    Navigator.pushNamed(
      context,
      SelectThemeScreen.routeName,
    );
  }

  navigateToLanguageScreen() {
    Navigator.pushNamed(
      context,
      LanguageScreen.routeName,
    );
  }

  navigateToPasscodeScreen() {
    Navigator.pushNamed(
      context,
      PasscodeScreen.routeName,
    );
  }

  // backup() async {
  //   GoogleDrive googleDrive = GoogleDrive();
  //   //await googleDrive.uploadFileToGoogleDrive(file);
  // }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    Setting setting = settingProvider.setting;
    String locale = setting.language == 'English' ? 'en' : 'vi';
    print(setting.background);
    hasPasscode = setting.hasPasscode;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appbarColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          AppLocalizations.of(context)!.settingTab,
          style: AppStyles.medium.copyWith(
            fontSize: 18,
            color: AppColors.textPrimaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          controller: settingController,
          children: [
            const SizedBox(height: 10),
            // general text
            Text(
              AppLocalizations.of(context)!.general,
              style: AppStyles.medium.copyWith(
                color: AppColors.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 10),
            // passcode
            GestureDetector(
              onTap: navigateToPasscodeScreen,
              child: Box(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 20,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      color: AppColors.textSecondColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.passcode,
                      style: AppStyles.medium.copyWith(
                        color: AppColors.textPrimaryColor,
                      ),
                    ),
                    const Spacer(),
                    CupertinoSwitch(
                      // This bool value toggles the switch.
                      value: hasPasscode,
                      thumbColor: hasPasscode
                          ? AppColors.selectedColor
                          : AppColors.thumUnSelectedColor,
                      trackColor: AppColors.trackUnSelectedColor,
                      activeColor: AppColors.trackSelectedColor,
                      onChanged: (bool? value) {
                        print('value: $value');
                        if (!value!) {
                          setting = setting.copyWith(
                            hasPasscode: value,
                            passcode: '',
                          );
                          settingProvider.setSetting(setting);
                        } else {
                          if (setting.passcode == null ||
                              setting.passcode!.isEmpty) {
                            navigateToPasscodeScreen();
                          } else {
                            setting = setting.copyWith(hasPasscode: value);
                            settingProvider.setSetting(setting);
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            // backup
            GestureDetector(
              onTap: () {},
              child: Box(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 20,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.backup_outlined,
                      color: AppColors.textSecondColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.backUp,
                      style: AppStyles.medium.copyWith(
                        color: AppColors.textPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            // remider time
            GestureDetector(
              onTap: () => chooseReminderTime(context, locale),
              child: Box(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 20,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none_sharp,
                      color: AppColors.textSecondColor,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.reminderTime,
                          style: AppStyles.medium.copyWith(
                            color: AppColors.textPrimaryColor,
                          ),
                        ),
                        Text(
                          '${setting.reminderHour}:${setting.reminderMinute}',
                          style: AppStyles.regular.copyWith(
                            color: AppColors.selectedColor,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    CupertinoSwitch(
                      // This bool value toggles the switch.
                      value: setting.hasReminderTime,
                      thumbColor: setting.hasReminderTime
                          ? AppColors.selectedColor
                          : AppColors.thumUnSelectedColor,
                      trackColor: AppColors.trackUnSelectedColor,
                      activeColor: AppColors.trackSelectedColor,
                      onChanged: (bool? value) {
                        setting = setting.copyWith(hasReminderTime: value);
                        settingProvider.setSetting(setting);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            // start of the week
            GestureDetector(
              onTap: navigateToStartOfTheWeekScreen,
              child: Box(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 20,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      color: AppColors.textSecondColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.startOfTheWeek,
                      style: AppStyles.medium.copyWith(
                        color: AppColors.textPrimaryColor,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      (setting.language == 'Tiếng Việt' &&
                              !setting.startingDayOfWeek!.checkIsVietNam)
                          ? setting.startingDayOfWeek!.convertVietNam
                          : setting.startingDayOfWeek!.checkIsVietNam
                              ? setting.startingDayOfWeek!.convertEnglish
                              : setting.startingDayOfWeek!,
                      style: AppStyles.medium.copyWith(
                        color: AppColors.selectedColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            // language
            GestureDetector(
              onTap: navigateToLanguageScreen,
              child: Box(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 20,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.language_rounded,
                      color: AppColors.textSecondColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.language,
                      style: AppStyles.medium.copyWith(
                        color: AppColors.textPrimaryColor,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      setting.language!,
                      style: AppStyles.medium.copyWith(
                        color: AppColors.selectedColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            // theme
            GestureDetector(
              onTap: navigateToSelectThemeScreen,
              child: Box(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 20,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_outlined,
                      color: AppColors.textSecondColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.changeTheme,
                      style: AppStyles.medium.copyWith(
                        color: AppColors.textPrimaryColor,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      setting.bean.nameBean,
                      style: AppStyles.medium.copyWith(
                        color: AppColors.selectedColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            // general text
            Text(
              AppLocalizations.of(context)!.other,
              style: AppStyles.medium.copyWith(
                color: AppColors.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 10),
            // privacy policy
            Box(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 20,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_outline,
                    color: AppColors.textSecondColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.privacyPolicy,
                    style: AppStyles.medium.copyWith(
                      color: AppColors.textPrimaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            // terms
            Box(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 20,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_outline,
                    color: AppColors.textSecondColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.termsOfConditions,
                    style: AppStyles.medium.copyWith(
                      color: AppColors.textPrimaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            // feedback
            Box(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 20,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.question_mark_outlined,
                    color: AppColors.textSecondColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.feedback,
                    style: AppStyles.medium.copyWith(
                      color: AppColors.textPrimaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            // about us
            Box(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 20,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: AppColors.textSecondColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.aboutUs,
                    style: AppStyles.medium.copyWith(
                      color: AppColors.textPrimaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
