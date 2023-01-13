import 'package:cs214/constants/app_colors.dart';
import 'package:cs214/features/diary/screens/add_diary_screen.dart';
import 'package:cs214/features/diary/screens/diary_screen.dart';
import 'package:cs214/providers/bottom_navigation_provider.dart';
import 'package:cs214/providers/date_provider.dart';
import 'package:cs214/services/db_helpers.dart';
import 'package:cs214/widgets/tab_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static const routeName = '/my_app';

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DbHelper dbHelper = DbHelper();

  List screens = [
    const DiaryScreen(),
    // const CategoryScreen(),
    // const BoardScreen(),
    // const SettingScreen(),
  ];

  navigateToAddDiaryScreen(DateTime dateTime) {
    Navigator.pushNamed(
      context,
      AddDiaryScreen.routeName,
      arguments: dateTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    var bottomProvider = Provider.of<BottomNavigationProvider>(context);
    var dateProvider = Provider.of<DateProvider>(context);

    // be used to change theme
    var settingProvider = context.watch<SettingProvider>();
    print('rebuild my app');
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.backgroundColor,
      body: screens[bottomProvider.currentIndex],
      bottomNavigationBar: BottomAppBar(
        color: AppColors.bottomBarColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // left tab icon
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TabWidget(
                    iconData: FontAwesomeIcons.bookOpen,
                    onPressed: () {
                      bottomProvider.currentIndex = 0;
                    },
                    name: AppLocalizations.of(context)!.diaryTab,
                    color: bottomProvider.currentIndex == 0
                        ? AppColors.primaryColor
                        : AppColors.textSecondColor,
                  ),
                  TabWidget(
                    onPressed: () {
                      bottomProvider.currentIndex = 1;
                    },
                    iconData: FontAwesomeIcons.list,
                    name: AppLocalizations.of(context)!.category,
                    color: bottomProvider.currentIndex == 1
                        ? AppColors.primaryColor
                        : AppColors.textSecondColor,
                  ),
                ],
              ),
              // right tab icon
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TabWidget(
                    onPressed: () {
                      bottomProvider.currentIndex = 2;
                    },
                    iconData: FontAwesomeIcons.chartSimple,
                    name: AppLocalizations.of(context)!.boardTab,
                    color: bottomProvider.currentIndex == 2
                        ? AppColors.primaryColor
                        : AppColors.textSecondColor,
                  ),
                  TabWidget(
                    onPressed: () {
                      bottomProvider.currentIndex = 3;
                    },
                    iconData: FontAwesomeIcons.gear,
                    name: AppLocalizations.of(context)!.settingTab,
                    color: bottomProvider.currentIndex == 3
                        ? AppColors.primaryColor
                        : AppColors.textSecondColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToAddDiaryScreen(dateProvider.selectedDay),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.selectedColor,
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 35,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
