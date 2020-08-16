import 'package:two_touch_mobile/model/model.dart';
import 'database.dart';

class InformationRepository {
  Database _db;

  InformationRepository({Database db}) {
    _db = db;
  }

  Future<Information> get() async {
    final box = await _db.getInformationBox();
    final information = await box.get(0);
    await box.close();

    return information;
  }

  Future<void> save(Information information) async {
    final box = await _db.getInformationBox();
    await box.put(0, information);
    await box.close();
  }
}
