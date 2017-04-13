import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:angular2/core.dart';
import 'package:config/config_service.dart';
import 'package:logger/logger_service.dart';

/**
 * Работа с web-сервисом. Раздел "Time Sheet"
 */
@Injectable()
class TimeSheetService {
  final Client _http;
  final ConfigService _config;
  LoggerService _logger;

  TimeSheetService(this._http, this._config) {
    _logger = new LoggerService(_config);
  }
}
