import 'package:carousel_slider/carousel_slider.dart';
import 'package:cs214/constants/app_colors.dart';
import 'package:cs214/constants/app_styles.dart';
import 'package:cs214/constants/bean.dart';
import 'package:cs214/features/setting/models/setting.dart';
import 'package:cs214/features/setting/screens/theme_store_screen.dart';
import 'package:cs214/features/setting/widgets/item_background.dart';
import 'package:cs214/features/setting/widgets/item_bean.dart';
import 'package:cs214/providers/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SelectThemeScreen extends StatefulWidget {
  const SelectThemeScreen({super.key});
  static const String routeName = '/select_theme_screen';
  @override
  State<SelectThemeScreen> createState() => _SelectThemeScreenState();
}

class _SelectThemeScreenState extends State<SelectThemeScreen> {
  final CarouselController controller = CarouselController();
  late String background;
  late Bean beanSelected;

  @override
  void initState() {
    super.initState();
    getBackground();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getBackground() {
    final settingProvider = context.read<SettingProvider>();
    Setting setting = settingProvider.setting;
    background = setting.background;
    beanSelected = setting.bean;
  }

  setTheme() {
    final settingProvider = context.read<SettingProvider>();
    Setting setting = settingProvider.setting;
    setting = setting.copyWith(
      bean: beanSelected,
      background: background,
    );

    if (background == 'System mode') {
      var brightness = MediaQuery.of(context).platformBrightness;
      bool isDarkMode = brightness == Brightness.dark;
      background = isDarkMode ? 'Dark mode' : 'Light mode';
    }
    AppColors.changeTheme(background);
    settingProvider.setSetting(setting);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = context.watch<SettingProvider>();
    Setting setting = settingProvider.setting;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appbarColor,
        elevation: 0.3,
        automaticallyImplyLeading: false,
        title: Text(
          AppLocalizations.of(context)!.changeTheme,
          style: AppStyles.medium.copyWith(
            fontSize: 18,
            color: AppColors.textPrimaryColor,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.textPrimaryColor,
            size: 21,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, ThemeStoreScreen.routeName);
            },
            icon: Icon(
              Icons.add_shopping_cart_outlined,
              color: AppColors.textPrimaryColor,
              size: 21,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.background,
              style: AppStyles.medium.copyWith(
                color: AppColors.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      background = 'System mode';
                    });
                  },
                  child: ItemBackground(
                    backgroundSelected: background,
                    color: AppColors.textPrimaryColor,
                    background: AppLocalizations.of(context)!.systemMode,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      background = 'Dark mode';
                    });
                  },
                  child: ItemBackground(
                    backgroundSelected: background,
                    color: Colors.black,
                    background: AppLocalizations.of(context)!.darkMode,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      background = 'Light mode';
                    });
                  },
                  child: ItemBackground(
                    backgroundSelected: background,
                    color: Colors.white,
                    background: AppLocalizations.of(context)!.lightMode,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              'Beans',
              style: AppStyles.medium.copyWith(
                color: AppColors.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: setting.myBeans
                  .map(
                    (e) => GestureDetector(
                      onTap: () {
                        setState(() {
                          beanSelected = e;
                        });
                      },
                      child: ItemBean(
                        bean: e,
                        beanSelected: beanSelected,
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.appbarColor,
        child: GestureDetector(
          onTap: setTheme,
          child: Container(
            height: 68,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.selectedColor,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              AppLocalizations.of(context)!.apply,
              style: AppStyles.semibold.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
