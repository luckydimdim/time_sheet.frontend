import 'dart:html';

import 'package:angular2/angular2.dart';
import 'package:angular2/core.dart';

import 'package:angular2/router.dart';
import 'time_sheet_service.dart';
import 'pipes/cm_week_day_pipe.dart';
import 'rate_group_component.dart';
import 'time_sheet_model.dart';
import 'rate_group_model.dart';
import 'rate_model.dart';

@Component(
    selector: 'time-sheet',
    templateUrl: 'time_sheet_component.html',
    directives: const [TimeSheetRateComponent],
    providers: const [TimeSheetService],
    pipes: const [CmWeekDayPipe])
class TimeSheetComponent implements OnInit {
  static const DisplayName = const {'displayName': 'Табель учета рабочего времени'};

  final Router _router;
  final TimeSheetService _service;

  // Ставки и отработанное время, загруженные с сервера
  List<RateGroupModel> rateGroups = new List<RateGroupModel>();

  // Набор дат для выбиралки
  List<DateTime> dates = new List<DateTime>();

  // Модель time sheet'a
  TimeSheetModel model = null;

  TimeSheetComponent(this._service, this._router) {
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

    for (int dayIndex = 0; dayIndex <= 30; dayIndex++) {
      tempDates.add(new DateTime(newDate.year, newDate.month, dayIndex));
    }

    dates = tempDates;
  }

  @override
  /**
   * Загрузка time sheet'a с сервера
   */
  ngOnInit() async {
    Instruction ci = _router.parent.currentInstruction;
    String id = ci.component.params['id'];

    model = await _service.getTimeSheet(id);

    rateGroups = model.rateGroups;
  }

  /**
   * Обработка события обновления значения отработанного времени по ставке
   */
  void updateSpentTime(RateModel rate) {
    _service.updateSpentTime(model.id, rate);
  }
}