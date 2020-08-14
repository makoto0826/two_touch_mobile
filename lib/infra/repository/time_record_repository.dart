import 'package:hive/hive.dart';
import 'package:two_touch_mobile/extensions/date_time_extensions.dart';
import 'package:two_touch_mobile/model/model.dart';
import 'database.dart';

class TimeRecordRepository {
  Database _db;

  TimeRecordRepository({Database db}) {
    _db = db;
  }

  Future<TimeRecord> findById(String id) async {
    final box = await _db.getTimeRecordBox();
    return box.get(id);
  }

  Future<List<TimeRecord>> findByStatus(TimeRecordStatus status) async {
    final box = await _db.getTimeRecordBox();
    final records =
        box.values.where((record) => record.status == status).toList();

    return records;
  }

  Future<List<TimeRecord>> findByLessThanUpdatedAt(DateTime updatedAt) async {
    final box = await _db.getTimeRecordBox();

    final records = box.values.where((record) {
      final epoch = record.updatedAt.toYmd().microsecondsSinceEpoch;
      return updatedAt.microsecondsSinceEpoch > epoch;
    }).toList();

    return records;
  }

  Future<void> delete(String localTimeRecordId) async {
    final box = await _db.getTimeRecordBox();
    await box.delete(localTimeRecordId);
  }

  Future<void> deleteAll(List<String> localTimeRecordIds) async {
    final box = await _db.getTimeRecordBox();
    box.deleteAll(localTimeRecordIds);
  }

  Future<void> save(TimeRecord record) async {
    Box<TimeRecord> box = await _db.getTimeRecordBox();
    await box.put(record.localTimeRecordId, record);
  }
}
