import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class CommonWidget extends HookConsumerWidget {
  const CommonWidget({super.key});

  Future<void> sendPV(WidgetRef ref);
  Future<void> onCameBack(WidgetRef ref);
}
