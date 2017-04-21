import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';
import 'package:converters/reflector.dart';

import 'rate_model.dart';

@reflectable
/**
 * Группа ставок
 */
class RateGroupModel extends Object with JsonConverter, MapConverter {
  // Имя группы
  String name = '';

  // Ед. измерения
  String unitName = '';

  // Ставки
  @Json(exclude: true)
  List<RateModel> rates = new List<RateModel>();

  @override
  dynamic fromJson(dynamic json) {
    super.fromJson(json);

    for (dynamic rateJson in json['rates']) {
      rates.add(new RateModel().fromJson(rateJson));
    }

    return this;
  }
}