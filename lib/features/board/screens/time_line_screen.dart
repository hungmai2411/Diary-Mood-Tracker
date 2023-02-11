import 'package:cs214/constants/app_styles.dart';
import 'package:cs214/features/diary/models/diary.dart';
import 'package:cs214/features/diary/screens/detail_diary_screen.dart';
import 'package:cs214/features/diary/widgets/item_diary.dart';
import 'package:cs214/features/diary/widgets/item_no_diary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants/app_colors.dart';

class TimeLineScreen extends StatefulWidget {
  final List<Diary> diariesMonth;

  const TimeLineScreen({
    super.key,
    required this.diariesMonth,
  });
  static const String routeName = '/time_line_screen';
  @override
  State<TimeLineScreen> createState() => _TimeLineScreenState();
}

class _TimeLineScreenState extends State<TimeLineScreen> {
  bool isSort = false;
  late List<Diary> diaries;

  @override
  void initState() {
    super.initState();
    diaries = widget.diariesMonth;
  }

  navigateToDetailDiaryScreen(Diary diary) {
    Navigator.pushNamed(
      context,
      DetailDiaryScreen.routeName,
      arguments: diary,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.textPrimaryColor,
            size: 21,
          ),
        ),
        automaticallyImplyLeading: false,
        title: Text(
          AppLocalizations.of(context)!.timeLineTab,
          style: AppStyles.medium.copyWith(
            fontSize: 18,
            color: AppColors.textPrimaryColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.appbarColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (isSort) {
                  diaries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
                } else {
                  diaries.sort((a, b) => a.createdAt.compareTo(b.createdAt));
                }
                isSort = !isSort;
              });
            },
            icon: Icon(
              Icons.sort,
              color: AppColors.textPrimaryColor,
            ),
          ),
        ],
      ),
      body: diaries.isEmpty
          ? const SizedBox(
              width: double.infinity,
              child: ItemNoDiary(),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                if (index == diaries.length) {
                  return Container(height: 100);
                }

                Diary diary = diaries[index];
                return GestureDetector(
                  onTap: () => navigateToDetailDiaryScreen(diary),
                  child: ItemDiary(diary: diary),
                );
              },
              itemCount: diaries.length + 1,
            ),
    );
  }
}
