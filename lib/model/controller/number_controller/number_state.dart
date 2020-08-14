import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'number_state.freezed.dart';

@freezed
abstract class NumberState with _$NumberState{
  factory NumberState({
    @Default('')String text,
  }) = _NumberState;
}
