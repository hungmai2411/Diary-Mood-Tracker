import 'package:cs214/services/db_helpers.dart';
import 'package:flutter/material.dart';

import '../features/category/models/category.dart';

class CategoryProvider extends ChangeNotifier {
  List<Category> _categories = [];
  List<Category> get categories => _categories;
  final DbHelper dbHelper = DbHelper();

  void setCategories(List<Category> categories) {
    _categories = categories;
    notifyListeners();
  }

  void addCategory(Category category) async {
    final box = await dbHelper.openBox("categories");

    Category newCategory = await dbHelper.addCategory(box, category);
    _categories.add(newCategory);
    notifyListeners();
  }

  void deleteCategory(Category category) async {
    final box = await dbHelper.openBox("categories");
    await dbHelper.delete(box, category.key!);

    for (var c in _categories) {
      if (c.key == category.key) {
        _categories.remove(c);
        break;
      }
    }
    notifyListeners();
  }

  void editCategory(
    Category category,
    String title,
    String content,
  ) async {
    for (var c in _categories) {
      if (category.key == c.key) {
        _categories.remove(category);
        break;
      }
    }

    final box = await dbHelper.openBox("categories");

    category = category.copyWith(
      title: title,
      content: content,
    );
    _categories.add(category);
    await dbHelper.editCategory(box, category.key!, category);

    notifyListeners();
  }
}
