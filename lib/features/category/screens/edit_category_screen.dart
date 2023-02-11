import 'dart:convert';
import 'dart:io';
import 'package:cs214/constants/app_colors.dart';
import 'package:cs214/constants/app_styles.dart';
import 'package:cs214/constants/utils.dart';
import 'package:cs214/features/category/models/category.dart';
import 'package:cs214/my_app.dart';

import 'package:cs214/providers/category_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditCategoryScreen extends StatefulWidget {
  final Category category;

  const EditCategoryScreen({
    super.key,
    required this.category,
  });
  static const String routeName = '/edit_category_screen';
  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  quill.QuillController contentController = quill.QuillController.basic();
  final FocusNode editorFocusNode = FocusNode();
  final TextEditingController titleController = TextEditingController();

  popScreen() {
    Navigator.pop(context);
  }

  void editCategory() {
    var json = jsonEncode(contentController.document.toDelta().toJson());

    if (titleController.text.isNotEmpty) {
      context
          .read<CategoryProvider>()
          .editCategory(widget.category, titleController.text, json);
    }
    Navigator.pushNamed(context, MyApp.routeName);
  }

  @override
  void dispose() {
    super.dispose();
    contentController.dispose();
    titleController.dispose();
  }

  @override
  void initState() {
    super.initState();

    var json = jsonDecode(widget.category.content);
    contentController = quill.QuillController(
      document: quill.Document.fromJson(json),
      selection: const TextSelection.collapsed(offset: 0),
    );
    titleController.text = widget.category.title;
  }

  Future<String> _onImagePickCallback(File file) async {
    // // Copies the picked file from temporary cache to applications directory
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final copiedFile =
        await file.copy('${appDocDir.path}/${path.basename(file.path)}');
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
        await file.copy('${appDocDir.path}/${path.basename(file.path)}');
    return copiedFile.path.toString();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.write,
            style: AppStyles.medium
                .copyWith(fontSize: 16, color: AppColors.textPrimaryColor),
          ),
          centerTitle: true,
          elevation: 0.3,
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.appbarColor,
          actions: [
            IconButton(
              onPressed: editCategory,
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
}
