import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';
import 'package:converters/reflector.dart';

/**
 * Базовая модель шапки time sheet'a.
 * Нужна для обощения работы с web-сервисом.
 */
@reflectable
abstract class AdditionalDataModelBase extends Object
    with JsonConverter, MapConverter {
  /**
   * Тип модели
   */
  @Json(exclude: true)
  String type = '';

  /**
   * ФИО работника
   */
  String assignee = '';

  /**
   * Наименование услуги
   */
  String name = '';

  /**
   * Номер наряд-заказа
   */
  String number = '';

  /**
   * Дата начала действия наряд-заказа
   */
  String startDate = '';

  /**
   * Дата окончания действия наряд-заказа
   */
  String finishDate = '';

  /**
   * Должность
   */
  String position = '';

  /**
   * Место работы
   */
  String location = '';
}
