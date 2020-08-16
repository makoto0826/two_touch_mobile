import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:two_touch_mobile/infra/infra.dart';
import 'package:two_touch_mobile/model/model.dart';
import 'package:two_touch_mobile/worker.dart';

import 'save_result.dart';
import 'save_result_status.dart';
import 'server_setting_state.dart';

export 'save_result.dart';
export 'save_result_status.dart';
export 'server_setting_state.dart';

final StateNotifierProvider<ServerSettingController>
    serverSettingControllerProvider = StateNotifierProvider((ref) {
  final repository = ref.read(settingRepositoryProvider);
  return ServerSettingController(repository: repository, ref: ref);
});

class ServerSettingController extends StateNotifier<ServerSettingState> {
  SettingRepository _repository;

  ProviderReference _ref;

  ServerSettingController({SettingRepository repository, ProviderReference ref})
      : super(ServerSettingState()) {
    _repository = repository;
    _ref = ref;
  }

  void changeBaseUrl(String baseUrl) {
    state = state.copyWith(baseUrl: baseUrl);
  }

  void changeApiKey(String apiKey) {
    state = state.copyWith(apiKey: apiKey);
  }

  Future<SaveResult> save() async {
    state = state.copyWith(isLoading: true);

    final api = _ref.read(apiProvider(ApiOption(
      baseUrl: state.baseUrl,
      apiKey: state.apiKey,
    )));

    final result = await api.getInformation();

    String text = '保存しました';
    SaveResultStatus status = SaveResultStatus.Ok;

    if (result.status == ApiResultStatus.Ok) {
      await _repository.save(
        Setting(baseUrl: state.baseUrl, apiKey: state.apiKey),
      );

      appendInformationWorkerQueue();
    }

    // ignore: missing_enum_constant_in_switch
    switch (result.status) {
      case ApiResultStatus.Unauthorized:
        text = 'APIキーに誤りがあります';
        status = SaveResultStatus.Error;
        break;
      case ApiResultStatus.BadRequest:
      case ApiResultStatus.ServerError:
      case ApiResultStatus.Unknown:
        text = 'サーバーの接続に失敗しました';
        status = SaveResultStatus.Error;
        break;
    }

    state = state.copyWith(isLoading: false);
    return SaveResult(status: status, text: text);
  }

  Future<void> load() async {
    var setting = await _repository.get();

    if (setting == null) {
      return;
    }

    state = state.copyWith(
      baseUrl: setting.baseUrl,
      apiKey: setting.apiKey,
    );
  }
}
