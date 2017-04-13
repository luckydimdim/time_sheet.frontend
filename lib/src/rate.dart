/**
 * Ставка
 */
class Rate {
  String id = '';

  // Имя ставки
  String name = '';

  // Отработанные часы / дни
  // (порядковый номер элемента массива равняется числу месяца)
  List<num> spentTime = new List<num>();

  // Сумма отработанного времени за месяц
  num getSummary() {
    return spentTime.reduce((a, b) => a + b);
  }
}