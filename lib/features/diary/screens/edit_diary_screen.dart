import 'dart:convert';
import 'dart:typed_data';
import 'package:diary_app/constants/app_assets.dart';
import 'package:diary_app/constants/app_colors.dart';
import 'package:diary_app/constants/app_styles.dart';
import 'package:diary_app/constants/global_variables.dart';
import 'package:diary_app/constants/utils.dart';
import 'package:diary_app/features/diary/models/diary.dart';
import 'package:diary_app/features/diary/widgets/item_mood.dart';
import 'package:diary_app/features/diary/widgets/item_upload_group.dart';
import 'package:diary_app/features/setting/models/setting.dart';
import 'package:diary_app/my_app.dart';
import 'package:diary_app/providers/diary_provider.dart';
import 'package:diary_app/providers/setting_provider.dart';
import 'package:diary_app/widgets/box.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditDiaryScreen extends StatefulWidget {
  final Diary diary;

  const EditDiaryScreen({
    super.key,
    required this.diary,
  });
  static const String routeName = '/edit_diary_screen';
  @override
  State<EditDiaryScreen> createState() => _EditDiaryScreenState();
}

class _EditDiaryScreenState extends State<EditDiaryScreen> {
  String moodPicked = '';
  quill.QuillController noteController = quill.QuillController.basic();
  final FocusNode editorFocusNode = FocusNode();

  // lưu trữ hình ảnh
  List<Uint8List> images = [];

  popScreen() {
    Navigator.pop(context);
  }

  addNote(BuildContext context) async {
    if (moodPicked.isEmpty) {
      showSnackBar(context, 'Please record your mood');
    } else {
      final diaryProvider = context.read<DiaryProvider>();

      diaryProvider.editDiary(
        widget.diary,
        moodPicked,
        jsonEncode(noteController.document.toDelta().toJson()),
        images,
      );

      Navigator.pushNamed(context, MyApp.routeName);
    }
  }

  @override
  void dispose() {
    super.dispose();
    noteController.dispose();
  }

  @override
  void initState() {
    super.initState();
    getMoods();

    if (widget.diary.content != null) {
      var json = jsonDecode(widget.diary.content!);
      noteController = quill.QuillController(
        document: quill.Document.fromJson(json),
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
    moodPicked = widget.diary.mood;
    if (widget.diary.images != null) {
      images = widget.diary.images!;
    }
  }

  late final List moods;
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
          DateFormat('MMM d, yyyy').format(widget.diary.createdAt),
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
                      'How was your day?',
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
                  SizedBox(
                    height: 150,
                    child: quill.QuillEditor(
                      scrollable: true,
                      scrollController: ScrollController(),
                      focusNode: editorFocusNode,
                      padding: const EdgeInsets.all(0),
                      autoFocus: true,
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
                    'Your photos',
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
