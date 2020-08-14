import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:two_touch_mobile/infra/infra.dart';
import 'package:two_touch_mobile/model/model.dart';
import 'package:two_touch_mobile/worker.dart';

final Provider<TimeCardSelectController> timeCardSelectProvider = Provider((ref) {
  final repository = ref.read(timeRecordRepositoryProvider);

  final controller = TimeCardSelectController(repository: repository);
  return controller;
});

class TimeCardSelectController {
  TimeRecordRepository _repository;

  TimeCardSelectController({TimeRecordRepository repository}) {
    _repository = repository;
  }

  Future<void> save({User user, String card, TimeRecordType type}) async {
    final timeRecord = TimeRecord.create(
      userId: user.userId,
      userName: user.userName,
      card: card,
      type: type,
    );

    await _repository.save(timeRecord);

    appendTimeRecordWorkerQueue(timeRecord.localTimeRecordId);
  }
}
