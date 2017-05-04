import 'package:angular2/angular2.dart';
import 'package:angular2/core.dart';

import 'additional_data_default_model.dart';

@Component(
    selector: 'additional-data-default',
    templateUrl: 'additional_data_default_component.html')
class AdditionalDataDefaultComponent {
  @Input()
  AdditionalDataDefaultModel model = new AdditionalDataDefaultModel();
}
