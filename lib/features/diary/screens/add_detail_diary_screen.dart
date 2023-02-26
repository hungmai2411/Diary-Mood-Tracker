import 'package:cs214/constants/app_colors.dart';
import 'package:cs214/constants/app_styles.dart';
import 'package:cs214/constants/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddDetailDiaryScreen extends StatefulWidget {
  final quill.QuillController controller;

  const AddDetailDiaryScreen({super.key, required this.controller});
  static const String routeName = '/add_detail_diary_screen';
  @override
  State<AddDetailDiaryScreen> createState() => _AddDetailDiaryScreenState();
}

class _AddDetailDiaryScreenState extends State<AddDetailDiaryScreen> {
  final TextEditingController titleController = TextEditingController();
  final FocusNode editorFocusNode = FocusNode();
  quill.QuillController contentController = quill.QuillController.basic();

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
  }

  @override
  void initState() {
    super.initState();
    contentController = widget.controller;
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
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pop(context, contentController),
          child: const Icon(FontAwesomeIcons.expand),
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

  // void addCategory(BuildContext context) {
  //   var json = jsonEncode(contentController.document.toDelta().toJson());

  //   if (titleController.text.isNotEmpty) {
  //     Category category = Category(title: titleController.text, content: json);
  //     context.read<CategoryProvider>().addCategory(category);
  //   }
  //   Navigator.of(context).pop();
  // }
}
