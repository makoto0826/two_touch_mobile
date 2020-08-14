import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:two_touch_mobile/infra/infra.dart';
import 'package:two_touch_mobile/model/model.dart';
import 'package:state_notifier/state_notifier.dart';

export 'user_list_state.dart';

final StateNotifierProvider<UserListController> userListControllerProvider =
    StateNotifierProvider((ref) {
  final repository = ref.read(userRepositoryProvider);

  return UserListController(repository: repository);
});

class UserListController extends StateNotifier<UserListState> {
  UserRepository _repository;

  UserListController({UserRepository repository}) : super(UserListState()) {
    _repository = repository;
  }

  Future<void> load() async {
    final users = await _repository.findAll();
    state = state.copyWith(users: users);
  }
}
