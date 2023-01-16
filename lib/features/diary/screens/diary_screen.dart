import 'package:cs214/constants/app_assets.dart';
import 'package:cs214/constants/app_colors.dart';
import 'package:cs214/constants/app_styles.dart';
import 'package:cs214/constants/bean.dart';
import 'package:cs214/constants/utils.dart';
import 'package:cs214/extensions/string_ext.dart';
import 'package:cs214/features/diary/models/diary.dart';
import 'package:cs214/features/diary/screens/add_diary_screen.dart';
import 'package:cs214/features/diary/screens/detail_diary_screen.dart';
import 'package:cs214/features/diary/screens/share_screen.dart';
import 'package:cs214/features/diary/widgets/item_date.dart';
import 'package:cs214/features/diary/widgets/item_diary.dart';
import 'package:cs214/features/diary/widgets/item_no_diary.dart';
import 'package:cs214/features/setting/models/setting.dart';
import 'package:cs214/providers/date_provider.dart';
import 'package:cs214/providers/diary_provider.dart';
import 'package:cs214/providers/setting_provider.dart';
import 'package:cs214/widgets/widget_to_image.dart';
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

  CalendarFormat _calendarFormat = CalendarFormat.month;

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
      appBar: AppBar(
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
            const Spacer(flex: 3),
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
            const Spacer(flex: 2),
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
      body: ListView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        children: [
          WidgetToImage(
            builder: (key) {
              key2 = key;
              return TableCalendar(
                rowHeight: 80,
                calendarFormat: _calendarFormat,
                startingDayOfWeek:
                    setting.startingDayOfWeek!.getStartingDayOfWeek,
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
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
                  prioritizedBuilder: (context, datetime, focusedDay) {
                    return GestureDetector(
                      onTap: () {
                        if (datetime.compareTo(DateTime.now()) == -1) {
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
                            ? bean.beans[
                                5 - eventsMood[datetime]![0].getIndex().round()]
                            : null,
                        color: AppColors.textPrimaryColor,
                        isSelected:
                            isSameDay(datetime, dateProvider.selectedDay),
                      ),
                    );
                  },
                ),
                headerVisible: false,
                firstDay: kFirstDay,
                lastDay: kLastDay,
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
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: eventsMood[dateProvider.selectedDay] == null
                ? const ItemNoDiary()
                : Column(
                    children: eventsMood[dateProvider.selectedDay]!
                        .map((e) => ItemDiary(diary: e))
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
