// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cs214/constants/global_variables.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'bean.g.dart';

@HiveType(typeId: 3)
class Bean {
  @HiveField(0)
  final String nameBean;

  @HiveField(1)
  final List<String> beans;

  const Bean({
    required this.nameBean,
    this.beans = basicBean,
  });
}
