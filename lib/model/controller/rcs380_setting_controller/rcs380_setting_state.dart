import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:two_touch_mobile/infra/infra.dart';

part 'rcs380_setting_state.freezed.dart';

@freezed
abstract class Rcs380SettingState with _$Rcs380SettingState{
  factory Rcs380SettingState({
    Rcs380Status status,
    @Default(false) bool isEnabled,
    @Default('')String text,
  }) = _Rcs380SettingState;
}
