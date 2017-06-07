import 'package:angular2/angular2.dart';
import 'package:angular2/core.dart';
import 'dart:async';
import 'dart:html';

import 'package:angular2/router.dart';

import 'package:angular_utils/directives.dart';
import 'package:angular_utils/cm_week_day_pipe.dart';

import 'package:auth/auth_service.dart';
import 'time_sheet_service.dart';
import 'time_sheet_period.dart';
import 'rate_group_component.dart';
import 'time_sheet_model.dart';
import 'rate_group_model.dart';
import 'rate_model.dart';
import 'additional_data/additional_data_default_component.dart';
import 'additional_data/additional_data_south_tambey_component.dart';
import 'time_sheet_write_model.dart';
import 'package:daterangepicker/daterangepicker.dart';
import 'package:daterangepicker/daterangepicker_directive.dart';
import 'package:aside/aside_service.dart';
import 'package:aside/pane_types.dart';

@Component(
    selector: 'time-sheet',
    templateUrl: 'time_sheet_component.html',
    directives: const [
      TimeSheetRateComponent,
      AdditionalDataDefaultComponent,
      AdditionalDataSouthTambeyComponent,
      CmRouterLink,
      DateRangePickerDirective
    ],
    providers: const [
      TimeSheetService
    ],
    pipes: const [
      CmWeekDayPipe
    ])
class TimeSheetComponent implements OnInit, OnDestroy {
  static const DisplayName = const {
    'displayName': 'Табель учета рабочего времени'
  };

  DateRangePickerOptions dateRangePickerOptions = new DateRangePickerOptions();

  @Input()
  String timeSheetId = null;

  @ViewChild(DateRangePickerDirective)
  DateRangePickerDirective periodControl;

  bool readOnly = true;
  String statusSysName = '';

  final Router _router;
  final TimeSheetService _service;
  final AuthorizationService _authorizationService;
  final AsideService _asideService;

  // Ставки и отработанное время, загруженные с сервера
  List<RateGroupModel> rateGroups = new List<RateGroupModel>();

  // Набор дат для таблицы
  List<DateTime> dates = new List<DateTime>();

  // Модель time sheet'a
  TimeSheetModel model;

