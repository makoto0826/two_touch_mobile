import 'package:two_touch_mobile/model/model.dart';
import 'database.dart';

class InformationRepository {
  Database _db;

  InformationRepository({Database db}) {
    _db = db;
  }

  Future<Information> get() async {
    final box = await _db.getInformationBox();
    final information = box.get(0);
    return information;
  }

  Future<void> save(Information information) async {
    final box = await _db.getInformationBox();
    await box.put(0, information);
  }
}
