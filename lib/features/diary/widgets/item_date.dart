import 'package:diary_app/constants/app_assets.dart';
import 'package:diary_app/constants/app_colors.dart';
import 'package:diary_app/constants/app_styles.dart';
import 'package:diary_app/features/board/widgets/mood_flow.dart';
import 'package:diary_app/features/diary/widgets/smile_painter.dart';
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
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          Text(
            date,
            style: isSelected!
                ? AppStyles.semibold.copyWith(
                    color: color,
                    fontSize: 14,
                  )
                : AppStyles.medium.copyWith(
                    color: color,
                    fontSize: 14,
                  ),
          ),
          const SizedBox(height: 2),
          img != null
              ? Expanded(
                  child: Image.asset(
                    img!,
                    fit: BoxFit.contain,
                    width: 50,
                    height: 50,
                  ),
                )
              : Expanded(
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
                ),
        ],
      ),
    );
  }
}
