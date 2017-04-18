import 'package:angular2/angular2.dart';
import 'package:angular2/core.dart';

import 'package:angular2/router.dart';

import 'time_sheet_service.dart';
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
      AdditionalDataSouthTambeyComponent
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
  List<Period> periods = new List<Period>();

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
  void updateModel(NgForm ngForm) {
    List<String> monthAndYear = selectedPeriod.split('.');

    int month = int.parse(monthAndYear.first, onError: (_) => 0);
    int year = int.parse(monthAndYear.last, onError: (_) => 0);

    DateTime newDate = new DateTime(year, month, 1);

    List<DateTime> tempDates = new List<DateTime>();

    for (int dayIndex = 1; dayIndex <= 31; ++dayIndex) {
      tempDates.add(new DateTime(newDate.year, newDate.month, dayIndex));
    }

    dates = tempDates;

    // Отправка данных на сервер
    var writeModel = new TimeSheetWriteModel()
      ..id = model.id
      ..month = newDate.month
      ..year = newDate.year
      ..notes = model.notes;
    _service.updateTimeSheet(writeModel);
  }

  /**
   * Обработка события обновления значения отработанного времени по ставке
   */

  @override
  /**
   * Загрузка time sheet'a с сервера
   */
  ngOnInit() async {
    Instruction ci = _router.parent?.currentInstruction;

    String id = '26270cfa2422b2c4ebf158285e0fb6b6';

    if (ci == null) {
      //String id = ci.component.params['id'];

      model = await _service.getTimeSheet(id);

      rateGroups = model.rateGroups;

      // TODO: загружать период с сервера
      periods.add(new Period('1.2017', 'Январь 2017'));
      periods.add(new Period('2.2017', 'Февраль 2017'));
      periods.add(new Period('3.2017', 'Март 2017'));
      periods.add(new Period('4.2017', 'Апрель 2017'));
      periods.add(new Period('5.2017', 'Май 2017'));
      periods.add(new Period('6.2017', 'Июнь 2017'));
      periods.add(new Period('7.2017', 'Июль 2017'));
      periods.add(new Period('8.2017', 'Август 2017'));
      periods.add(new Period('9.2017', 'Сентябрь 2017'));
      periods.add(new Period('10.2017', 'Октябрь 2017'));
      periods.add(new Period('11.2017', 'Ноябрь 2017'));
      periods.add(new Period('12.2017', 'Декабрь 2017'));

      // Установка выбранной даты
      if (model.month != null && model.month != ''
        && model.year != null && model.year != '') {
        selectedPeriod = '${model.month}.${model.year}';
      }
    }
  }
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

class Period {
  final String name;
  final String value;

  Period(this.value, this.name);
}