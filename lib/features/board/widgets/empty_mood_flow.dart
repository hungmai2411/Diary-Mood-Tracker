import 'package:diary_app/constants/app_colors.dart';
import 'package:diary_app/constants/app_styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:quiver/time.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmptyMoodFlow extends StatelessWidget {
  final bool isMonthly;
  final int month;
  final int year;

  const EmptyMoodFlow({
    super.key,
    required this.isMonthly,
    required this.month,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    final int numOfDays = daysInMonth(year, month);

    return Stack(
      children: [
        Padding(
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
                          color: AppColors.moodBarEmptyPrimary,
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
                        left: BorderSide(
                            width: 1, color: AppColors.moodBarEmptyPrimary),
                        bottom: BorderSide(
                            width: 1, color: AppColors.moodBarEmptyPrimary),
                      ),
                    ),
                    minX: 0,
                    maxX: isMonthly ? (numOfDays == 31 ? 7 : 6) : 12,
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
                              strokeColor: AppColors.moodBarEmptyPrimary,
                            );
                          },
                        ),
                        spots: isMonthly
                            ? createSpotsForMonthly()
                            : createSpotsForAnnualy(),
                        color: AppColors.moodBarEmptyPrimary,
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
        Align(
          alignment: Alignment.center,
          child: Text(
            'No Record',
            style: AppStyles.medium.copyWith(
              color: AppColors.moodBarEmptySecondary,
            ),
          ),
        )
      ],
    );
  }

  List<FlSpot> createSpotsForAnnualy() {
    List<FlSpot> spots = [
      const FlSpot(0, 4),
      const FlSpot(2, 5),
      const FlSpot(6, 1),
      const FlSpot(11, 3),
    ];

    return spots;
  }

  List<FlSpot> createSpotsForMonthly() {
    final int numOfDays = daysInMonth(year, month);

    if (numOfDays == 31) {
      return [
        const FlSpot(0, 4),
        const FlSpot(2, 5),
        const FlSpot(4, 2),
        const FlSpot(6.5, 3),
      ];
    }
    List<FlSpot> spots = [
      const FlSpot(0, 4),
      const FlSpot(2, 5),
      const FlSpot(4, 2),
      const FlSpot(5.5, 3),
    ];

    return spots;
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final int numOfDays = daysInMonth(year, month);

    TextStyle style = AppStyles.regular.copyWith(fontSize: 12);
    late Widget text;

    if (isMonthly) {
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
