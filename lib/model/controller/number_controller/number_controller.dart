import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import 'number_state.dart';
export 'number_state.dart';

final numberProvider =
    StateNotifierProvider.autoDispose((ref) => NumberController());

class NumberController extends StateNotifier<NumberState> {
  NumberController() : super(NumberState());

  void add(String number) {
    state = state.copyWith(text: state.text + number);
  }

  void removeLast() {
    if (state.text.length == 0) {
      return;
    }

    state = state.copyWith(
      text: state.text.substring(0, state.text.length - 1),
    );
  }
}
