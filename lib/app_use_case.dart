import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

final appUseCaseProvider = Provider.autoDispose<AppUseCase>(
  (ref) {
    final appUseCase = AppUseCase();
    ref.onDispose(appUseCase.dispose);
    return appUseCase;
  },
);

class AppUseCase {
  final _logger = Logger();

  void dispose() {
    _logger.d('AppUseCase dispose');
  }
}
