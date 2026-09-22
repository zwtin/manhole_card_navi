import 'package:domain/domain.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 引数はカード ID。
final imageDetailViewModelProvider = NotifierProvider.autoDispose
    .family<ImageDetailViewModel, void, String>(
  ImageDetailViewModel.new,
);

/// カード画像の拡大表示の ViewModel。
class ImageDetailViewModel extends AutoDisposeFamilyNotifier<void, String> {
  late final AnalyticsUseCase _analyticsUseCase;

  @override
  void build(String cardId) {
    _analyticsUseCase = ref.watch(analyticsUseCaseProvider);
  }

  Future<void> sendScreenView() async {
    await _analyticsUseCase.send(
      event: AnalyticsEvent.screenView(
        screenName: 'image_detail_view',
        parameters: {'card_id': arg},
      ),
    );
  }
}
