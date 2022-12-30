import 'dart:convert';

import 'package:diary_app/constants/app_colors.dart';
import 'package:diary_app/constants/app_styles.dart';
import 'package:diary_app/constants/bean.dart';
import 'package:diary_app/constants/utils.dart';
import 'package:diary_app/features/diary/models/diary.dart';
import 'package:diary_app/features/setting/models/setting.dart';
import 'package:diary_app/providers/setting_provider.dart';
import 'package:diary_app/widgets/box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tuple/tuple.dart';

class ItemDiary extends StatelessWidget {
  final Diary diary;

  const ItemDiary({
    super.key,
    required this.diary,
  });

  @override
  Widget build(BuildContext context) {
    final SettingProvider settingProvider = context.read<SettingProvider>();
    final FocusNode editorFocusNode = FocusNode();
    Setting setting = settingProvider.setting;
    Bean bean = setting.bean;

    String locale = setting.language == 'English' ? 'en' : 'vi';
    quill.QuillController controller;
    if (diary.content == null) {
      controller = quill.QuillController(
        document: quill.Document()
          ..insert(0, AppLocalizations.of(context)!.nothing),
        selection: const TextSelection.collapsed(offset: 0),
      );
    } else {
      var json = jsonDecode(diary.content!);
      controller = quill.QuillController(
        document: quill.Document.fromJson(json),
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
    return Box(
      margin: const EdgeInsets.only(
        left: 15.0,
        right: 15.0,
        top: 10,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  diary.createdAt.day.toString(),
                  style: AppStyles.regular.copyWith(
                    fontSize: 25,
                    color: AppColors.textPrimaryColor,
                  ),
                ),
                Text(
                  DateFormat("MMM", locale).format(diary.createdAt),
                  style: AppStyles.regular.copyWith(
                    fontSize: 14,
                    color: AppColors.textPrimaryColor,
                  ),
                ),
                Image.asset(
                  bean.beans[5 - diary.getIndex().round()],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            const SizedBox(width: 10),
            VerticalDivider(
              color: AppColors.textSecondaryColor,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  quill.QuillEditor(
                    scrollable: true,
                    scrollController: ScrollController(),
                    focusNode: editorFocusNode,
                    padding: const EdgeInsets.all(0),
                    autoFocus: false,
                    readOnly: true,
                    expands: false,
                    controller: controller,
                    showCursor: false,
                    customStyles: getDefaultStyles(context),
                  ),
                  if (diary.images != null)
                    Wrap(
                      children: diary.images!
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(
                                top: 8.0,
                                right: 8.0,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.memory(
                                  e,
                                  fit: BoxFit.cover,
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
