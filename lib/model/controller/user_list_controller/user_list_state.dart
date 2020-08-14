import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:two_touch_mobile/model/model.dart';

part 'user_list_state.freezed.dart';

@freezed
abstract class UserListState with _$UserListState {
  factory UserListState({
    @Default([])List<User> users,
  }) = _UserListState;
}
