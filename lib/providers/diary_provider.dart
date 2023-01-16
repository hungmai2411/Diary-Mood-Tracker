import 'package:cs214/features/diary/models/diary.dart';
import 'package:cs214/services/db_helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DiaryProvider extends ChangeNotifier {
  List<Diary> _diaries = [];
  List<Diary> get diaries => _diaries;
  final DbHelper dbHelper = DbHelper();

  void setDiaries(List<Diary> diaries) {
    print('diaries: $diaries');
    _diaries = diaries;
    notifyListeners();
  }

  void addDiary(Diary diary) async {
    final box = await dbHelper.openBox("diaries");

    Diary newDiary = await dbHelper.addDiary(box, diary);

    _diaries.add(newDiary);
    notifyListeners();
  }

  void deleteDiary(Diary diary) async {
    final box = await dbHelper.openBox("diaries");
    await dbHelper.delete(box, diary.key!);

    for (var d in _diaries) {
      if (diary.key == d.key) {
        _diaries.remove(d);
        break;
      }
    }
    notifyListeners();
  }

  void editDiary(
    Diary diary,
    String? mood,
    String? content,
    List<Uint8List>? images,
  ) async {
    for (var d in _diaries) {
      if (diary.key == d.key) {
        _diaries.remove(d);
        break;
      }
    }

    final box = await dbHelper.openBox("diaries");

    diary = diary.copyWith(
      content: content,
      images: images,
      mood: mood,
    );
    _diaries.add(diary);
    await dbHelper.editDiary(box, diary.key!, diary);

    notifyListeners();
  }
}
