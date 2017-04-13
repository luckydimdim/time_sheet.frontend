import 'package:angular2/angular2.dart';
import 'package:angular2/core.dart';

import 'package:angular2/src/facade/browser.dart';
import 'rate.dart';
import 'rate_group.dart';

@Component(
  selector: 'time-sheet-rate',
  templateUrl: 'rate_group_component.html')
class TimeSheetRateComponent {
  @Input()
  List<DateTime> dates = null;

  @Input()
  RateGroup rateGroup = null;

  /**
   * Добавить 1 к текущему значению ячейки
   */
  void add(MouseEvent e, String id, int dayIndex) {
    e.preventDefault();

    Rate rate = rateGroup.rates.firstWhere((item) => item.id == id);

    if (rate.spentTime[dayIndex] < 9)
      rate.spentTime[dayIndex] = rate.spentTime[dayIndex] + 1;
  }

  /**
   * Отнять 0.5 от текущего значения ячейки
   */
  void substract(MouseEvent e, String id, int dayIndex) {
    e.preventDefault();

    Rate rate = rateGroup.rates.firstWhere((item) => item.id == id);

    if (rate.spentTime[dayIndex] > 0) {
      rate.spentTime[dayIndex] = rate.spentTime[dayIndex] - 0.5;
    }
  }
}