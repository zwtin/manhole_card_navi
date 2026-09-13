import 'package:domain/domain.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final appViewModelProvider = NotifierProvider.autoDispose<AppViewModel, void>(
  AppViewModel.new,
);

/// アプリ全体（App）の ViewModel。
class AppViewModel extends AutoDisposeNotifier<void> {
  late final AnalyticsUseCase _analyticsUseCase;

  @override
  void build() {
    _analyticsUseCase = ref.watch(analyticsUseCaseProvider);
  }

  Future<void> onLoad() async {
    await _analyticsUseCase.sendOpen();
  }
}
