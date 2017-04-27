import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:angular2/core.dart';
import 'package:config/config_service.dart';
import 'package:http_wrapper/http_wrapper.dart';
import 'package:logger/logger_service.dart';

import 'time_sheet_model.dart';
import 'time_sheet_write_model.dart';
import 'rate_model.dart';

/**
 * Работа с web-сервисом. Раздел "Time Sheet"
 */
@Injectable()
class TimeSheetService {
  final HttpWrapper _http;
  final ConfigService _config;
  LoggerService _logger;

  TimeSheetService(this._http, this._config) {
    _logger = new LoggerService(_config);
  }

  /**
   * Получение списка time sheet'ов
   */
  Future<List<TimeSheetModel>> getTimeSheets() async {
    _logger.trace('Getting time sheets. Url: ${ _config.helper.timeSheetsUrl }');

    Response response = null;

    try {
      response = await _http.get(_config.helper.timeSheetsUrl,
        headers: {'Content-Type': 'application/json'});
    } catch (e) {
      _logger.error('Failed to get time sheets: $e');

      rethrow;
    }

    _logger.trace('Time sheets requested: $response.');

    dynamic json = JSON.decode(response.body);

    var result = new List<TimeSheetModel>();

    for (dynamic request in json) {
      TimeSheetModel model = new TimeSheetModel().fromJson(request);
      result.add(model);
    }

    return result;
  }

  /**
   * Получение одного time sheet'a по его id
   */
  Future<TimeSheetModel> getTimeSheet(String id) async {
    Response response = null;

    _logger.trace('Getting time sheet. Url: ${ _config.helper.timeSheetsUrl }/$id');

    try {
      response = await _http.get('${ _config.helper.timeSheetsUrl }/$id',
        headers: {'Content-Type': 'application/json'});
    } catch (e) {
      _logger.error('Failed to get time sheet: $e');

      rethrow;
    }

    _logger.trace('Time sheet requested: $response.');

    dynamic json = JSON.decode(response.body);

    return new TimeSheetModel().fromJson(json);
  }

  /**
   * Создание нового time sheet'a
   */
  Future<TimeSheetModel> createRequest(TimeSheetModel model) async {
    Response response = null;

    _logger.trace('Creating time sheet ${ model.toJson() }');

    try {
      response = await _http.post(_config.helper.timeSheetsUrl,
        body: model.toJsonString(),
        headers: {'Content-Type': 'application/json'});

      _logger.trace('Time sheet created');
    } catch (e) {
      print('Failed to compose request: $e');

      rethrow;
    }

    dynamic json = JSON.decode(response.body);

    return new TimeSheetModel().fromJson(json);
  }

  /**
   * Изменение time sheet'a
   */
  updateTimeSheet(TimeSheetWriteModel model) async {
    Response response = null;

    _logger.trace('Updating time sheet ${ model.toJson() }');

    try {
      response = await _http.put(
        '${ _config.helper.timeSheetsUrl }/${ model.id }',
        body: model.toJsonString(),
        headers: {'Content-Type': 'application/json'});
      _logger.trace('Time sheet ${ model.id } successfuly updated');
    } catch (e) {
      _logger.error('Failed to update time sheet: $e');

      rethrow;
    }

    dynamic json = JSON.decode(response.body);

    return new TimeSheetWriteModel().fromJson(json);
  }

  /**
   * Удаление time sheet'a
   */
  deleteRequest(String id) async {
    _logger.trace('Removing time sheet. Url: ${ _config.helper.timeSheetsUrl }/$id');

    try {
      await _http.delete('${ _config.helper.timeSheetsUrl }/$id',
        headers: {'Content-Type': 'application/json'});
      _logger.trace('Time sheet $id removed');
    } catch (e) {
      _logger.error('Failed to remove time sheet: $e');

      rethrow;
    }
  }

  /**
   * Обновление отработанного времени
   */
  updateSpentTime(String id, RateModel model) async {
    _logger.trace('Updating spent time. Url: ${ _config.helper.timeSheetsUrl }/$id/spent-time');

    try {
      await _http.put('${ _config.helper.timeSheetsUrl }/$id/spent-time',
        headers: {'Content-Type': 'application/json'},
        body: model.toJsonString());
      _logger.trace('Time sheet spent time successfuly updated');
    } catch (e) {
      _logger.error('Failed to update time sheet spent time: $e');

      rethrow;
    }
  }
}