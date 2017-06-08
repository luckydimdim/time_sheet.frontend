import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';
import 'package:converters/reflector.dart';

import 'rate_utils.dart';
import 'rate_unit.dart';

@reflectable
/**
 * Ставка
 */
class RateModel extends Object with JsonConverter, MapConverter {
  String id = '';

  // Имя ставки
  String name = '';

  // Ед. измерения
  @Json(exclude: true)
  RateUnit unit;

  // Отработанные часы / дни
  // (порядковый номер элемента массива равняется числу месяца)
  List<num> spentTime = new List<num>();

  /**
   * Сумма отработанного времени за месяц
   */
  num getSummary() {
    if (spentTime.length > 0)
      return spentTime.reduce((a, b) => a + b);
    else
      return 0;
  }

  String get unitName => RateUtils.getUnitName(unit);

  @override
  dynamic fromJson(dynamic json) {
    super.fromJson(json);

    unit = RateUtils.convertFromInt(json['unit']);

    return this;
  }

  @override
  Map toJson() {
    var map = super.toJson();

    map['unit'] = RateUtils.convertToInt(unit);

    return map;
  }
}
