import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';
import 'package:converters/reflector.dart';

import 'rate_group_model.dart';

@reflectable
/**
 * Модель Time sheet'a
 */
class TimeSheetModel extends Object with JsonConverter, MapConverter {
  // Внутренний id
  String id = '';

  // id наряд-заказа
  String callOffOrderId = '';

  // Месяц
  int month = 0;

  // Год
  int year = 0;

  // Дата создания
  DateTime createdAt = null;

  // Дата послежнего обновления
  DateTime updatedAt = null;

  // Наименование услуги
  String workName = '';

  // Суммарная стоимость time sheet'a
  num amount = 0;

  // Примечания
  String notes = '';

  // Ставки
  @Json(exclude: true)
  List<RateGroupModel> rateGroups = new List<RateGroupModel>();

  @override
  dynamic fromJson(dynamic json) {
    super.fromJson(json);

    for (dynamic rateGroupJson in json['rateGroups']) {
      rateGroups.add(new RateGroupModel().fromJson(rateGroupJson));
    }

    return this;
  }
}