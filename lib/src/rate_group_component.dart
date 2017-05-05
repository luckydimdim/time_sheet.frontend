import 'dart:html';
import 'package:angular2/angular2.dart';
import 'package:angular2/core.dart';

import 'package:angular_utils/cm_spent_time_pipe.dart';

import 'rate_model.dart';
import 'rate_group_model.dart';

@Component(
    selector: 'time-sheet-rate',
    templateUrl: 'rate_group_component.html',
    pipes: const [CmSpentTimePipe])
class TimeSheetRateComponent {
  @Input()
  List<DateTime> dates = null;

  @Input()
  RateGroupModel rateGroup = null;

  @Input()
  bool readOnly = true;

  @Output()
  /**
   * Событие обновления значения отработанного времени по ставке
   */
  dynamic updateSpentTime = new EventEmitter<RateModel>();

  /**
   * Добавить 1 к текущему значению ячейки
   */
  void add(MouseEvent e, String id, int dayIndex) {
    e.preventDefault();

    if (readOnly) return;

    RateModel rate = rateGroup.rates.firstWhere((item) => item.id == id);

    _normalizeSpentTimeLength(rate);

    if (rate.spentTime[dayIndex] >= 99) return;

    rate.spentTime[dayIndex] = rate.spentTime[dayIndex] + 1;

    updateSpentTime.emit(rate);
  }

  /**
   * Отнять 0.5 от текущего значения ячейки
   */
  void substract(MouseEvent e, String id, int dayIndex) {
    e.preventDefault();

    if (readOnly) return;

    RateModel rate = rateGroup.rates.firstWhere((item) => item.id == id);

    if (rate.spentTime[dayIndex] <= 0) return;

    rate.spentTime[dayIndex] = rate.spentTime[dayIndex] - 0.5;

    updateSpentTime.emit(rate);
  }

  /**
   * Добавляет недостающие элементы массива
   */
  void _normalizeSpentTimeLength(RateModel rate) {
    if (rate.spentTime.length < dates.length) {
      for (int i = rate.spentTime.length; i <= dates.length - 1; ++i) {
        rate.spentTime.add(0);
      }
    }
  }
}
