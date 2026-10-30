import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:domain/domain.dart';

/// 引数はカード ID。
final imageDetailViewModelProvider = NotifierProvider.autoDispose
    .family<ImageDetailViewModel, void, String>(ImageDetailViewModel.new);

class ImageDetailViewModel extends AutoDisposeFamilyNotifier<void, String> {
  AnalyticsUseCase get _analyticsUseCase => ref.read(analyticsUseCaseProvider);

  @override
  void build(String cardId) {}

  Future<void> sendScreenView() async {
    await _analyticsUseCase.send(
      event: AnalyticsEvent.screenView(
        screenName: 'image_detail_view',
        parameters: {'card_id': arg},
      ),
    );
  }
}
