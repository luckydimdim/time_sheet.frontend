import 'dart:html';

import 'package:angular2/angular2.dart';
import 'package:angular2/core.dart';

import 'pipes/cm_week_day_pipe.dart';
import 'rate_group_component.dart';
import 'rate_group.dart';
import 'rate.dart';

@Component(
    selector: 'time-sheet',
    templateUrl: 'time_sheet_component.html',
    directives: const [TimeSheetRateComponent],
    pipes: const [CmWeekDayPipe])
class TimeSheetComponent {
  List<DateTime> dates = new List<DateTime>();
  List<RateGroup> rateGroups = new List<RateGroup>();

  TimeSheetComponent() {
    // Первоначальная установка даты
    DateTime now = new DateTime.now();

    for (int dayIndex = 1; dayIndex <= 31; ++dayIndex) {
      dates.add(new DateTime(now.year, now.month, dayIndex));
    }

    RateGroup rateGroup = new RateGroup()
      ..name = 'SERVICE PERFORMANCE / УСЛУГИ';

    Rate rate2 = new Rate()
      ..id = '2'
      ..name = 'Working days / Рабочие дни'
      ..spentTime.addAll([ 1, 0, 1, 0, 1, 1, 0, 1, 0,1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1]);

    Rate rate3 = new Rate()
      ..id = '3'
      ..name = 'Week-end / Выходные'
      ..spentTime.addAll([ 1, 0, 1, 0, 1, 1, 0, 1, 0,1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1]);

    Rate rate4 = new Rate()
      ..id = '4'
      ..name = 'Travel / Дни в пути'
      ..spentTime.addAll([ 1, 0, 1, 0, 1, 1, 0, 1, 0,1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1]);

    RateGroup rateGroup2 = new RateGroup();
    Rate rate5 = new Rate()
      ..id = '5'
      ..name = '123123123 123123123 123123123 123123123 123123123 123123123'
      ..spentTime.addAll([ 1, 0, 1, 0, 1, 1, 0, 1, 0,1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1]);

    rateGroup2.rates.add(rate5);

    rateGroup.rates.add(rate2);
    rateGroup.rates.add(rate3);
    rateGroup.rates.add(rate4);

    rateGroups.add(rateGroup);
    rateGroups.add(rateGroup2);
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
