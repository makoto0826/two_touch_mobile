import 'package:hive/hive.dart';
import 'package:two_touch_mobile/model/model.dart';
import 'database.dart';

class InformationRepository {
  Database _db;

  InformationRepository({Database db}) {
    _db = db;
  }

  Future<Information> get() async {
    Box<Information> box = await _db.getInformationBox();
    return box.get(0);
  }

  Future<void> save(Information information) async {
    Box<Information> box = await _db.getInformationBox();
    await box.put(0, information);
  }
}
