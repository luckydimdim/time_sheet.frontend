import 'package:angular2/angular2.dart';
import 'package:angular2/core.dart';

import 'package:angular2/router.dart';

import 'package:angular_utils/directives.dart';

import 'time_sheet_service.dart';
import 'time_sheet_period.dart';
import 'pipes/cm_week_day_pipe.dart';
import 'rate_group_component.dart';
import 'time_sheet_model.dart';
import 'rate_group_model.dart';
import 'rate_model.dart';
import 'additional_data/additional_data_default_component.dart';
import 'additional_data/additional_data_south_tambey_component.dart';
import 'time_sheet_write_model.dart';

@Component(
    selector: 'time-sheet',
    templateUrl: 'time_sheet_component.html',
    directives: const [
      TimeSheetRateComponent,
      AdditionalDataDefaultComponent,
      AdditionalDataSouthTambeyComponent,
      CmRouterLink
    ],
    providers: const [
      TimeSheetService
    ],
    pipes: const [
      CmWeekDayPipe
    ])
class TimeSheetComponent implements OnInit {
  static const DisplayName = const {
    'displayName': 'Табель учета рабочего времени'
  };

  final Router _router;
  final TimeSheetService _service;

  // Ставки и отработанное время, загруженные с сервера
  List<RateGroupModel> rateGroups = new List<RateGroupModel>();

  // Набор дат для таблицы
  List<DateTime> dates = new List<DateTime>();

  // Выбранный месяц и год
  String selectedPeriod = '';
  List<TimeSheetPeriod> periods = new List<TimeSheetPeriod>();

  // Модель time sheet'a
  TimeSheetModel model = new TimeSheetModel();

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
  void updateModel(dynamic formValues) {
    List<String> monthAndYear = formValues['period'].split('.');

    int month = int.parse(monthAndYear.first, onError: (_) => 0);
    int year = int.parse(monthAndYear.last, onError: (_) => 0);

    dates = _buildDates(month, year);

    // Отправка данных на сервер
    var writeModel = new TimeSheetWriteModel()
      ..id = model.id
      ..month = month
      ..year = year
      ..notes = model.notes;
    _service.updateTimeSheet(writeModel);
  }

  /**
   * Сгенерировать массив дней в указанном месяце и году
   */
  List<DateTime> _buildDates( int month, int year) {
    List<DateTime> result = new List<DateTime>();

    DateTime newDate = new DateTime(year, month, 1);

    for (int dayIndex = 1; dayIndex <= 31; ++dayIndex) {
      result.add(new DateTime(newDate.year, newDate.month, dayIndex));
    }

    return result;
  }

  /**
   * Получить имя месяца
   */
  String _getMonthName(int month) {
    switch (month) {
      case DateTime.JANUARY:
        return "Январь";
      case DateTime.FEBRUARY:
        return "Февраль";
      case DateTime.MARCH:
        return "Март";
      case DateTime.APRIL:
        return "Апрель";
      case DateTime.MAY:
        return "Май";
      case DateTime.JUNE:
        return "Июнь";
      case DateTime.JULY:
        return "Июль";
      case DateTime.AUGUST:
        return "Август";
      case DateTime.SEPTEMBER:
        return "Сентябрь";
      case DateTime.OCTOBER:
        return "Октябрь";
      case DateTime.NOVEMBER:
        return "Ноябрь";
      case DateTime.DECEMBER:
        return "Декабрь";
      default:
        return "??";
    }
  }

  /**
   * Построить список доступных периодов
   * Период табеля может отсутствовать в диапазоне доступных для выбора дат, возвращенных с бэкенда (from - to),
   * поэтому принудительно включаем его (includeMonth + includeYear)
   */
  List<TimeSheetPeriod> _buildPeriod(DateTime from, DateTime to, int includeMonth, int includeYear ) {
    var result = new List<TimeSheetPeriod>();

    if (from == null || to == null) return result;

    int fromMonth = from.month;
    int fromYear = from.year;

    var value = '${includeMonth}.${includeYear}';
    var name = '${_getMonthName(includeMonth)} ${includeYear}';

    result.add(new TimeSheetPeriod(name, value));

    do {
      var value = '${fromMonth}.${fromYear}';
      var name = '${_getMonthName(fromMonth)} ${fromYear}';

      if (includeMonth != fromMonth || includeYear != fromYear ) {
        result.add(new TimeSheetPeriod(name, value));
      }

      if (fromMonth == 12) {
        fromMonth = 1;
        fromYear++;
      } else {
        fromMonth++;
      }
    } while (fromYear <= to.year && fromMonth <= to.month);

    return result;
  }

  @override
  /**
   * Загрузка time sheet'a с сервера
   */
  ngOnInit() async {
    Instruction ci = _router.parent?.currentInstruction;

    //String id = '26270cfa2422b2c4ebf158285e1523d3';

     if (ci != null) {
      String id = ci.component.params['id'];

      model = await _service.getTimeSheet(id);

      rateGroups = model.rateGroups;

      periods = _buildPeriod(model.availablePeriodsFrom, model.availablePeriodsTo, model.month, model.year);

      // Установка выбранной даты
      if (model.month != null &&
          model.month != '' &&
          model.year != null &&
          model.year != '') {
        selectedPeriod = '${model.month}.${model.year}';

        dates = _buildDates(model.month, model.year);
      }


    }
  }

  /**
   * Обработка события обновления значения отработанного времени по ставке
   */
  void updateSpentTime(RateModel rate) {
    _service.updateSpentTime(model.id, rate);
  }

  Map<String, bool> controlStateClasses(NgControl control) => {
        'ng-dirty': control.dirty ?? false,
        'ng-pristine': control.pristine ?? false,
        'ng-touched': control.touched ?? false,
        'ng-untouched': control.untouched ?? false,
        'ng-valid': control.valid ?? false,
        'ng-invalid': control.valid == false
      };
}
