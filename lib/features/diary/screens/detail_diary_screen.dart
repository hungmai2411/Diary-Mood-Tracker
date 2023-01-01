import 'dart:convert';

import 'package:diary_app/constants/app_colors.dart';
import 'package:diary_app/constants/app_styles.dart';
import 'package:diary_app/constants/bean.dart';
import 'package:diary_app/constants/utils.dart';
import 'package:diary_app/features/diary/models/diary.dart';
import 'package:diary_app/features/diary/screens/edit_diary_screen.dart';
import 'package:diary_app/features/diary/widgets/delete_dialog.dart';
import 'package:diary_app/features/diary/widgets/image_group.dart';
import 'package:diary_app/features/setting/models/setting.dart';
import 'package:diary_app/providers/setting_provider.dart';
import 'package:diary_app/widgets/box.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailDiaryScreen extends StatelessWidget {
  final Diary diary;

  const DetailDiaryScreen({
    super.key,
    required this.diary,
  });
  static const String routeName = '/detail_diary_screen';

  popScreen(BuildContext context) {
    Navigator.pop(context);
  }

  navigateToEditScreen(BuildContext context) {
    Navigator.pushNamed(
      context,
      EditDiaryScreen.routeName,
      arguments: diary,
    );
  }

  deleteDiary(BuildContext context) async {
    final bool? result = await showDialog(
      context: context,
      builder: (_) {
        return DeleteDialog(
          diary: diary,
        );
      },
    );
    if (result != null) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    SettingProvider settingProvider = context.read<SettingProvider>();
    Setting setting = settingProvider.setting;
    Bean bean = setting.bean;
    List<String> moodImages = bean.beans;
    int indexMood = 5 - diary.getIndex().round();
    final FocusNode editorFocusNode = FocusNode();
    quill.QuillController noteController;

    if (diary.content == null) {
      noteController = quill.QuillController(
        document: quill.Document()
          ..insert(0, AppLocalizations.of(context)!.nothing),
        selection: const TextSelection.collapsed(offset: 0),
      );
    } else {
      var json = jsonDecode(diary.content!);
      noteController = quill.QuillController(
        document: quill.Document.fromJson(json),
        selection: const TextSelection.collapsed(offset: 0),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => popScreen(context),
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.textPrimaryColor,
          ),
        ),
        title: Text(
          DateFormat('MMM d, yyyy').format(diary.createdAt),
          style: AppStyles.medium.copyWith(
            fontSize: 18,
            color: AppColors.textPrimaryColor,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => navigateToEditScreen(context),
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                FontAwesomeIcons.penToSquare,
                size: 20,
                color: AppColors.textPrimaryColor,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => deleteDiary(context),
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Icon(
                FontAwesomeIcons.trashCan,
                size: 20,
                color: AppColors.textPrimaryColor,
              ),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // how was your day ?
          Box(
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 15, top: 10),
                  child: Text(
                    'How was your day?',
                    style: AppStyles.medium.copyWith(
                      fontSize: 18,
                      color: AppColors.textPrimaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: moodImages.map((e) {
                    int index = moodImages.indexOf(e);
                    return Opacity(
                      opacity: index == indexMood ? 1 : 0.3,
                      child: Image.asset(
                        e,
                        width: 70,
                        height: 70,
                        fit: BoxFit.fitHeight,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
          // write about to day
          if (diary.content != null)
            Box(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Write about today',
                    style: AppStyles.medium.copyWith(
                      fontSize: 18,
                      color: AppColors.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Divider(
                    color: AppColors.textSecondaryColor,
                  ),
                  quill.QuillEditor(
                    scrollable: true,
                    scrollController: ScrollController(),
                    focusNode: editorFocusNode,
                    padding: const EdgeInsets.all(0),
                    autoFocus: false,
                    readOnly: true,
                    expands: false,
                    showCursor: false,
                    controller: noteController,
                    customStyles: getDefaultStyles(context),
                  ),
                ],
              ),
            ),
          // your photos
          if (diary.images!.isNotEmpty)
            Box(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your photos',
                    style: AppStyles.medium.copyWith(
                      fontSize: 18,
                      color: AppColors.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ImageGroup(images: diary.images!),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
