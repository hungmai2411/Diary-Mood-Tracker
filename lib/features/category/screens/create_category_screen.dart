import 'dart:convert';
import 'dart:io';

import 'package:diary_app/constants/app_colors.dart';
import 'package:diary_app/constants/app_styles.dart';
import 'package:diary_app/constants/utils.dart';
import 'package:diary_app/features/category/models/category.dart';
import 'package:diary_app/providers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class CreateCategoryScreen extends StatefulWidget {
  const CreateCategoryScreen({super.key});

  static const String routeName = '/create_category_screen';
  @override
  State<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  final TextEditingController titleController = TextEditingController();
  final FocusNode editorFocusNode = FocusNode();
  quill.QuillController contentController = quill.QuillController.basic();

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
  }

  Future<String> _onImagePickCallback(File file) async {
    // // Copies the picked file from temporary cache to applications directory
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final copiedFile =
        await file.copy('${appDocDir.path}/${basename(file.path)}');
    return copiedFile.path.toString();
  }

  Future<MediaPickSetting?> _selectCameraPickSetting(BuildContext context) =>
      showDialog<MediaPickSetting>(
        context: context,
        builder: (ctx) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.camera),
                label: const Text('Capture a photo'),
                onPressed: () => Navigator.pop(ctx, MediaPickSetting.Camera),
              ),
              TextButton.icon(
                icon: const Icon(Icons.video_call),
                label: const Text('Capture a video'),
                onPressed: () => Navigator.pop(ctx, MediaPickSetting.Video),
              )
            ],
          ),
        ),
      );

  Future<MediaPickSetting?> _selectMediaPickSetting(BuildContext context) =>
      showDialog<MediaPickSetting>(
        context: context,
        builder: (ctx) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.collections),
                label: const Text('Gallery'),
                onPressed: () => Navigator.pop(ctx, MediaPickSetting.Gallery),
              ),
              TextButton.icon(
                icon: const Icon(Icons.link),
                label: const Text('Link'),
                onPressed: () => Navigator.pop(ctx, MediaPickSetting.Camera),
              )
            ],
          ),
        ),
      );

  Future<String> _onVideoPickCallback(File file) async {
    // Copies the picked file from temporary cache to applications directory
    final appDocDir = await getApplicationDocumentsDirectory();
    final copiedFile =
        await file.copy('${appDocDir.path}/${basename(file.path)}');
    return copiedFile.path.toString();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: AppColors.textPrimaryColor,
              size: 21,
            ),
          ),
          title: Text(
            AppLocalizations.of(context)!.write,
            style: AppStyles.medium
                .copyWith(fontSize: 16, color: AppColors.textPrimaryColor),
          ),
          centerTitle: true,
          elevation: 0.3,
          backgroundColor: AppColors.appbarColor,
          actions: [
            IconButton(
              onPressed: () => addCategory(context),
              icon: Icon(
                Icons.close_rounded,
                color: AppColors.textPrimaryColor,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: 10.0,
            right: 10.0,
            top: 10,
          ),
          child: ListView(
            children: [
              quill.QuillToolbar.basic(
                controller: contentController,
                showFontFamily: false,
                showFontSize: false,
                embedButtons: FlutterQuillEmbeds.buttons(
                  showCameraButton: true,
                  onImagePickCallback: _onImagePickCallback,
                  onVideoPickCallback: _onVideoPickCallback,
                  mediaPickSettingSelector: _selectMediaPickSetting,
                  cameraPickSettingSelector: _selectCameraPickSetting,
                ),
                locale: const Locale('vi'),
                afterButtonPressed: editorFocusNode.requestFocus,
                showAlignmentButtons: true,
                showLink: false,
                showListCheck: false,
              ),
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.title,
                style: AppStyles.bold.copyWith(
                  fontSize: 18,
                  color: AppColors.textPrimaryColor,
                ),
              ),
              TextField(
                style: AppStyles.regular.copyWith(
                  color: AppColors.textPrimaryColor,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: AppLocalizations.of(context)!.addTitle,
                  hintStyle: AppStyles.regular.copyWith(
                    color: AppColors.textPrimaryColor,
                  ),
                ),
                controller: titleController,
              ),
              Text(
                AppLocalizations.of(context)!.content,
                style: AppStyles.bold.copyWith(
                  fontSize: 18,
                  color: AppColors.textPrimaryColor,
                ),
              ),
              quill.QuillEditor(
                scrollable: true,
                scrollController: ScrollController(),
                focusNode: editorFocusNode,
                padding: const EdgeInsets.all(0),
                autoFocus: false,
                readOnly: false,
                expands: false,
                embedBuilders: FlutterQuillEmbeds.builders(),
                controller: contentController,
                placeholder: AppLocalizations.of(context)!.writeSomething,
                customStyles: getDefaultStyles(context),
                enableSelectionToolbar: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addCategory(BuildContext context) {
    var json = jsonEncode(contentController.document.toDelta().toJson());

    if (titleController.text.isNotEmpty) {
      Category category = Category(title: titleController.text, content: json);
      context.read<CategoryProvider>().addCategory(category);
    }
    Navigator.of(context).pop();
  }
}
