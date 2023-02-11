import 'package:cs214/features/category/models/category.dart';
import 'package:cs214/features/category/screens/category_screen.dart';
import 'package:cs214/features/category/screens/create_category_screen.dart';
import 'package:cs214/features/category/screens/detail_category_screen.dart';
import 'package:cs214/features/category/screens/edit_category_screen.dart';
import 'package:cs214/features/diary/models/diary.dart';
import 'package:cs214/features/diary/screens/add_diary_screen.dart';
import 'package:cs214/features/diary/screens/detail_diary_screen.dart';
import 'package:cs214/features/diary/screens/detail_image_screen.dart';
import 'package:cs214/features/diary/screens/diary_screen.dart';
import 'package:cs214/features/diary/screens/edit_diary_screen.dart';
import 'package:cs214/features/diary/screens/enter_pin_screen.dart';
import 'package:cs214/features/diary/screens/share_screen.dart';
import 'package:cs214/features/setting/screens/language_screen.dart';
import 'package:cs214/features/setting/screens/passcode_confirm_screen.dart';
import 'package:cs214/features/setting/screens/passcode_screen.dart';
import 'package:cs214/features/setting/screens/select_theme_screen.dart';
import 'package:cs214/features/setting/screens/setting_screen.dart';
import 'package:cs214/features/setting/screens/start_of_the_week_screen.dart';
import 'package:cs214/features/board/screens/time_line_screen.dart';
import 'package:cs214/features/setting/screens/theme_store_screen.dart';
import 'package:cs214/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final Map<String, WidgetBuilder> routes = {
  MyApp.routeName: (context) => const MyApp(),
  DiaryScreen.routeName: (context) => const DiaryScreen(),
  StartOfTheWeekScreen.routeName: (context) => const StartOfTheWeekScreen(),
  LanguageScreen.routeName: (context) => const LanguageScreen(),
  PasscodeScreen.routeName: (context) => const PasscodeScreen(),
  SettingScreen.routeName: (context) => const SettingScreen(),
  SelectThemeScreen.routeName: (context) => const SelectThemeScreen(),
  CategoryScreen.routeName: (context) => const CategoryScreen(),
  CreateCategoryScreen.routeName: (context) => const CreateCategoryScreen(),
  ThemeStoreScreen.routeName: (context) => const ThemeStoreScreen(),
  EnterPinScreen.routeName: (context) => const EnterPinScreen(),
};

MaterialPageRoute<dynamic>? generateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case AddDiaryScreen.routeName:
      final DateTime dateTime = settings.arguments as DateTime;
      return MaterialPageRoute<dynamic>(
        settings: settings,
        builder: (context) => AddDiaryScreen(
          dateTime: dateTime,
        ),
      );
    case EditDiaryScreen.routeName:
      final Diary diary = settings.arguments as Diary;
      return MaterialPageRoute<dynamic>(
        settings: settings,
        builder: (context) => EditDiaryScreen(
          diary: diary,
        ),
      );
    case EditCategoryScreen.routeName:
      final Category category = settings.arguments as Category;
      return MaterialPageRoute<dynamic>(
        settings: settings,
        builder: (context) => EditCategoryScreen(
          category: category,
        ),
      );
    case DetailDiaryScreen.routeName:
      final Diary diary = settings.arguments as Diary;
      return MaterialPageRoute<dynamic>(
        settings: settings,
        builder: (context) => DetailDiaryScreen(
          diary: diary,
        ),
      );

    case PasscodeConfirmScreen.routeName:
      final String passcode = settings.arguments as String;
      return MaterialPageRoute<dynamic>(
        settings: settings,
        builder: (context) => PasscodeConfirmScreen(passcode: passcode),
      );
    case DetailCategoryScreen.routeName:
      final Category category = settings.arguments as Category;
      return MaterialPageRoute<dynamic>(
        settings: settings,
        builder: (context) => DetailCategoryScreen(category: category),
      );
    case DetailImageScreen.routeName:
      final Uint8List image = settings.arguments as Uint8List;
      return MaterialPageRoute<dynamic>(
        settings: settings,
        builder: (context) => DetailImageScreen(image: image),
      );
    case ShareScreen.routeName:
      final List images = settings.arguments as List;
      return MaterialPageRoute<dynamic>(
        settings: settings,
        builder: (context) => ShareScreen(
          bytes1: images[0],
          bytes2: images[1],
        ),
      );
    case TimeLineScreen.routeName:
      final List<Diary> diaries = settings.arguments as List<Diary>;
      return MaterialPageRoute<dynamic>(
        settings: settings,
        builder: (context) => TimeLineScreen(
          diariesMonth: diaries,
        ),
      );
  }
}
