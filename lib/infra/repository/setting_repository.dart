import 'package:hive/hive.dart';
import 'package:two_touch_mobile/model/model.dart';
import 'database.dart';

class SettingRepository {
  Database _db;

  SettingRepository({Database db}) {
    _db = db;
  }

  Future<Setting> get() async {
    Box<Setting> box = await _db.getSettingBox();
    return box.get(0);
  }

  Future<void> save(Setting setting) async {
    Box<Setting> box = await _db.getSettingBox();
    await box.put(0, setting);
  }
}
