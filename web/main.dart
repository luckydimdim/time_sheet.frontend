import 'dart:core';

import 'package:angular2/platform/browser.dart';
import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:angular2/platform/common.dart';

import 'package:contracts/contracts_service.dart';
import 'package:http/http.dart';
import 'package:http/browser_client.dart';
import 'package:http_wrapper/http_wrapper.dart';

import 'package:auth/auth_service.dart';
import 'package:config/config_service.dart';
import 'package:alert/alert_service.dart';
import 'package:master_layout/master_layout_component.dart';
import 'package:aside/aside_service.dart';
import 'package:logger/logger_service.dart';

import 'package:time_sheet/time_sheet_component.dart';

@Component(
    selector: 'app',
    template: '<master-layout><time-sheet [timeSheetId]="\'26270cfa2422b2c4ebf158285e17cb17\'"></time-sheet></master-layout>',
    providers: const [
      ROUTER_PROVIDERS,
      const Provider(LocationStrategy, useClass: HashLocationStrategy)
    ],
    directives: const [
      MasterLayoutComponent,
      TimeSheetComponent
    ])
class AppComponent {}

main() async {
  await bootstrap(AppComponent, [
    ROUTER_PROVIDERS,
    const Provider(LocationStrategy, useClass: HashLocationStrategy),
    const Provider(AlertService),
    const Provider(AsideService),
    const Provider(LoggerService),
    const Provider(ConfigService),
    const Provider(AuthenticationService),
    const Provider(AuthorizationService),
    const Provider(ContractsService),

    provide(Client, useFactory: () => new BrowserClient(), deps: []),
    provide(HttpWrapper,
        useFactory: (_http, _authenticationService) =>
            new HttpWrapper(_http, _authenticationService),
        deps: [Client, AuthenticationService])
  ]);
}
