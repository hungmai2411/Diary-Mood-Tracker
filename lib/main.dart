import 'package:cs214/constants/app_colors.dart';
import 'package:cs214/constants/bean.dart';
import 'package:cs214/features/category/models/category.dart';
import 'package:cs214/features/diary/models/diary.dart';
import 'package:cs214/features/diary/screens/enter_pin_screen.dart';
import 'package:cs214/features/setting/models/setting.dart';
import 'package:cs214/l10n/l10n.dart';
import 'package:cs214/my_app.dart';
import 'package:cs214/providers/bottom_navigation_provider.dart';
import 'package:cs214/providers/category_provider.dart';
import 'package:cs214/providers/date_provider.dart';
import 'package:cs214/providers/diary_provider.dart';
import 'package:cs214/providers/setting_provider.dart';
import 'package:cs214/route.dart';
import 'package:cs214/services/db_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(DiaryAdapter());
  Hive.registerAdapter(SettingAdapter());
  Hive.registerAdapter(BeanAdapter());
  Hive.registerAdapter(CategoryAdapter());

  final DbHelper dbHelper = DbHelper();

  SettingProvider settingProvider = SettingProvider();
  DiaryProvider diaryProvider = DiaryProvider();
  CategoryProvider categoryProvider = CategoryProvider();

  await getSetting(dbHelper, settingProvider);
  await getDiaries(dbHelper, diaryProvider);
  await getCategories(dbHelper, categoryProvider);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<BottomNavigationProvider>(
          create: (_) => BottomNavigationProvider(),
        ),
        ChangeNotifierProvider<DiaryProvider>(
          create: (_) => diaryProvider,
        ),
        ChangeNotifierProvider<SettingProvider>(
          create: (_) => settingProvider,
        ),
        ChangeNotifierProvider<DateProvider>(
          create: (_) => DateProvider(),
        ),
        ChangeNotifierProvider<CategoryProvider>(
          create: (_) => categoryProvider,
        ),
      ],
      child: Consumer<SettingProvider>(
        builder: (
          context,
          model,
          child,
        ) {
          Setting setting = model.setting;
          print('rebuild main: ${setting.hasPasscode}');

          return MaterialApp(
            theme: ThemeData(
              scaffoldBackgroundColor: AppColors.backgroundColor,
            ),
            locale: setting.language == 'English'
                ? const Locale('en')
                : const Locale('vi'),
            supportedLocales: L10n.all,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              MonthYearPickerLocalizations.delegate,
            ],
            // initialRoute: !setting.hasPasscode
            //     ? MyApp.routeName
            //     : EnterPinScreen.routeName,
            routes: routes,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: generateRoutes,
            home: setting.hasPasscode && setting.passcode!.isNotEmpty
                ? const EnterPinScreen()
                : const MyApp(),
          );
        },
      ),
    ),
  );
}

Future<void> getDiaries(
  DbHelper dbHelper,
  DiaryProvider diaryProvider,
) async {
  final box = await dbHelper.openBox("diaries");
  List<Diary> diaries = dbHelper.getDiaries(box);
  diaryProvider.setDiaries(diaries);
}

Future<void> getCategories(
  DbHelper dbHelper,
  CategoryProvider categoryProvider,
) async {
  final box = await dbHelper.openBox("categories");
  List<Category> categories = dbHelper.getCategories(box);
  categoryProvider.setCategories(categories);
}

Future<void> getSetting(
  DbHelper dbHelper,
  SettingProvider settingProvider,
) async {
  final boxSetting = await dbHelper.openBox("settings");

  Setting setting = dbHelper.getSetting(boxSetting);
  String background = setting.background;

  if (background == 'System mode') {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    background = isDarkMode ? 'Dark mode' : 'Light mode';
  }

  AppColors.changeTheme(background);

  if (setting.language == null) {
    setting = setting.copyWith(
      language: 'English',
    );
  }
  if (setting.startingDayOfWeek == null) {
    setting = setting.copyWith(startingDayOfWeek: 'Sunday');
  }

  settingProvider.setSetting(setting);
}
