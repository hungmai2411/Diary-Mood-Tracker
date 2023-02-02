import 'dart:convert';

import 'package:diary_app/constants/app_colors.dart';
import 'package:diary_app/constants/app_styles.dart';
import 'package:diary_app/constants/utils.dart';
import 'package:diary_app/features/category/models/category.dart';
import 'package:diary_app/features/category/screens/edit_category_screen.dart';
import 'package:diary_app/features/category/widgets/delete_category_dialog.dart';
import 'package:diary_app/features/diary/widgets/delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart' as path;

class DetailCategoryScreen extends StatefulWidget {
  const DetailCategoryScreen({
    super.key,
    required this.category,
  });
  final Category category;
  static const String routeName = '/detail_category_screen';

  @override
  State<DetailCategoryScreen> createState() => _DetailCategoryScreenState();
}

class _DetailCategoryScreenState extends State<DetailCategoryScreen> {
  navigateToEditScreen() {
    Navigator.pushNamed(
      context,
      EditCategoryScreen.routeName,
      arguments: widget.category,
    );
  }

  deleteDiary() async {
    final bool? result = await showDialog(
      context: context,
      builder: (_) {
        return DeleteCategoryDialog(
          category: widget.category,
        );
      },
    );
    if (result != null) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var json = jsonDecode(widget.category.content);
    final FocusNode editorFocusNode = FocusNode();

    quill.QuillController noteController = quill.QuillController(
      document: quill.Document.fromJson(json),
      selection: const TextSelection.collapsed(offset: 0),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.textPrimaryColor,
          ),
        ),
        backgroundColor: AppColors.appbarColor,
        elevation: 0.3,
        automaticallyImplyLeading: false,
        title: Text(
          widget.category.title,
          style: AppStyles.medium
              .copyWith(fontSize: 18, color: AppColors.textPrimaryColor),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: navigateToEditScreen,
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
            onTap: deleteDiary,
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
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
        ),
        child: quill.QuillEditor(
          scrollable: true,
          scrollController: ScrollController(),
          focusNode: editorFocusNode,
          padding: const EdgeInsets.all(0),
          autoFocus: false,
          readOnly: true,
          expands: false,
          showCursor: false,
          controller: noteController,
          embedBuilders: FlutterQuillEmbeds.builders(),
          customStyles: getDefaultStyles(context),
        ),
      ),
    );
  }
}
