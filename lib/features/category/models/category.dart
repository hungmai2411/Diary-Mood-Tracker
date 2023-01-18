// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive_flutter/hive_flutter.dart';
part 'category.g.dart';

@HiveType(typeId: 4)
class Category {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final int? key;

  Category({
    required this.title,
    required this.content,
    this.key,
  });

  Category copyWith({
    String? content,
    String? title,
    int? key,
  }) {
    return Category(
      content: content ?? this.content,
      title: title ?? this.title,
      key: key ?? this.key,
    );
  }
}
