import 'package:cs214/constants/app_assets.dart';
import 'package:cs214/constants/app_colors.dart';
import 'package:cs214/constants/app_styles.dart';
import 'package:cs214/features/board/widgets/mood_flow.dart';
import 'package:cs214/features/diary/widgets/smile_painter.dart';
import 'package:flutter/material.dart';

class ItemDate extends StatelessWidget {
  final String date;
  final Color color;
  final String? img;
  bool? isSelected;

  ItemDate({
    super.key,
    required this.date,
    this.img,
    this.color = Colors.black,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: isSelected!
                  ? AppColors.selectedColor
                  : AppColors.backgroundColor,
            ),
            child: Text(
              date,
              style: AppStyles.regular.copyWith(
                color: isSelected! ? AppColors.backgroundColor : color,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 2),
          img != null
              ? Expanded(
                  child: Image.asset(
                    img!,
                    fit: BoxFit.contain,
                  ),
                )
              : _buildItemNoRecord(),
        ],
      ),
    );
  }
}

Widget _buildItemNoRecord() {
  return Expanded(
    child: SizedBox(
      height: 43,
      width: 43,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.unNote,
            ),
          ),
          CustomPaint(
            painter: SmilePainter(),
            child: Container(),
          )
        ],
      ),
    ),
  );
}
