import 'rate.dart';

/**
 * Группа ставок
 */
class RateGroup {
  String id = '';

  // Имя группы
  String name = '';

  // Ставки
  List<Rate> rates = new List<Rate>();
}