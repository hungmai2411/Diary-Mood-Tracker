import 'package:cs214/constants/app_colors.dart';
import 'package:cs214/constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomAppBar extends StatefulWidget {
  final ScrollController scrollController;

  const CustomAppBar({
    super.key,
    required this.scrollController,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool isAppbarCollapsing = false;
  @override
  void initState() {
    super.initState();

    _initializeController();
  }

  @override
  void dispose() {
    super.dispose();
    widget.scrollController.dispose();
  }

  void _initializeController() {
    widget.scrollController.addListener(() {
      if (widget.scrollController.offset == 0.0 &&
          !widget.scrollController.position.outOfRange) {
        //Fully expanded situation
        if (!mounted) return;
        setState(() => isAppbarCollapsing = false);
      }
      if (widget.scrollController.offset >= 9.0 &&
          !widget.scrollController.position.outOfRange) {
        print('collapse');
        //Collapsing situation
        if (!mounted) return;
        setState(() => isAppbarCollapsing = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.appbarColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Text(
        AppLocalizations.of(context)!.settingTab,
        style: AppStyles.medium.copyWith(fontSize: 18),
      ),
    );
  }
}
