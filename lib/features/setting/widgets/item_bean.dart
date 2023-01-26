import 'dart:ui';

import 'package:cs214/constants/app_colors.dart';
import 'package:cs214/constants/bean.dart';
import 'package:cs214/widgets/box.dart';
import 'package:flutter/material.dart';

class ItemBean extends StatelessWidget {
  final Bean bean;
  final Bean beanSelected;

  const ItemBean({
    super.key,
    required this.bean,
    required this.beanSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Box(
      margin: const EdgeInsets.only(bottom: 10),
      border: bean.nameBean == beanSelected.nameBean
          ? Border.all(
              color: AppColors.selectedColor,
              width: 3,
            )
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: bean.beans
            .map(
              (e) => Image.asset(
                e,
                width: 60,
                height: 60,
              ),
            )
            .toList(),
      ),
    );
  }
}
