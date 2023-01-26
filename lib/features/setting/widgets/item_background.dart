import 'package:cs214/constants/app_colors.dart';
import 'package:cs214/constants/app_styles.dart';
import 'package:cs214/features/setting/models/setting.dart';
import 'package:cs214/providers/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemBackground extends StatelessWidget {
  final Color color;
  final String background;
  final String backgroundSelected;

  const ItemBackground({
    super.key,
    required this.color,
    required this.background,
    required this.backgroundSelected,
  });

  @override
  Widget build(BuildContext context) {
    final settingProvider =
        Provider.of<SettingProvider>(context, listen: false);
    Setting setting = settingProvider.setting;
    String locale = setting.language == 'English' ? 'en' : 'vi';

    String backgroundTmp = background;
    if (locale == 'vi') {
      if (backgroundTmp == 'Tối') {
        backgroundTmp = 'Dark mode';
      } else if (backgroundTmp == 'Sáng') {
        backgroundTmp = 'Light mode';
      } else {
        backgroundTmp = 'System mode';
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        backgroundTmp == 'System mode'
            ? Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                  border: backgroundSelected == backgroundTmp
                      ? Border.all(
                          color: AppColors.selectedColor,
                          width: 3,
                        )
                      : null,
                ),
                child: CustomPaint(
                  painter: SystemModePainter(),
                ),
              )
            : Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                  border: backgroundSelected == backgroundTmp
                      ? Border.all(
                          color: AppColors.selectedColor,
                          width: 3,
                        )
                      : null,
                ),
              ),
        const SizedBox(height: 5),
        Text(
          background,
          style: AppStyles.regular.copyWith(
            color: AppColors.textPrimaryColor,
          ),
        ),
      ],
    );
  }
}

class SystemModePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.white;

    final path = getTrianglePath(size.width, size.height);

    canvas.drawPath(
      path,
      paint,
    );
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(x, 0)
      ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
