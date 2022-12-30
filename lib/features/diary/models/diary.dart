// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:hive_flutter/hive_flutter.dart';

part 'diary.g.dart';

@HiveType(typeId: 0)
class Diary {
  @HiveField(0)
  final String mood;

  @HiveField(1)
  final String? content;

  @HiveField(2)
  final List<Uint8List>? images;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final int? key;

  Diary({
    required this.mood,
    required this.createdAt,
    this.content,
    this.images,
    this.key,
  });

  Diary copyWith({
    String? mood,
    String? content,
    List<Uint8List>? images,
    DateTime? createdAt,
    int? key,
  }) {
    return Diary(
      mood: mood ?? this.mood,
      createdAt: createdAt ?? this.createdAt,
      content: content ?? this.content,
      images: images ?? this.images,
      key: key ?? this.key,
    );
  }

  double getIndex() {
    switch (mood) {
      case 'Mood1':
        return 5;
      case 'Mood2':
        return 4;
      case 'Mood3':
        return 3;
      case 'Mood4':
        return 2;
      default:
        return 1;
    }
  }
}
