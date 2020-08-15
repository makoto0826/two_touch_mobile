import 'package:hive/hive.dart';
import 'package:two_touch_mobile/model/model.dart';

const _InformationName = 'information';
const _SettingName = 'setting';
const _TimeRecordName = 'time_record';
const _UserName = 'user';

class Database {
  static List<int> _key;

  static init(List<int> key) {
    _key = key;
  }

  Database() {
    if (_key == null) {
      throw new Exception('key not found');
    }
  }

  Future<LazyBox<Information>> getInformationBox() async {
    final box = await Hive.openLazyBox<Information>(_InformationName,
        encryptionKey: _key);
    return box;
  }

  Future<LazyBox<Setting>> getSettingBox() async {
    final box =
        await Hive.openLazyBox<Setting>(_SettingName, encryptionKey: _key);
    return box;
  }

  Future<LazyBox<User>> getUserBox() async {
    final box = Hive.openLazyBox<User>(_UserName, encryptionKey: _key);
    return box;
  }

  Future<LazyBox<TimeRecord>> getTimeRecordBox() async {
    final box = await Hive.openLazyBox<TimeRecord>(_TimeRecordName,
        encryptionKey: _key);
    return box;
  }
}
