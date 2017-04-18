import 'package:angular2/angular2.dart';

@Pipe(name: 'cmSpentTime')
/**
 * Пайпа для округления дробных числовых значений к 1 знаку после запятой
 * и целочисленных - до целого числа
 */
class CmSpentTimePipe extends PipeTransform {
  String transform(num value, [bool hideZero = false]) => convertSpentTime(value, hideZero);

  String convertSpentTime(num value, bool hideZero) {
    String result = '';

    if (hideZero && (value == 0 || value == 0.0))
      return '';

    if (value.toString().endsWith('.0'))
      result = value.round().toString();
    else
      result = value.toString();

    return result;
  }
}
