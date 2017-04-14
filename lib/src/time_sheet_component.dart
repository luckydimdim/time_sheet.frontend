import 'dart:html';

import 'package:angular2/angular2.dart';
import 'package:angular2/core.dart';

import 'time_sheet_service.dart';
import 'pipes/cm_week_day_pipe.dart';
import 'rate_group_component.dart';
import 'time_sheet_model.dart';
import 'rate_group_model.dart';

@Component(
    selector: 'time-sheet',
    templateUrl: 'time_sheet_component.html',
    directives: const [TimeSheetRateComponent],
    providers: const [TimeSheetService],
    pipes: const [CmWeekDayPipe])
class TimeSheetComponent implements OnInit {
  final TimeSheetService _service;

  // Набор дат для выбиралки
  List<DateTime> dates = new List<DateTime>();

  // Ставки и отработанное время, загруженные с сервера
  List<RateGroupModel> rateGroups = new List<RateGroupModel>();

  TimeSheetComponent(this._service) {
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

  @override
  /**
   * Загрузка time sheet'a с сервера
   */
  ngOnInit() async {
    String mockId = '26270cfa2422b2c4ebf158285e0e16fc';

    TimeSheetModel model = await _service.getTimeSheet(mockId);

    rateGroups = model.rateGroups;
  }
}