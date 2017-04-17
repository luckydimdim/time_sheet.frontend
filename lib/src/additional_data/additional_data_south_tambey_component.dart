import 'package:angular2/angular2.dart';
import 'package:angular2/core.dart';

import 'additional_data_south_tambey_model.dart';

@Component(
  selector: 'additional-data-south-tambey',
  templateUrl: 'additional_data_south_tambey_component.html')
class AdditionalDataSouthTambeyComponent {

  @Input()
  AdditionalDataSouthTambeyModel model = new AdditionalDataSouthTambeyModel();
}