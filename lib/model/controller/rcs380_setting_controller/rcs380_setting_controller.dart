import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:two_touch_mobile/infra/infra.dart';

import 'rcs380_setting_state.dart';
export 'rcs380_setting_state.dart';

final StateNotifierProvider<Rcs380SettingController>
    rcs380SettingControllerProvider = StateNotifierProvider((ref) {
  final rcs380 = ref.read(rcs380Provider);
  return Rcs380SettingController(rcs380: rcs380);
});

class Rcs380SettingController extends StateNotifier<Rcs380SettingState> {
  Rcs380 _rcs380;

  Rcs380SettingController({Rcs380 rcs380}) : super(Rcs380SettingState()) {
    _rcs380 = rcs380;
  }

  Future<void> requestPermission() async {
    await _rcs380.requestPermission();
    await getStatus();
  }

  Future<void> getStatus() async {
    final status = await _rcs380.getStatus();

    String text = '';
    bool isEnabled = false;

    switch (status) {
      case Rcs380Status.NotFound:
      case Rcs380Status.NotFoundAndPermission:
        text = 'RC-S380が見つかりません';
        break;
      case Rcs380Status.Found:
        text = 'RC-S380を有効にしてください';
        isEnabled = true;
        break;
      case Rcs380Status.FoundAndPermission:
        text = 'RC-S380は有効です';
        break;
    }

    state = state.copyWith(
      status: status,
      isEnabled: isEnabled,
      text: text,
    );
  }
}
