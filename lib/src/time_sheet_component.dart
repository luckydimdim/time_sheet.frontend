import 'dart:html';

import 'package:angular2/angular2.dart';
import 'package:angular2/core.dart';

import 'pipes/cm_week_day_pipe.dart';
import 'time_sheet_rate_component.dart';

@Component(
  selector: 'time-sheet',
  templateUrl: 'time_sheet_component.html',
  directives: const [TimeSheetRateComponent],
  pipes: const [
    CmWeekDayPipe
  ])
class TimeSheetComponent {
  List<DateTime> dates = new List<DateTime>();

  TimeSheetComponent() {
    // Первоначальная установка даты
    DateTime now = new DateTime.now();

    for (int dayIndex = 1; dayIndex <= 31; ++dayIndex) {
      dates.add(new DateTime(now.year, now.month, dayIndex));
    }
  }

  /**
   * Выбор даты из списка
   */
  void selectMonth(SelectElement date) {
    List<String> monthAndYear = date.value.split('.');

    int month = int.parse(monthAndYear.first, onError: (_) => 0);
    int year = int.parse(monthAndYear.last, onError: (_) => 0);

    DateTime newDate = new DateTime(year, month, 1);

    List<DateTime> tempDates = new List<DateTime>();

    for (int dayIndex = 1; dayIndex <= 31; ++dayIndex) {
      tempDates.add(new DateTime(newDate.year, newDate.month, dayIndex));
    }

    dates = tempDates;
  }
}