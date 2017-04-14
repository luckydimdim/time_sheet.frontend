import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';
import 'package:converters/reflector.dart';

@reflectable
/**
 * Ставка
 */
class RateModel extends Object with JsonConverter, MapConverter {
  String id = '';

  // Имя ставки
  String name = '';

  // Отработанные часы / дни
  // (порядковый номер элемента массива равняется числу месяца)
  List<num> spentTime = new List<num>();

  // Сумма отработанного времени за месяц
  num getSummary() {
    if (spentTime.length > 0)
      return spentTime.reduce((a, b) => a + b);
    else
      return 0;
  }
}