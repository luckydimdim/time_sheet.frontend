import 'package:angular2/angular2.dart';

@Pipe(name: 'cmWeekDay')
/**
 * Пайпа для преобразования числовых значений к названию дня недели
 */
class CmWeekDayPipe extends PipeTransform {
  String transform(num value) => parseWeekDay(value);

  String parseWeekDay(num value) {
    String result = '';

    switch(value) {
      case 1:
        result = 'пн';
        break;
      case 2:
        result = 'вт';
        break;
      case 3:
        result = 'ср';
        break;
      case 4:
        result = 'чт';
        break;
      case 5:
        result = 'пт';
        break;
      case 6:
        result = 'сб';
        break;
      case 7:
        result = 'вс';
        break;
      default:
        result = 'n/a';
        break;
    }

    return result;
  }
}
