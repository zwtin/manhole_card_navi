import 'package:flutter/material.dart';

/// [ModalBottomSheetRoute] を go_router のルートとして積むための [Page]。
///
/// カードのモーダルをルートにしておくと、画面遷移の状態（どのカードを表示中か）を
/// GoRouter の現在地から読める。マップはこれを見て表示エリアを縮める。
class ModalBottomSheetPage<T> extends Page<T> {
  const ModalBottomSheetPage({
    required this.child,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) {
    return ModalBottomSheetRoute<T>(
      settings: this,
      // go_router の pageKey はパス（/map/card/:cardId）ごとに 1 つなので、別のカードの
      // モーダルへ go すると Navigator は Route を作り直さず settings だけ差し替える。
      // 作成時の child を覚えていると前のカードを表示し続けるため、表示のたびに
      // その時点の Page から child を読む（MaterialPage と同じ振る舞い）。
      builder: (context) =>
          (ModalRoute.of(context)!.settings as ModalBottomSheetPage<T>).child,
      isScrollControlled: true,
    );
  }
}
