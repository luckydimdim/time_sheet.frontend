import 'package:converters/json_converter.dart';
import 'package:converters/reflector.dart';
import 'additional_data_model_base.dart';

/**
 * Модель шапки time sheet'a
 */
@reflectable
class AdditionalDataDefaultModel extends AdditionalDataModelBase {
  @override
  @Json(exclude: true)
  String type = 'default';
}