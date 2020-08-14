import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:two_touch_mobile/infra/repository/database.dart';
import 'package:two_touch_mobile/model/model.dart';

export 'database.dart';
export './information_repository.dart';
export './setting_repository.dart';
export './user_repository.dart';
export './time_record_repository.dart';

final _storage = FlutterSecureStorage();

Future<void> initializeHive() async {
  await Hive.initFlutter("data");

  Hive
    ..registerAdapter(SettingAdapter())
    ..registerAdapter(UserAdapter())
    ..registerAdapter(TimeRecordAdapter())
    ..registerAdapter(TimeRecordTypeAdapter())
    ..registerAdapter(TimeRecordStatusAdapter())
    ..registerAdapter(InformationAdapter())
    ..registerAdapter(VersionAdapter());

  const HiveKey = 'hive';
  String stringKey = await _storage.read(key: HiveKey);

  if (stringKey == null) {
    final key = Hive.generateSecureKey();
    stringKey = _toString(key);
    
    await _storage.write(key: HiveKey, value: stringKey);
  }

  Database.init(_toList(stringKey));
}

String _toString(List<int> key) {
  String result = '';

  for (final c in key) {
    result += '$c,';
  }

  return result;
}

List<int> _toList(String key) {
  List<int> result = [];

  for (final c in key.split(',')) {
    if (c.isNotEmpty) {
      result.add(int.parse(c));
    }
  }

  return result;
}
