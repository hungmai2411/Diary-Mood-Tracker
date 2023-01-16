import 'package:cs214/features/diary/models/diary.dart';
import 'package:cs214/features/setting/models/setting.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DbHelper {
  Future<Box> openBox(String boxName) async {
    Box box = await Hive.openBox(boxName);

    return box;
  }

  List<Diary> getDiaries(Box box) => box.values.toList().cast<Diary>();

  //List<Category> getCategories(Box box) => box.values.toList().cast<Category>();

  Future<Diary> addDiary(Box box, Diary diary) async {
    int key = await box.add(diary);
    diary = diary.copyWith(key: key);
    await box.delete(key);
    await box.put(key, diary);
    return diary;
  }

  // Future<Category> addCategory(Box box, Category category) async {
  //   int key = await box.add(category);
  //   category = category.copyWith(key: key);
  //   await box.delete(key);
  //   await box.put(key, category);
  //   return category;
  // }

  Future<void> delete(Box box, int key) async => await box.delete(key);

  Future<void> editDiary(Box box, int key, Diary diary) async =>
      await box.put(key, diary);

  // Future<void> editCategory(Box box, int key, Category category) async =>
  //     await box.put(key, category);

  Future<void> addSetting(Box box, Setting setting) async =>
      await box.put('setting', setting);

  Setting getSetting(Box box) => box.get(
        'setting',
        defaultValue: Setting(),
      );
}
