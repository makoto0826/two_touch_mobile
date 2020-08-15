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

  Future<Box<Information>> getInformationBox() async {
    Box box =
        await Hive.openBox<Information>(_InformationName, encryptionKey: _key);
    return box;
  }

  Future<Box<Setting>> getSettingBox() async {
    Box box = await Hive.openBox<Setting>(_SettingName, encryptionKey: _key);
    return box;
  }

  Future<Box<User>> getUserBox() async {
    Box box = await Hive.openBox<User>(_UserName, encryptionKey: _key);
    return box;
  }

  Future<Box<TimeRecord>> getTimeRecordBox() async {
    Box box =
        await Hive.openBox<TimeRecord>(_TimeRecordName, encryptionKey: _key);
    return box;
  }
}
