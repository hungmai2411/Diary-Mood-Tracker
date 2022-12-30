import 'package:diary_app/constants/app_assets.dart';
import 'package:diary_app/constants/app_colors.dart';
import 'package:diary_app/constants/app_styles.dart';
import 'package:diary_app/constants/bean.dart';
import 'package:diary_app/constants/utils.dart';
import 'package:diary_app/extensions/string_ext.dart';
import 'package:diary_app/features/diary/models/diary.dart';
import 'package:diary_app/features/diary/screens/add_diary_screen.dart';
import 'package:diary_app/features/diary/screens/detail_diary_screen.dart';
import 'package:diary_app/features/diary/screens/share_screen.dart';
import 'package:diary_app/features/diary/widgets/item_date.dart';
import 'package:diary_app/features/diary/widgets/item_diary.dart';
import 'package:diary_app/features/diary/widgets/item_no_diary.dart';
import 'package:diary_app/features/setting/models/setting.dart';
import 'package:diary_app/providers/date_provider.dart';
import 'package:diary_app/providers/diary_provider.dart';
import 'package:diary_app/providers/setting_provider.dart';
import 'package:diary_app/widgets/widget_to_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});
  static const String routeName = '/diary_screen';
  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey? key1;
  Uint8List? bytes1;

  GlobalKey? key2;
  Uint8List? bytes2;
  late SettingProvider settingProvider;
  late Setting setting;
  late Bean bean;
  Map<DateTime, List<Diary>> eventsMood = {};

  @override
  void initState() {
    super.initState();
    settingProvider = context.read<SettingProvider>();
    setting = settingProvider.setting;
    bean = setting.bean;
  }

  createEvents(List<Diary> diaries) {
    eventsMood = {};
    for (var diary in diaries) {
      DateTime createdAt = diary.createdAt;
      List<Diary>? diariesTmp = eventsMood[createdAt];
      print('createdTime: $createdAt diaries: $diariesTmp');
      if (diariesTmp != null) {
        eventsMood[createdAt] = [...diariesTmp, diary];
      } else {
        eventsMood[createdAt] = [diary];
      }
    }
  }

  navigateToAddDiaryScreen(DateTime dateTime) {
    Navigator.pushNamed(
      context,
      AddDiaryScreen.routeName,
      arguments: dateTime,
    );
  }

  navigateToDetailDiaryScreen(Diary diary) {
    Navigator.pushNamed(
      context,
      DetailDiaryScreen.routeName,
      arguments: diary,
    );
  }

  void chooseDate(String locale) async {
    final dateProvider = context.read<DateProvider>();

    final result = await showDatePicker(
      context: context,
      initialDate: dateProvider.selectedDay,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      locale: Locale(locale),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: AppColors.calendarColor,
            colorScheme: ColorScheme.light(
              primary: AppColors.calendarHeaderColor, // header background color
              onPrimary: AppColors.textPrimaryColor, // header text color
              onSurface: AppColors.textPrimaryColor, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: AppColors.selectedColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (result != null) {
      dateProvider.setDay(result);
    }
  }

  void captureImage() async {
// Lấy dữ liệu của widget theo key.
    final bytes1 = await capture(key1);
    final bytes2 = await capture(key2);
    setState(() {
      this.bytes1 = bytes1;
      this.bytes2 = bytes2;
    });
    Navigator.pushNamed(
      context,
      ShareScreen.routeName,
      arguments: [this.bytes1, this.bytes2],
    );
  }

  @override
  Widget build(BuildContext context) {
    final SettingProvider settingProvider = context.read<SettingProvider>();
    final DateProvider dateProvider = context.watch<DateProvider>();
    final DiaryProvider diaryProvider = context.watch<DiaryProvider>();
    List<Diary> diaries = diaryProvider.diaries;
    createEvents(diaries);
    Setting setting = settingProvider.setting;
    String locale = setting.language == 'English' ? 'en' : 'vi';

    final kToday = DateTime.now();
    final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
    final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
    print('point of diary screen: ${setting.point}');
    return Scaffold(
      key: _scaffoldKey,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.backgroundColor,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppAssets.iconCoin,
                  width: 20,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 6),
                // coin
                Text(
                  setting.point.toString(),
                  style: AppStyles.semibold.copyWith(
                    fontSize: 16,
                    color: AppColors.textPrimaryColor,
                  ),
                ),
                const Spacer(),
                // datetime
                GestureDetector(
                  onTap: () => chooseDate(locale),
                  child: Row(
                    children: [
                      WidgetToImage(
                        builder: (key) {
                          key1 = key;
                          return Text(
                            DateFormat('MMM dd, yyyy', locale)
                                .format(dateProvider.selectedDay),
                            style: AppStyles.medium.copyWith(
                              fontSize: 18,
                              color: AppColors.textPrimaryColor,
                            ),
                          );
                        },
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
                const Spacer(),
                IconButton(
                  onPressed: captureImage,
                  icon: Icon(
                    Icons.ios_share,
                    color: AppColors.textPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.width,
              child: WidgetToImage(
                builder: (key) {
                  key2 = key;
                  return TableCalendar(
                    startingDayOfWeek:
                        setting.startingDayOfWeek!.getStartingDayOfWeek,
                    shouldFillViewport: true,
                    //eventLoader: getEventsForDays,
                    calendarBuilders: CalendarBuilders(
                      dowBuilder: ((context, day) {
                        final text = DateFormat.E(locale).format(day);

                        return Center(
                          child: Text(
                            text,
                            style: AppStyles.regular.copyWith(
                              color: AppColors.textPrimaryColor,
                            ),
                          ),
                        );
                      }),
                      defaultBuilder: (context1, datetime, events) {
                        return GestureDetector(
                          onTap: () {
                            if (!isSameDay(
                                    datetime, dateProvider.selectedDay) &&
                                datetime.compareTo(DateTime.now()) == -1) {
                              dateProvider.setDay(datetime);
                            } else {
                              showSnackBar(
                                context,
                                AppLocalizations.of(context)!
                                    .youCannotRecordThefuture,
                              );
                            }
                          },
                          child: ItemDate(
                            date: datetime.day.toString(),
                            img: eventsMood[datetime] != null
                                ? bean.beans[5 -
                                    eventsMood[datetime]![0].getIndex().round()]
                                : null,
                            color: AppColors.textPrimaryColor,
                          ),
                        );
                      },
                      todayBuilder: (context, datetime, events) {
                        return GestureDetector(
                          onTap: () {
                            dateProvider.setDay(datetime);
                          },
                          child: ItemDate(
                            date: datetime.day.toString(),
                            color: AppColors.todayColor,
                            img: eventsMood[datetime] != null
                                ? bean.beans[5 -
                                    eventsMood[datetime]![0].getIndex().round()]
                                : null,
                          ),
                        );
                      },
                      selectedBuilder: (context, datetime, events) {
                        return ItemDate(
                          date: datetime.day.toString(),
                          color: AppColors.primaryColor,
                          img: eventsMood[datetime] != null
                              ? bean.beans[5 -
                                  eventsMood[datetime]![0].getIndex().round()]
                              : null,
                          isSelected: true,
                        );
                      },
                    ),
                    headerVisible: false,
                    firstDay: kFirstDay,
                    lastDay: kLastDay,
                    calendarFormat: CalendarFormat.month,
                    focusedDay: dateProvider.focusedDay,
                    onPageChanged: (focusedDay) {
                      dateProvider.setDay(focusedDay);
                    },
                    calendarStyle: const CalendarStyle(
                      outsideDaysVisible: false,
                    ),
                    locale: locale,
                    selectedDayPredicate: (day) =>
                        isSameDay(dateProvider.selectedDay, day),
                  );
                },
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            sliver: eventsMood[dateProvider.selectedDay] == null
                ? const SliverToBoxAdapter(
                    child: ItemNoDiary(),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (
                        BuildContext context,
                        int index,
                      ) {
                        if (index ==
                            eventsMood[dateProvider.selectedDay]!.length) {
                          return Container(
                            height: 100,
                          );
                        }
                        Diary diary =
                            eventsMood[dateProvider.selectedDay]![index];

                        return GestureDetector(
                          onTap: () => navigateToDetailDiaryScreen(diary),
                          child: ItemDiary(diary: diary),
                        );
                      },
                      childCount:
                          eventsMood[dateProvider.selectedDay]!.length + 1,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
