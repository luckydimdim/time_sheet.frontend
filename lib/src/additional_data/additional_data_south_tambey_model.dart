import 'package:converters/reflector.dart';
import 'additional_data_model_base.dart';

/**
 * Модель шапки time sheet'a
 */
@reflectable
class AdditionalDataSouthTambeyModel extends AdditionalDataModelBase {
  @override
  /**
   * Тип модели
   */
  String type = 'SouthTambey';

  /**
   * Табельный номер
   */
  String employeeNumber = '';

  /**
   * Номер позиции
   */
  String positionNumber = '';

  /**
   * Происхождение персонала
   */
  String personnelSource = '';

  /**
   * Номер PAAF
   */
  String paaf = '';

  /**
   * Ссылка плана мобилизации
   */
  String mobPlanReference = '';

  /**
   * Дата мобилизации
   */
  String mobDate = '';
}