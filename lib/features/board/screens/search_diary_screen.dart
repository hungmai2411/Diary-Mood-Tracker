import 'package:cs214/constants/app_colors.dart';
import 'package:cs214/features/board/widgets/box_search.dart';
import 'package:cs214/features/diary/models/diary.dart';
import 'package:cs214/features/diary/screens/detail_diary_screen.dart';
import 'package:cs214/features/diary/widgets/item_diary.dart';
import 'package:cs214/features/diary/widgets/item_no_diary.dart';
import 'package:cs214/providers/diary_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchDiaryScreen extends StatefulWidget {
  const SearchDiaryScreen({super.key});
  static const String routeName = '/search_diary_screen';
  @override
  State<SearchDiaryScreen> createState() => _SearchDiaryScreenState();
}

class _SearchDiaryScreenState extends State<SearchDiaryScreen> {
  final TextEditingController searchController = TextEditingController();
  List<Diary> diariesSearch = [];
  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
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
    List<Diary> diaries = context.watch<DiaryProvider>().diaries;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.textPrimaryColor,
            size: 21,
          ),
        ),
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: BoxSearch(
          searchController: searchController,
          callback: () {},
          onChanged: (s) {
            setState(() {
              diariesSearch = [];

              if (s.isNotEmpty) {
                for (var diary in diaries) {
                  if (diary.content!.contains(s)) {
                    diariesSearch.add(diary);
                  }
                }
              }
            });
          },
        ),
      ),
      body: diariesSearch.isEmpty
          ? const SizedBox(
              width: double.infinity,
              child: ItemNoDiary(),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                if (index == diariesSearch.length) {
                  return Container(height: 100);
                }

                Diary diary = diariesSearch[index];
                return GestureDetector(
                  onTap: () => navigateToDetailDiaryScreen(diary),
                  child: ItemDiary(diary: diary),
                );
              },
              itemCount: diariesSearch.length + 1,
            ),
    );
  }
}
