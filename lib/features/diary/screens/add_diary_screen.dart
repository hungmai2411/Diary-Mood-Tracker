import 'dart:convert';
import 'dart:typed_data';
import 'package:diary_app/constants/app_assets.dart';
import 'package:diary_app/constants/app_colors.dart';
import 'package:diary_app/constants/app_styles.dart';
import 'package:diary_app/constants/utils.dart';
import 'package:diary_app/features/diary/models/diary.dart';
import 'package:diary_app/features/diary/widgets/item_mood.dart';
import 'package:diary_app/features/diary/widgets/item_upload_group.dart';
import 'package:diary_app/features/diary/widgets/success_dialog.dart';
import 'package:diary_app/features/setting/models/setting.dart';
import 'package:diary_app/providers/diary_provider.dart';
import 'package:diary_app/providers/setting_provider.dart';
import 'package:diary_app/widgets/app_dialog.dart';
import 'package:diary_app/widgets/box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants/global_variables.dart';

class AddDiaryScreen extends StatefulWidget {
  final DateTime dateTime;

  const AddDiaryScreen({
    super.key,
    required this.dateTime,
  });
  static const String routeName = '/add_diary_screen';
  @override
  State<AddDiaryScreen> createState() => _AddDiaryScreenState();
}

class _AddDiaryScreenState extends State<AddDiaryScreen> {
  String moodPicked = '';
  //final TextEditingController noteController = TextEditingController();
  // lưu trữ hình ảnh
  List<Uint8List> images = [];
  final FocusNode editorFocusNode = FocusNode();

  quill.QuillController noteController = quill.QuillController.basic();

  popScreen() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  addNote(BuildContext context) async {
    if (moodPicked.isEmpty) {
      showSnackBar(
        context,
        AppLocalizations.of(context)!.pleaseRecordYourMood,
      );
    } else {
      final SettingProvider settingProvider = context.read<SettingProvider>();
      Setting setting = settingProvider.setting;
      setting = setting.copyWith(point: setting.point + 100);
      settingProvider.setSetting(setting);
      final diaryProvider = context.read<DiaryProvider>();
      var json = jsonEncode(noteController.document.toDelta().toJson());
      var note = noteController.document.toPlainText();
      print(note.length);
      Diary newDiary = Diary(
        mood: moodPicked,
        createdAt: DateTime.utc(
          widget.dateTime.year,
          widget.dateTime.month,
          widget.dateTime.day,
        ),
        content: note.length == 1 ? null : json,
        images: images,
      );
      diaryProvider.addDiary(newDiary);
      await showDialog(
        context: context,
        builder: (_) {
          return const AppDialog(child: SuccessDialog());
        },
      );
      popScreen();
    }
  }

  late final List moods;

  @override
  void initState() {
    super.initState();
    getMoods();
  }

  getMoods() {
    final SettingProvider settingProvider = context.read<SettingProvider>();
    Setting setting = settingProvider.setting;
    String nameBean = setting.bean.nameBean;

    if (nameBean == 'Basic Bean') {
      moods = basicBean;
    } else if (nameBean == 'Blushing Bean') {
      moods = blushingBean;
    } else if (nameBean == 'Kitty Bean') {
      moods = kittyBean;
    } else {
      moods = sproutBean;
    }
  }

  @override
  Widget build(BuildContext context) {
    final SettingProvider settingProvider = context.read<SettingProvider>();

    Setting setting = settingProvider.setting;
    String locale = setting.language == 'English' ? 'en' : 'vi';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: popScreen,
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.textPrimaryColor,
          ),
        ),
        title: Text(
          DateFormat('MMM d, yyyy', locale).format(widget.dateTime),
          style: AppStyles.medium.copyWith(
            fontSize: 18,
            color: AppColors.textPrimaryColor,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () => addNote(context),
              icon: Icon(
                FontAwesomeIcons.check,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: ListView(
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
                      AppLocalizations.of(context)!.howWasYourDay,
                      style: AppStyles.medium.copyWith(
                        fontSize: 18,
                        color: AppColors.textPrimaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 80,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                      ),
                      itemCount: moods.length,
                      itemBuilder: (context, index) {
                        String mood = moods[index];
                        String moodName = nameBeans[index];
                        print('moodName: $moodName');
                        return ItemMood(
                          mood: mood,
                          moodName: moodName,
                          isPicked: moodPicked == moodName ? true : false,
                          callback: (mood) {
                            setState(() {
                              moodPicked = moodName;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // write about to day
            Box(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.writeAboutToday,
                        style: AppStyles.medium.copyWith(
                          fontSize: 18,
                          color: AppColors.textPrimaryColor,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Divider(
                    color: AppColors.textSecondaryColor,
                  ),
                  SizedBox(
                    height: 150,
                    child: quill.QuillEditor(
                      scrollable: true,
                      scrollController: ScrollController(),
                      focusNode: editorFocusNode,
                      padding: const EdgeInsets.all(0),
                      autoFocus: false,
                      readOnly: false,
                      expands: false,
                      controller: noteController,
                      placeholder: AppLocalizations.of(context)!.writeSomething,
                      customStyles: getDefaultStyles(context),
                    ),
                  ),
                ],
              ),
            ),
            // your photos
            Box(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.yourPhotos,
                    style: AppStyles.medium.copyWith(
                      fontSize: 18,
                      color: AppColors.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ItemUploadGroup(
                    images: images,
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
