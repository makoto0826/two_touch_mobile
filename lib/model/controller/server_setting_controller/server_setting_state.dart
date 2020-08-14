import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'server_setting_state.freezed.dart';

@freezed
abstract class ServerSettingState with _$ServerSettingState {
  factory ServerSettingState({
    @Default('')String baseUrl,
    @Default('')String apiKey,
    @Default(false)bool isLoading,
  }) = _ServerSettingState;
}
