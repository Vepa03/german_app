import 'package:riverpod/legacy.dart';

class SelectedAnswerNotifier extends StateNotifier<Map<int, String>> {
  SelectedAnswerNotifier(): super({});
  void setSelected(int questionIndex, String optionId){
    if (state.containsKey(questionIndex)) return;

    state = {...state, questionIndex: optionId};
  }

  void clear() => state = {};
}

final selectedProvider = StateNotifierProvider<SelectedAnswerNotifier , Map<int, String>>(
  (ref)=> SelectedAnswerNotifier(),
);