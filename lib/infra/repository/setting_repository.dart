import 'package:hive/hive.dart';
import 'package:two_touch_mobile/model/model.dart';
import 'database.dart';

class SettingRepository {
  Database _db;

  SettingRepository({Database db}) {
    _db = db;
  }

  Future<Setting> get() async {
    final box = await _db.getSettingBox();
    final setting = box.get(0);
    await box.close();

    return setting;
  }

  Future<void> save(Setting setting) async {
    final box = await _db.getSettingBox();
    await box.put(0, setting);
    await box.close();
  }
}
