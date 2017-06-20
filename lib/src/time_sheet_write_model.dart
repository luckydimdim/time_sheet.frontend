import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';
import 'package:converters/reflector.dart';

import 'rate_model.dart';

@reflectable
/**
 * Модель Time sheet'a для обновления информации
 */
class TimeSheetWriteModel extends Object with JsonConverter, MapConverter {
  // Внутренний id
  String id = '';

  // с
  DateTime from = null;

  // по
  DateTime till = null;

  // Примечания
  String notes = '';

  // Ставки
  @Json(exclude: true)
  List<RateModel> rates = new List<RateModel>();

  @override
  Map toJson() {
    var result = super.toJson();

    var list = new List<Map>();

    for (RateModel rate in rates) {
      list.add(rate.toJson());
    }

    result['rates'] = list;

    return result;
  }
}
