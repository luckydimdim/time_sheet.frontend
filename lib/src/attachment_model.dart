import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';
import 'package:converters/reflector.dart';

@reflectable
/**
 * Вложение
 */
class AttachmentModel extends Object with JsonConverter, MapConverter {
  // наименование вложения
  String name = '';

  // тип вложения
  @Json(name: 'content_type')
  String contentType = '';

  // размер в байтах
  int length = 0;
}
