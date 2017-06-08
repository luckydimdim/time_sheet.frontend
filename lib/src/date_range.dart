import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';
import 'package:converters/reflector.dart';

/**
 * Промежуток времени
 */
@reflectable
class DateRange extends Object with JsonConverter, MapConverter {
  DateTime min;

  DateTime max;
}
