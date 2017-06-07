import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:angular2/core.dart';
import 'package:config/config_service.dart';
import 'package:http_wrapper/http_wrapper.dart';
import 'package:http_wrapper/exceptions.dart';
import 'package:logger/logger_service.dart';

import 'time_sheet_model.dart';
import 'attachment_model.dart';
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
    _logger
        .trace('Getting time sheets. Url: ${ _config.helper.timeSheetsUrl }');

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

    _logger.trace(
        'Getting time sheet. Url: ${ _config.helper.timeSheetsUrl }/$id');

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
   * Получение вложений (без данных)
   */
  Future<List<AttachmentModel>> getAttachments(String timeSheetId) async {
    Response response = null;

    var result = new List<AttachmentModel>();

    _logger.trace('Getting time sheet attachments. Url: ${ _config.helper
            .timeSheetsUrl }/$timeSheetId/attachments');

    try {
      response = await _http.get(
          '${ _config.helper.timeSheetsUrl }/$timeSheetId/attachments',
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      _logger.error('Failed to get time sheet attachments: $e');

      rethrow;
    }

    _logger.trace('Time sheet attachments requested: $response.');

    dynamic jsonArray = JSON.decode(response.body);

    for (var jsonAttachment in jsonArray) {
      result.add(new AttachmentModel().fromJson(jsonAttachment));
    }

    return result;
  }

  /**
   * Добавить вложение
   */
  Future addAttachment(String timeSheetId, File file) async {
    Response response = null;

    var url = _config.helper.timeSheetsUrl + '/$timeSheetId/attachment';

    _logger.trace('adding attachment ${ file.name }');

    var arrayBuffer = await _readAsArrayBuffer(file);

    var splittedType = file.type.split('/');

    MediaType mediaType = new MediaType(splittedType[0], splittedType[1]);

    try {
      var request = new MultipartRequest("POST", Uri.parse(url));
      MultipartFile multipartFile = new MultipartFile.fromBytes(
          'File', arrayBuffer,
          filename: file.name, contentType: mediaType);
      request.files.add(multipartFile);

      response = await _http.sendMultipartRequest(request);
      _logger.trace('attachment added');
    } catch (e) {
      print('Failed to add attachment: $e');
      rethrow;
    }
  }

  Future<dynamic> _readAsArrayBuffer(File file) {
    var completer = new Completer();

    var reader = new FileReader();

    reader.onLoad.listen((e) {
      completer.complete(reader.result);
    });

    reader.readAsArrayBuffer(file);
    return completer.future;
  }

  /**
   * Удалить вложение
   */
  Future deleteAttachment(String timeSheetId, String fileName) async {
    String url =
        '${ _config.helper.timeSheetsUrl }/$timeSheetId/attachment/$fileName';

    _logger.trace('Removing attachment. Url: $url');

    try {
      await _http.delete(url, headers: {'Content-Type': 'application/json'});
      _logger.trace('attachment $fileName removed');
    } catch (e) {
      _logger.error('Failed to remove attachment: $e');

      rethrow;
    }
  }

  /**
   * Загрузить вложение (с данными)
   */
  Future<Blob> getAttachment(String timeSheetId, String fileName) async {
    Response response = null;

    var url =
        _config.helper.timeSheetsUrl + '/$timeSheetId/attachment/$fileName';

    _logger.trace('download attachment ${ fileName}');

    try {
      response =
          await _http.get(url, headers: {'Content-Type': 'application/json'});
    } catch (e) {
      _logger.error('Failed to download attachments: $e');

      rethrow;
    }

    _logger.trace('Time sheet attachments downloaded');

    var type = response.headers['content-type'];
    var result = new Blob([response.bodyBytes], type, 'native');

    return result;
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
  }

  /**
   * Удаление time sheet'a
   */
  deleteRequest(String id) async {
    _logger.trace(
        'Removing time sheet. Url: ${ _config.helper.timeSheetsUrl }/$id');

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
    _logger.trace('Updating spent time. Url: ${ _config.helper
            .timeSheetsUrl }/$id/spent-time');

    try {
      await _http.put('${ _config.helper.timeSheetsUrl }/$id/spent-time',
          headers: {'Content-Type': 'application/json'},
          body: model.toJsonString());
      _logger.trace('Time sheet spent time successfuly updated');
    } on ConflictError catch (e) {
      // FIXME: обрабатывать данную ситуацию
      _logger.warning('conflict while updating spent time... ');
    } catch (e) {
      _logger.error('Failed to update time sheet spent time: $e');

      rethrow;
    }
  }

  /**
   * Смена статуса
   */
  updateStatus(String id, String status) async {
    _logger.trace(
        'Updating status. Url: ${ _config.helper.timeSheetsUrl }/$id/status');

    try {
      await _http.put('${ _config.helper.timeSheetsUrl }/$id/status',
          headers: {'Content-Type': 'application/json'},
          body: '{"Status":"$status"}');
      _logger.trace('Time sheet status successfuly updated');
    } catch (e) {
      _logger.error('Failed to update time sheet status: $e');

      rethrow;
    }
  }
}
