import 'package:two_touch_mobile/extensions/date_time_extensions.dart';
import 'package:two_touch_mobile/model/model.dart';
import 'database.dart';

class TimeRecordRepository {
  Database _db;

  TimeRecordRepository({Database db}) {
    _db = db;
  }

  Future<List<TimeRecord>> findAll() async {
    final box = await _db.getTimeRecordBox();
    List<TimeRecord> timeRecords = [];

    for (final key in box.keys) {
      TimeRecord timeRecord = await box.get(key);

      if (timeRecord != null) {
        timeRecords.add(timeRecord);
      }
    }

    return timeRecords;
  }

  Future<TimeRecord> findById(String id) async {
    final box = await _db.getTimeRecordBox();
    final timeRecord = box.get(id);

    return timeRecord;
  }

  Future<List<TimeRecord>> findByStatus(TimeRecordStatus status) async {
    final allTimeRecords = await findAll();
    final timeRecords =
        allTimeRecords.where((record) => record.status == status).toList();

    return timeRecords;
  }

  Future<List<TimeRecord>> findByLessThanUpdatedAt(DateTime updatedAt) async {
    final allTimeRecords = await findAll();

    final timeRecords = allTimeRecords.where((record) {
      final epoch = record.updatedAt.toYmd().microsecondsSinceEpoch;
      return updatedAt.microsecondsSinceEpoch > epoch;
    }).toList();

    return timeRecords;
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
    final box = await _db.getTimeRecordBox();
    await box.put(record.localTimeRecordId, record);
  }
}
