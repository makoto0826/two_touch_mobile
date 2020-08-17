import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:workmanager/workmanager.dart';
import 'package:logger/logger.dart';
import 'package:two_touch_mobile/extensions/date_time_extensions.dart';
import 'package:two_touch_mobile/infra/infra.dart';
import 'package:two_touch_mobile/model/model.dart';

const InformationPeriodicTaskName = 'information-periodic';
const InformationTaskName = 'information';
const AddTimeRecordPeriodicTaskName = 'add-time-record-periodic';
const AddTimeRecordTaskName = 'add-time-record';
const DeleteTimeRecordPeriodicTaskName = 'delete-time-record-periodic';

final _owner = ProviderStateOwner();

final _logger = Logger(
  printer: PrettyPrinter(),
);

Future<void> initializeWorker(bool isDevelopment) async {
  await Workmanager.initialize(_callbackDispatcher,
      isInDebugMode: isDevelopment);

  Workmanager.registerPeriodicTask(
    'information-periodic',
    InformationPeriodicTaskName,
    frequency: Duration(minutes: 30),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );

  Workmanager.registerPeriodicTask(
    "add-time-record-periodic",
    AddTimeRecordPeriodicTaskName,
    frequency: Duration(minutes: 60),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );

  Workmanager.registerPeriodicTask(
    "delete-time-record-periodic",
    DeleteTimeRecordPeriodicTaskName,
    frequency: Duration(days: 1),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );

  appendInformationWorkerQueue();
}

void appendInformationWorkerQueue() {
  Workmanager.registerOneOffTask(
    "information",
    InformationTaskName,
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );
}

void appendTimeRecordWorkerQueue(String id) {
  Workmanager.registerOneOffTask(
    "add-time-record",
    AddTimeRecordTaskName,
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
    existingWorkPolicy: ExistingWorkPolicy.append,
    inputData: {'id': id},
  );
}

void _callbackDispatcher() {
  Workmanager.executeTask(
    (taskName, inputData) async {
      _logger.i("callbackDispatcher");

      try {
        await initializeHive();

        switch (taskName) {
          case InformationPeriodicTaskName:
          case InformationTaskName:
            await _runGetInformation();
            break;
          case AddTimeRecordPeriodicTaskName:
            await _runAddTimeRecord();
            break;
          case AddTimeRecordTaskName:
            await _runAddTimeRecord(id: inputData['id']);
            break;
          case DeleteTimeRecordPeriodicTaskName:
            await _runDeleteTimeRecord();
            break;
        }
      } catch (ex) {
        _logger.e(ex);
        return Future.value(false);
      }

      return Future.value(true);
    },
  );
}

Future<void> _runDeleteTimeRecord() async {
  _logger.i("start runDeleteTimeRecord");

  final date = DateTime.now().add(Duration(days: -60)).toYmd();
  _logger.i("date:${date.toIso8601String()}");

  final timeRecordRepository = _owner.ref.read(timeRecordRepositoryProvider);
  final timeRecords = await timeRecordRepository.findByLessThanUpdatedAt(date);

  final ids = timeRecords.map((e) => e.localTimeRecordId).toList();
  await timeRecordRepository.deleteAll(ids);

  _logger.i("end runDeleteTimeRecord");
}

Future<void> _runAddTimeRecord({String id}) async {
  _logger.i("start runAddTimeRecord");

  final settingRepository = _owner.ref.read(settingRepositoryProvider);
  final setting = await settingRepository.get();

  if (setting == null) {
    _logger.i('setting is null');
    _logger.i("end runAddTimeRecord");
    return;
  }

  final option = ApiOption(baseUrl: setting.baseUrl, apiKey: setting.apiKey);

  if (option.invalid) {
    _logger.i('ApiOption is invalid');
    _logger.i("end runAddTimeRecord");
    return;
  }

  final timeRecordRepository = _owner.ref.read(timeRecordRepositoryProvider);
  List<TimeRecord> timeRecords = [];

  if (id == null) {
    timeRecords =
        await timeRecordRepository.findByStatus(TimeRecordStatus.None);
  } else {
    final hit = await timeRecordRepository.findById(id);

    if (hit?.status == TimeRecordStatus.None) {
      timeRecords.add(hit);
    }
  }

  final api = _owner.ref.read(apiProvider(option));

  for (var timeRecord in timeRecords) {
    _logger.i('timeRecord ${timeRecord.localTimeRecordId}');
    final result = await api.addTimeRecord(timeRecord);

    switch (result.status) {
      case ApiResultStatus.Ok:
        timeRecord = timeRecord.changeStatus(TimeRecordStatus.Synced);
        _logger.i('api addTimeRecord synced ${timeRecord.localTimeRecordId}');
        break;
      case ApiResultStatus.BadRequest:
        timeRecord = timeRecord.changeStatus(TimeRecordStatus.SyncError);
        _logger
            .i('api addTimeRecord sync error ${timeRecord.localTimeRecordId}');
        break;
      case ApiResultStatus.Unauthorized:
      case ApiResultStatus.ServerError:
      case ApiResultStatus.Unknown:
        _logger.i(
            'api addTimeRecord error ${result.error?.code ?? ''} ${result.error?.message ?? ''}');
        _logger.i("end runAddTimeRecord");
        return;
    }

    await timeRecordRepository.save(timeRecord);
  }

  _logger.i("end runAddTimeRecord");
}

Future<void> _runGetInformation() async {
  _logger.i("start runGetInformation");
  final settingRepository = _owner.ref.read(settingRepositoryProvider);
  final setting = await settingRepository.get();

  if (setting == null) {
    _logger.i('setting is null');
    _logger.i("end runGetInformation");
    return;
  }

  final option = ApiOption(baseUrl: setting.baseUrl, apiKey: setting.apiKey);

  if (option.invalid) {
    _logger.i('ApiOption is invalid');
    _logger.i("end runGetInformation");
    return;
  }

  final api = _owner.ref.read(apiProvider(option));

  final informationRepository = _owner.ref.read(informationRepositoryProvider);
  final localInformation = await informationRepository.get();
  final informationResult = await api.getInformation();

  if (!informationResult.isOk) {
    _logger.i(
        'api getInformation Error ${informationResult.error?.message ?? ''}');
    _logger.i("end runGetInformation");
    return;
  }

  final remoteInformation = informationResult.value;

  if (localInformation != null &&
      localInformation.version.usersVersion >=
          remoteInformation.version.usersVersion) {
    _logger.i('local users version latest');
    _logger.i("end runGetInformation");
    return;
  }

  final usersResult = await api.getUsers();

  if (!usersResult.isOk) {
    _logger.i(
        'api getUsers Error ${usersResult.error?.code} ${usersResult.error?.message ?? ''}');
    _logger.i("end runGetInformation");
    return;
  }

  _logger.i('users:${usersResult.value.length}');

  final userRepository = _owner.ref.read(userRepositoryProvider);
  await userRepository.deleteAll();
  await userRepository.saveAll(usersResult.value);

  await informationRepository.save(remoteInformation);

  _logger.i("end runGetInformation");
}
