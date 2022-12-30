import 'package:diary_app/constants/app_colors.dart';
import 'package:diary_app/constants/app_styles.dart';
import 'package:diary_app/features/board/widgets/mood_bar.dart';
import 'package:diary_app/features/board/widgets/mood_flow.dart';
import 'package:diary_app/features/diary/models/diary.dart';
import 'package:diary_app/features/diary/screens/detail_diary_screen.dart';
import 'package:diary_app/features/diary/widgets/item_diary.dart';
import 'package:diary_app/features/diary/widgets/item_no_diary.dart';
import 'package:diary_app/features/setting/models/setting.dart';
import 'package:diary_app/features/board/screens/time_line_screen.dart';
import 'package:diary_app/providers/date_provider.dart';
import 'package:diary_app/providers/diary_provider.dart';
import 'package:diary_app/providers/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog_2/month_picker_dialog_2.dart';
import 'package:provider/provider.dart';
import 'package:quiver/time.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  DateTime selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    selectedDay = context.read<DateProvider>().selectedDay;
  }

  @override
  void dispose() {
    super.dispose();
  }

  navigateToDetailDiaryScreen(Diary diary) {
    Navigator.pushNamed(
      context,
      DetailDiaryScreen.routeName,
      arguments: diary,
    );
  }

  chooseMonth(String locale) async {
    showMonthPicker(
      dismissible: true,
      context: context,
      initialDate: selectedDay,
      locale: locale != 'en' ? const Locale('vi') : null,
      roundedCornersRadius: 8,
      unselectedMonthTextColor: AppColors.textSecondaryColor,
      headerColor: AppColors.calendarHeaderColor,
      cancelText: Text(
        AppLocalizations.of(context)!.cancel,
        style: TextStyle(
          color: AppColors.textSecondaryColor,
        ),
      ),
      confirmText: Text(
        AppLocalizations.of(context)!.ok,
        style: TextStyle(
          color: AppColors.selectedColor,
        ),
      ),
    ).then((date) {
      if (date != null) {
        setState(() {
          selectedDay = date;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final SettingProvider settingProvider = context.read<SettingProvider>();
    Setting setting = settingProvider.setting;
    String locale = setting.language == 'English' ? 'en' : 'vi';
    final DiaryProvider diaryProvider = context.read<DiaryProvider>();
    List<Diary> diaries = diaryProvider.diaries;
    List<Diary> diariesMonth = [];

    diaries.sort((b, a) => a.createdAt.compareTo(b.createdAt));

    for (Diary diary in diaries) {
      DateTime createdAt = diary.createdAt;

      if (createdAt.month == selectedDay.month &&
          createdAt.year == selectedDay.year) {
        diariesMonth.add(diary);
      }
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            title: GestureDetector(
              onTap: () => chooseMonth(locale),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('MMM, yyyy', locale).format(selectedDay),
                    style: AppStyles.medium.copyWith(
                      fontSize: 18,
                      color: AppColors.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(width: 6),
                  // choose time
                  Icon(
                    FontAwesomeIcons.angleDown,
                    size: 18,
                    color: AppColors.textPrimaryColor,
                  ),
                ],
              ),
            ),
            backgroundColor: AppColors.backgroundColor,
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 10),
            sliver: SliverToBoxAdapter(
              child: MoodFlow(
                month: selectedDay.month,
                year: selectedDay.year,
                numOfDays: daysInMonth(
                  selectedDay.year,
                  selectedDay.month,
                ),
                diaries: diariesMonth,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            sliver: SliverToBoxAdapter(
              child: MoodBar(
                diariesMonth: diariesMonth,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.timeLineTab,
                    style: AppStyles.medium.copyWith(
                      color: AppColors.textPrimaryColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        TimeLineScreen.routeName,
                        arguments: diariesMonth,
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.seeAll,
                      style: AppStyles.medium.copyWith(
                        color: AppColors.todayColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 0),
            sliver: diariesMonth.isEmpty
                ? const SliverToBoxAdapter(
                    child: SizedBox(
                      width: double.infinity,
                      child: ItemNoDiary(),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        if (index == diaries.length) {
                          return Container(height: 100);
                        }
                        Diary diary = diariesMonth[index];

                        return GestureDetector(
                          onTap: () => navigateToDetailDiaryScreen(diary),
                          child: ItemDiary(diary: diary),
                        );
                      },
                      childCount: diariesMonth.length + 1,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
