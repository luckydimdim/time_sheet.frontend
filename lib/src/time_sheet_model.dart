import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';
import 'package:converters/reflector.dart';

import 'additional_data/additional_data_model_base.dart';
import 'additional_data/additional_data_default_model.dart';
import 'additional_data/additional_data_south_tambey_model.dart';
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

  @Json(exclude: true)
  // Ставки
  List<RateGroupModel> rateGroups = new List<RateGroupModel>();

  @Json(exclude: true)
  // Модель шапки
  AdditionalDataModelBase additionalData = null;

  @override
  dynamic fromJson(dynamic json) {
    super.fromJson(json);

    for (dynamic rateGroupJson in json['rateGroups']) {
      rateGroups.add(new RateGroupModel().fromJson(rateGroupJson));
    }

    additionalData = _createAdditionalData(json['additionalData']);

    return this;
  }

  /**
   * Фабричный метод
   */
  AdditionalDataModelBase _createAdditionalData(dynamic json) {
    if (json == null)
      return null;

    AdditionalDataModelBase result;

    switch (json['type'].toString().toUpperCase()) {
      case 'DEFAULT':
        result = new AdditionalDataDefaultModel().fromJson(json);
        break;

      case 'SOUTHTAMBEY':
        result = new AdditionalDataSouthTambeyModel().fromJson(json);
        break;
    }

    return result;
  }
}