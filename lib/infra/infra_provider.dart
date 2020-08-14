import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:two_touch_mobile/infra/infra.dart';

final apiProvider = Provider.family
    .autoDispose<Api, ApiOption>((ref, option) => Api(option: option));

final Provider<Rcs380> rcs380Provider = Provider((ref) => Rcs380.instance);

final Provider<Database> databaseProvider = Provider((ref) => Database());

final Provider<InformationRepository> informationRepositoryProvider =
    Provider((ref) {
  return InformationRepository(db: ref.read(databaseProvider));
});

final Provider<SettingRepository> settingRepositoryProvider = Provider((ref) {
  return SettingRepository(db: ref.read(databaseProvider));
});

final Provider<UserRepository> userRepositoryProvider = Provider((ref) {
  return UserRepository(db: ref.read(databaseProvider));
});

final Provider<TimeRecordRepository> timeRecordRepositoryProvider =
    Provider((ref) {
  return TimeRecordRepository(db: ref.read(databaseProvider));
});