  TimeSheetComponent(this._service, this._router, this._authorizationService,
      this._asideService) {
    // Первоначальная установка даты
    DateTime now = new DateTime.now();

    for (int dayIndex = 1; dayIndex <= 31; ++dayIndex) {
      dates.add(new DateTime(now.year, now.month, dayIndex));
    }

    var locale = new DateRangePickerLocale()
      ..format = 'DD.MM.YYYY'
      ..separator = ' - '
      ..applyLabel = 'Применить'
      ..cancelLabel = 'Отменить'
      ..fromLabel = 'С'
      ..toLabel = 'По'
      ..customRangeLabel = 'Custom'
      ..weekLabel = 'W'
      ..firstDay = 1
      ..daysOfWeek = ['Вс', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб']
      ..monthNames = [
        'Январь',
        'Февраль',
        'Март',
        'Апрель',
        'Май',
        'Июнь',
        'Июль',
        'Август',
        'Сентябрь',
        'Октябрь',
        'Ноябрь',
        'Декабрь'
      ];

    dateRangePickerOptions = new DateRangePickerOptions()
      ..locale = locale
      ..dateLimit = new DateLimit(days: 30)
      ..opens = 'left';
  }

  /**
   * Обновление сроков
   */
  Future datesSelected(Map<String, DateTime> value) async {
    bool filled = false;
    model.rateGroups.forEach((rg) {
      rg.rates.forEach((r) {
        if (r.spentTime.any((t) => t > 0)) {
          filled = true;
        }
      });
    });

    model.from = value['start'];
    model.till = value['end'];

    // Установка выбранной даты
    if (model.from != null && model.till != null) {
      dates = _buildDates(model.from, model.till);
    }

    await updateModel();

    await _loadData();
  }

  /**
   *
   */
  Future updateModel() async {
    // Отправка данных на сервер
    var writeModel = new TimeSheetWriteModel()
      ..id = model.id
      ..from = model.from
      ..till = model.till
      ..notes = model.notes;

    await _service.updateTimeSheet(writeModel);
  }

  /**
   * Сгенерировать массив дней в указанном месяце и году
   */
  List<DateTime> _buildDates(DateTime from, DateTime till) {
    List<DateTime> result = new List<DateTime>();

    var fromTmp = new DateTime(from.year, from.month, from.day);

    for (int i = 1; i <= 31; i++) {
      result.add(fromTmp);
      fromTmp = fromTmp.add(new Duration(days: 1));
    }

    return result;
  }

  /**
   * Проверяет попадание указанного дня в период табеля
   */
  bool inPeriod(DateTime day) {
    if (model.from == null || model.till == null) return false;

    if (day.compareTo(model.from) >= 0 && day.compareTo(model.till) <= 0)
      return true;

    return false;
  }

  /**
   * Получить имя месяца
   */
  String _getMonthName(int month) {
    switch (month) {
      case DateTime.JANUARY:
        return 'Январь';
      case DateTime.FEBRUARY:
        return 'Февраль';
      case DateTime.MARCH:
        return 'Март';
      case DateTime.APRIL:
        return 'Апрель';
      case DateTime.MAY:
        return 'Май';
      case DateTime.JUNE:
        return 'Июнь';
      case DateTime.JULY:
        return 'Июль';
      case DateTime.AUGUST:
        return 'Август';
      case DateTime.SEPTEMBER:
        return 'Сентябрь';
      case DateTime.OCTOBER:
        return 'Октябрь';
      case DateTime.NOVEMBER:
        return 'Ноябрь';
      case DateTime.DECEMBER:
        return 'Декабрь';
      default:
        return '??';
    }
  }

  @override
  /**
   * Загрузка time sheet'a с сервера
   */
  ngOnInit() async {
    await _loadData();

    _asideService.addPane(PaneType.attachments,
        {'disabled': readOnly, 'timeSheetId': timeSheetId});
  }

  _loadData() async {
    // Просьба здесь не использовать подмену ID, т.к. часто этот код попадает в основной репозиторий
    // Предлагаю использовать main.dart и input - timeSheetId

    if (timeSheetId == null) {
      // в Input не передали. Пробуем вытащить из url
      Instruction ci = _router.parent?.currentInstruction;

      if (ci == null) return;

      timeSheetId = ci.component.params['id'];
    }

    model = await _service.getTimeSheet(timeSheetId);

    rateGroups = model.rateGroups;

    // Установка выбранной даты
    if (model.from != null && model.till != null) {
      dates = _buildDates(model.from, model.till);
    }

    statusSysName = model.statusSysName.toUpperCase();

    if (statusSysName == 'APPROVED' ||
        statusSysName == 'APPROVING' ||
        statusSysName == 'CREATED' ||
        statusSysName == 'CORRECTED') {
      readOnly = true;
    } else {
      readOnly = false;
    }

    dateRangePickerOptions.minDate = model.callOffOrderStartDateStr;
    dateRangePickerOptions.maxDate = model.callOffOrderFinishDateStr;
  }

  /**
   * Обработка события обновления значения отработанного времени по ставке
   */
  Future updateSpentTime(RateModel rate) async {
    await _service.updateSpentTime(model.id, rate);
  }

  Map<String, bool> controlStateClasses(NgControl control) => {
        'ng-dirty': control.dirty ?? false,
        'ng-pristine': control.pristine ?? false,
        'ng-touched': control.touched ?? false,
        'ng-untouched': control.untouched ?? false,
        'ng-valid': control.valid ?? false,
        'ng-invalid': control.valid == false
      };

  /**
   * Завершить редактирование
   */
  complete() async {
    try {
      if (statusSysName == 'EMPTY' || statusSysName == 'CREATING')
        await _service.updateStatus(model.id, 'CREATED');
      else if (statusSysName == 'CORRECTING')
        await _service.updateStatus(model.id, 'CORRECTED');
      else
        throw new Exception('incorrect status: $statusSysName');
    } catch (e) {
      await _loadData();

      rethrow;
    }
    _router.navigate(['../RequestView']);
  }

  /**
   * Редактировать
   */
  edit() async {
    try {
      if (statusSysName == 'CREATED')
        await _service.updateStatus(model.id, 'CREATING');
      else if (statusSysName == 'CORRECTED')
        await _service.updateStatus(model.id, 'CORRECTING');
      else
        throw new Exception('incorrect status: $statusSysName');
    } catch (e) {
      await _loadData();
      rethrow;
    }

    await _loadData();
  }

  /**
   * Отправить на исправление
   */
  correct() async {
    try {
      if (statusSysName == 'APPROVING')
        await _service.updateStatus(model.id, 'CORRECTING');
      else
        throw new Exception('incorrect status: $statusSysName');
    } catch (e) {
      await _loadData();
      rethrow;
    }

    _router.navigate(['../RequestView']);
  }

  /**
   * Одобрить табель
   */
  approve() async {
    try {
      if (statusSysName == 'APPROVING')
        await _service.updateStatus(model.id, 'APPROVED');
      else
        throw new Exception('incorrect status: $statusSysName');
    } catch (e) {
      await _loadData();
      rethrow;
    }

    _router.navigate(['../RequestView']);
  }

  /**
   * Подставляет нужный css класс в столбце со статусами
   */
  Map<String, bool> resolveStatusStyleClass(String statusSysName) {
    Map<String, bool> result = new Map<String, bool>();

    String status = statusSysName.toUpperCase();

    switch (status) {
      case 'EMPTY':
        result['tag-default'] = true;
        break;
      case 'CREATED':
      case 'CORRECTED':
        result['tag-primary'] = true;
        break;
      case 'APPROVING':
        result['tag-warning'] = true;
        break;
      case 'APPROVED':
        result['tag-success'] = true;
        break;
      case 'CORRECTING':
        result['tag-danger'] = true;
        break;
      default:
        result['tag-info'] = true;
    }

    return result;
  }

  bool isCustomer() {
    return _authorizationService.isInRole(Role.Customer);
  }

  String getDates() {
    String result = '';

    if (model.from != null && model.till != null)
      result = '${model.fromStr} - ${model.tillStr}';

    if (model.from == null && model.till == null) result = '';

    if (model.from == null) result = model.tillStr;

    if (model.till == null) result = model.fromStr;

    return result;
  }

  toogleAttachmentsPane() {
    _asideService.togglePane();
  }

  @override
  ngOnDestroy() {
    _asideService.removePane(PaneType.attachments);
  }
}
