import 'package:another_flushbar/flushbar.dart';
import 'package:cs214/constants/app_colors.dart';
import 'package:cs214/constants/app_styles.dart';
import 'package:cs214/providers/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

showSnackBar(BuildContext context, String content) {
  final size = MediaQuery.of(context).size;

  Flushbar(
    maxWidth: size.width * .8,
    borderRadius: BorderRadius.circular(10),
    backgroundColor: AppColors.trackSelectedColor,
    flushbarPosition: FlushbarPosition.TOP,
    messageColor: const Color(0xFF1D1E2C),
    messageSize: 16,
    message: content,
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    icon: Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryColor,
      ),
      child: const Icon(
        Icons.check,
        size: 20.0,
        color: Colors.white,
      ),
    ),
    duration: const Duration(seconds: 3),
  ).show(context);
}

Future capture(GlobalKey? key) async {
  if (key == null) return null;

  // Tìm object theo key.
  RenderRepaintBoundary? boundary =
      key.currentContext!.findRenderObject() as RenderRepaintBoundary;

  // Capture object dưới dạng hình ảnh.
  final image = await boundary.toImage(pixelRatio: 3);

  // Chuyển đối tượng hình ảnh đó sang ByteData theo format của png.
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

  // Chuyển ByteData sang Uint8List.
  final pngBytes = byteData!.buffer.asUint8List();

  return pngBytes;
}

const baseSpacing = Tuple2<double, double>(6, 0);

DefaultStyles getDefaultStyles(BuildContext context) {
  SettingProvider settingProvider = context.read<SettingProvider>();
  String background = settingProvider.setting.background;
  if (background == 'System mode') {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    background = isDarkMode ? 'Dark mode' : 'Light mode';
  }

  return DefaultStyles(
    h1: DefaultTextBlockStyle(
      AppStyles.regular.copyWith(
        fontSize: 34,
        color: background == 'Light mode'
            ? const Color(0xFF1D1E2C)
            : const Color(0xFFE2E2E2),
        height: 1.15,
        fontWeight: FontWeight.w300,
        decoration: TextDecoration.none,
      ),
      const Tuple2(16, 0),
      const Tuple2(0, 0),
      null,
    ),
    h2: DefaultTextBlockStyle(
      AppStyles.regular.copyWith(
        fontSize: 24,
        color: background == 'Light mode'
            ? const Color(0xFF1D1E2C)
            : const Color(0xFFE2E2E2),
        height: 1.15,
        fontWeight: FontWeight.normal,
        decoration: TextDecoration.none,
      ),
      const Tuple2(8, 0),
      const Tuple2(0, 0),
      null,
    ),
    h3: DefaultTextBlockStyle(
      AppStyles.regular.copyWith(
        fontSize: 20,
        color: background == 'Light mode'
            ? const Color(0xFF1D1E2C)
            : const Color(0xFFE2E2E2),
        height: 1.25,
        fontWeight: FontWeight.w500,
        decoration: TextDecoration.none,
      ),
      const Tuple2(8, 0),
      const Tuple2(0, 0),
      null,
    ),
    paragraph: DefaultTextBlockStyle(
      AppStyles.regular.copyWith(
        color: background == 'Light mode'
            ? const Color(0xFF1D1E2C)
            : const Color(0xFFE2E2E2),
      ),
      const Tuple2(0, 0),
      const Tuple2(0, 0),
      null,
    ),
    bold: TextStyle(
      fontWeight: FontWeight.bold,
      color: background == 'Light mode'
          ? const Color(0xFF1D1E2C)
          : const Color(0xFFE2E2E2),
    ),
    italic: TextStyle(
      fontStyle: FontStyle.italic,
      color: background == 'Light mode'
          ? const Color(0xFF1D1E2C)
          : const Color(0xFFE2E2E2),
    ),
    small: TextStyle(
      fontSize: 12,
      color: background == 'Light mode'
          ? const Color(0xFF1D1E2C)
          : const Color(0xFFE2E2E2),
    ),
    underline: TextStyle(
      decoration: TextDecoration.underline,
      color: background == 'Light mode'
          ? const Color(0xFF1D1E2C)
          : const Color(0xFFE2E2E2),
    ),
    strikeThrough: TextStyle(
      decoration: TextDecoration.lineThrough,
      color: background == 'Light mode'
          ? const Color(0xFF1D1E2C)
          : const Color(0xFFE2E2E2),
    ),
    inlineCode: InlineCodeStyle(
      backgroundColor: Colors.grey.shade100,
      radius: const Radius.circular(3),
      style: AppStyles.regular,
      header1: AppStyles.regular.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w300,
        color: background == 'Light mode'
            ? const Color(0xFF1D1E2C)
            : const Color(0xFFE2E2E2),
      ),
      header2: AppStyles.regular.copyWith(
        fontSize: 22,
        color: background == 'Light mode'
            ? const Color(0xFF1D1E2C)
            : const Color(0xFFE2E2E2),
      ),
      header3: AppStyles.regular.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: background == 'Light mode'
            ? const Color(0xFF1D1E2C)
            : const Color(0xFFE2E2E2),
      ),
    ),
    link: TextStyle(
      color: background == 'Light mode'
          ? const Color(0xFF1D1E2C)
          : const Color(0xFFE2E2E2),
      decoration: TextDecoration.underline,
    ),
    placeHolder: DefaultTextBlockStyle(
      AppStyles.regular.copyWith(
        height: 1.5,
        color: background == 'Light mode'
            ? const Color(0xFF1D1E2C)
            : const Color(0xFFE2E2E2),
      ),
      const Tuple2(0, 0),
      const Tuple2(0, 0),
      null,
    ),
    lists: DefaultListBlockStyle(
      AppStyles.regular.copyWith(
        color: background == 'Light mode'
            ? const Color(0xFF1D1E2C)
            : const Color(0xFFE2E2E2),
      ),
      baseSpacing,
      const Tuple2(0, 6),
      null,
      null,
    ),
    quote: DefaultTextBlockStyle(
      TextStyle(
        color: background == 'Light mode'
            ? const Color(0xFF1D1E2C)
            : const Color(0xFFE2E2E2),
      ),
      baseSpacing,
      const Tuple2(6, 2),
      BoxDecoration(
        border: Border(
          left: BorderSide(width: 4, color: Colors.grey.shade300),
        ),
      ),
    ),
    code: DefaultTextBlockStyle(
      TextStyle(
        color: Colors.blue.shade900.withOpacity(0.9),
        //fontFamily: fontFamily,
        fontSize: 13,
        height: 1.15,
      ),
      baseSpacing,
      const Tuple2(0, 0),
      BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(2),
      ),
    ),
    indent: DefaultTextBlockStyle(
        AppStyles.regular, baseSpacing, const Tuple2(0, 6), null),
    align: DefaultTextBlockStyle(
        AppStyles.regular, const Tuple2(0, 0), const Tuple2(0, 0), null),
    leading: DefaultTextBlockStyle(
        AppStyles.regular, const Tuple2(0, 0), const Tuple2(0, 0), null),
    sizeSmall: TextStyle(
      fontSize: 10,
      color: background == 'Light mode'
          ? const Color(0xFF1D1E2C)
          : const Color(0xFFE2E2E2),
    ),
    sizeLarge: TextStyle(
      fontSize: 18,
      color: background == 'Light mode'
          ? const Color(0xFF1D1E2C)
          : const Color(0xFFE2E2E2),
    ),
    sizeHuge: TextStyle(
      fontSize: 22,
      color: background == 'Light mode'
          ? const Color(0xFF1D1E2C)
          : const Color(0xFFE2E2E2),
    ),
  );
}
