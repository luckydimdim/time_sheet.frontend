import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';
import 'package:converters/reflector.dart';

@reflectable
/**
 * Модель Time sheet'a для обновления информации
 */
class TimeSheetWriteModel extends Object with JsonConverter, MapConverter {
  // Внутренний id
  String id = '';

  // Месяц
  int month = 0;

  // Год
  int year = 0;

  // Примечания
  String notes = '';
}