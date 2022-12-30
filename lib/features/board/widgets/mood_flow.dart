import 'package:diary_app/constants/app_colors.dart';
import 'package:diary_app/constants/app_styles.dart';
import 'package:diary_app/features/board/widgets/empty_mood_flow.dart';
import 'package:diary_app/features/diary/models/diary.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MoodFlow extends StatelessWidget {
  final int? month;
  final bool? isMonthly;
  final int? year;
  final int? numOfDays;
  final List<Diary> diaries;

  const MoodFlow({
    super.key,
    this.month,
    this.isMonthly = true,
    this.year,
    this.numOfDays,
    required this.diaries,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 10),
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.boxColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: diaries.isEmpty
          ? EmptyMoodFlow(
              isMonthly: isMonthly!,
              year: year!,
              month: month!,
            )
          : Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.moodFlow,
                    style: AppStyles.medium.copyWith(
                      color: AppColors.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: true,
                          drawHorizontalLine: false,
                          verticalInterval: 1,
                          getDrawingVerticalLine: (value) {
                            return FlLine(
                              color: AppColors.unNote,
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 1,
                              getTitlesWidget: bottomTitleWidgets,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: leftTitleWidgets,
                              reservedSize: 42,
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border(
                            left: BorderSide(width: 1, color: AppColors.unNote),
                            bottom:
                                BorderSide(width: 1, color: AppColors.unNote),
                          ),
                        ),
                        minX: 0,
                        maxX: isMonthly! ? (numOfDays == 31 ? 7 : 6) : 12,
                        minY: 0,
                        maxY: 6,
                        lineBarsData: [
                          LineChartBarData(
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (p0, p1, p2, p3) {
                                return FlDotCirclePainter(
                                  color: Colors.white,
                                  radius: 2,
                                  strokeWidth: 2,
                                  strokeColor: AppColors.selectedColor,
                                );
                              },
                            ),
                            spots: isMonthly!
                                ? createSpotsForMonthly(diaries)
                                : createSpotsForAnnualy(diaries),
                            color: AppColors.selectedColor,
                            barWidth: 5,
                            isStrokeCapRound: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  List<FlSpot> createSpotsForAnnualy(List<Diary> diariesAnnual) {
    List<FlSpot> spots = [];
    int dayTmp = 0;
    int i = 0;

    for (Diary diary in diariesAnnual) {
      int dayCreated = diary.createdAt.day;
      double x = dayCreated / 5 - 0.2;
      double y = diary.mood.getIndex();

      if (dayTmp == dayCreated) {
        --i;
        spots.removeAt(i);
      }

      spots.insert(i, FlSpot(x, y));
      dayTmp = dayCreated;
      i++;
    }

    return spots;
  }

  List<FlSpot> createSpotsForMonthly(List<Diary> diariesMonth) {
    List<FlSpot> spots = [];
    int dayTmp = 0;
    int i = 0;

    for (Diary diary in diariesMonth) {
      int dayCreated = diary.createdAt.day;
      double x = dayCreated / 5 - 0.2;
      double y = diary.mood.getIndex();

      if (dayTmp == dayCreated) {
        --i;
        spots.removeAt(i);
      }

      spots.insert(i, FlSpot(x, y));
      dayTmp = dayCreated;
      i++;
    }

    return spots;
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    TextStyle style = AppStyles.regular.copyWith(
      fontSize: 12,
      color: AppColors.textPrimaryColor,
    );
    late Widget text;

    if (isMonthly!) {
      if (numOfDays == 31) {
        List<String> days = [
          '$month/01',
          '$month/06',
          '$month/11',
          '$month/16',
          '$month/21',
          '$month/26',
          '$month/31',
          '',
        ];
        text = Text(days[value.toInt()], style: style);
      } else {
        List<String> days = [
          '$month/01',
          '$month/06',
          '$month/11',
          '$month/16',
          '$month/21',
          '$month/26',
          ''
        ];
        text = Text(days[value.toInt()], style: style);
      }
    } else {
      List<String> months = [
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9',
        '10',
        '11',
        '12',
        ''
      ];

      text = Text(months[value.toInt()], style: style);
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    Color colorMood;

    switch (value.toInt()) {
      case 1:
        colorMood = AppColors.mood5;
        break;
      case 2:
        colorMood = AppColors.mood4;
        break;
      case 3:
        colorMood = AppColors.mood3;
        break;
      case 4:
        colorMood = AppColors.mood2;
        break;
      case 5:
        colorMood = AppColors.mood1;
        break;
      default:
        return Container();
    }

    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorMood,
      ),
    );
  }
}
