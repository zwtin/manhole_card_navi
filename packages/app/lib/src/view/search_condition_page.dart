import 'package:domain/domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../router/use_screen_view.dart';
import '../view_data/search_condition_view_data.dart';
import '../theme/app_colors.dart';
import '../view_model/search_condition_view_model.dart';
import '../widget/app_bar_title.dart';
import '../widget/app_text.dart';

/// 検索条件画面。
///
/// マップ・リストの両方から遷移する共通の検索条件編集画面。ナビゲーションバーと
/// 下部の「この条件で表示」ボタンは固定し、その間のセクション群だけをスクロールで
/// 表示する。編集内容はドラフトとして保持し、「この条件で表示」で端末保存され、
/// Stream 経由で両画面へ反映される。
class SearchConditionPage extends HookConsumerWidget {
  const SearchConditionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 端末保存済みの条件はすぐ読めるので、読み込み中は初期状態で表示しておく。
    final state =
        ref.watch(searchConditionViewModelProvider).valueOrNull ??
        SearchConditionViewData(draft: SearchCondition.initial());
    final viewModel = ref.read(searchConditionViewModelProvider.notifier);

    useScreenView(ref, viewModel.sendScreenView);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      // ==== 固定: ナビゲーションバー ====
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: '閉じる',
          onPressed: viewModel.onClose,
        ),
        title: const AppBarTitle('検索条件'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: _subColor(context),
            ),
            onPressed: viewModel.clearAllFilters,
            child: AppText.titleMedium('リセット', color: _subColor(context)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      // ==== スクロール: セクション群 ====
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
        children: [
          // ---- 表示（取得状態）: 単一選択 ----
          _SectionCard(
            title: '表示',
            child: _Segmented<AlreadyGetFilter>(
              value: state.alreadyGetFilter,
              options: const [
                ('すべて', AlreadyGetFilter.all),
                ('取得済みのみ', AlreadyGetFilter.alreadyGet),
                ('未取得のみ', AlreadyGetFilter.notAlreadyGet),
              ],
              onChanged: viewModel.setAlreadyGetFilter,
            ),
          ),

          // ---- 弾数: 複数選択（空＝すべて表示） ----
          _SectionCard(
            title: '弾数',
            actions: _QuickActions(
              onSelectAll: viewModel.selectAllVolumes,
              onClear: viewModel.clearVolumes,
            ),
            child: Wrap(
              spacing: 9,
              runSpacing: 9,
              children:
                  state.volumeOptions
                      .map(
                        (option) => _FilterChip(
                          label: option.name,
                          selected: state.isVolumeSelected(option.id),
                          onTap: () => viewModel.toggleVolume(option.id),
                        ),
                      )
                      .toList(),
            ),
          ),

          // ---- 配布状態: 複数選択（空＝すべて表示） ----
          _SectionCard(
            title: '配布状態',
            actions: _QuickActions(
              onSelectAll: viewModel.selectAllDistributionStates,
              onClear: viewModel.clearDistributionStates,
            ),
            child: Wrap(
              spacing: 9,
              runSpacing: 9,
              children:
                  SearchConditionViewModel.distributionStateOptions
                      .map(
                        (option) => _FilterChip(
                          label: option.name,
                          selected: state.isDistributionStateSelected(
                            option.state,
                          ),
                          onTap:
                              () => viewModel.toggleDistributionState(
                                option.state,
                              ),
                        ),
                      )
                      .toList(),
            ),
          ),

          // ---- マップ表示（マップ画面にのみ適用）: 単一選択 ----
          _SectionCard(
            title: 'マップ表示',
            pill: 'マップのみ',
            child: _Segmented<MapCoordinateType>(
              value: state.coordinateType,
              options: const [
                ('配布場所', MapCoordinateType.distribution),
                ('蓋', MapCoordinateType.position),
              ],
              onChanged: viewModel.setCoordinateType,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
      // ==== 固定: 「この条件で表示」ボタン ====
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor:
                      Theme.of(context).colorScheme.surfaceContainerLowest,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: viewModel.onApply,
                child: AppText.titleMedium(
                  'この条件で表示',
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.surfaceContainerLowest,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 補助テキスト・テキストボタンの色。
Color _subColor(BuildContext context) {
  final theme = Theme.of(context);
  return theme.iconTheme.color ?? theme.colorScheme.onSurface;
}

/// セクションカード。見出し・任意のバッジ／補助テキスト／右上クイックアクションを持つ。
class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
    this.pill,
    this.actions,
  });

  final String title;
  final Widget child;
  final String? pill;
  final Widget? actions;

  @override
  Widget build(BuildContext context) {
    final line = context.appColors.cardLine;
    final shadow = context.appColors.cardShadow;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: line == null ? null : Border.all(color: line),
        boxShadow:
            shadow == null
                ? null
                : [
                  BoxShadow(
                    color: shadow,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: AppText.titleMedium(
                        title,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (pill != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: AppText.labelSmall(
                          pill!,
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(
                                context,
                              ).colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (actions != null) actions!,
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

/// 右上の「すべて / クリア」クイックアクション。
class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.onSelectAll, required this.onClear});

  final void Function() onSelectAll;
  final void Function() onClear;

  @override
  Widget build(BuildContext context) {
    // アプリの TextButtonTheme は余白を 0 にしているため、そのままだと
    // 「すべて」「クリア」が密着してタップしづらい。各ボタンに横余白を与えて
    // タップ領域を広げ、区切りの前後にも間隔を確保する。
    final style = TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      foregroundColor: _subColor(context),
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          style: style,
          onPressed: onSelectAll,
          child: AppText.titleSmall('すべて', color: _subColor(context)),
        ),
        AppText.titleSmall('|', color: Theme.of(context).colorScheme.outline),
        TextButton(
          style: style,
          onPressed: onClear,
          child: AppText.titleSmall('クリア', color: _subColor(context)),
        ),
      ],
    );
  }
}

/// 単一選択のセグメントコントロール。
///
/// 見た目はアプリの配色（トラック＝`track` / 選択中＝`primary`）に合わせつつ、
/// 選択位置の移動やドラッグ操作は [CupertinoSlidingSegmentedControl] に任せて
/// スライドアニメーションを得る。
class _Segmented<T extends Object> extends StatelessWidget {
  const _Segmented({
    required this.options,
    required this.value,
    required this.onChanged,
  });

  final List<(String, T)> options;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // 幅いっぱいのタイトな制約を与えることで、各セグメントが均等幅になる。
      width: double.infinity,
      // トラックの角丸は本体側が持つ固定値（9）より従来の 12 の方がカードや
      // チップと揃うため、背景は透明にして外側の DecoratedBox で描画する。
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
        ),
        child: CupertinoSlidingSegmentedControl<T>(
          groupValue: value,
          backgroundColor: Colors.transparent,
          thumbColor: Theme.of(context).primaryColor,
          padding: const EdgeInsets.all(4),
          onValueChanged: (newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
          children: {
            for (final option in options)
              option.$2: _SegmentLabel(
                label: option.$1,
                selected: option.$2 == value,
                selectedColor:
                    Theme.of(context).colorScheme.surfaceContainerLowest,
                unselectedColor: _subColor(context),
              ),
          },
        ),
      ),
    );
  }
}

/// セグメント 1 つ分のラベル。
///
/// [CupertinoSlidingSegmentedControl] はサムをドラッグしている間 `onValueChanged`
/// を呼ばず、指を離した時点で初めて通知する。そのため [selected]（= groupValue と
/// の一致）だけを見ていると、スライド中は文字色が変わらず指を離してから切り替わって
/// しまう。
///
/// 一方で本体は「今サムがいるセグメント」に `FontWeight.w600`、それ以外に `w500` の
/// [DefaultTextStyle] をドラッグ中もリアルタイムに敷いている。ここではその継承された
/// フォントウェイトから現在の選択位置を読み取り、サムの移動に追従して文字色を変える。
/// 想定外のウェイトだった場合（SDK 側の実装変更）は [selected] にフォールバックし、
/// 指を離した時点で色が変わる従来の挙動になる。
class _SegmentLabel extends StatelessWidget {
  const _SegmentLabel({
    required this.label,
    required this.selected,
    required this.selectedColor,
    required this.unselectedColor,
  });

  final String label;
  final bool selected;
  final Color selectedColor;
  final Color unselectedColor;

  @override
  Widget build(BuildContext context) {
    // 本体が敷いたスタイル（アプリ既定のスタイル＋ウェイト／サイズ）を土台にする。
    final inheritedStyle = DefaultTextStyle.of(context).style;
    final bool highlighted;
    if (inheritedStyle.fontWeight == FontWeight.w600) {
      highlighted = true;
    } else if (inheritedStyle.fontWeight == FontWeight.w500) {
      highlighted = false;
    } else {
      highlighted = selected;
    }

    return AnimatedDefaultTextStyle(
      // サムの移動に合わせて文字色を滑らかに変える。
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
      textAlign: TextAlign.center,
      style: inheritedStyle
          .merge(Theme.of(context).textTheme.labelLarge)
          .copyWith(
            fontWeight: FontWeight.w600,
            color: highlighted ? selectedColor : unselectedColor,
          ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        // AnimatedDefaultTextStyle が動かしている見た目を受け継ぐ必要があるので、
        // ここだけは AppText（自分で style を決める）を使えない。
        // ignore: use_app_text
        child: Text(label, textAlign: TextAlign.center),
      ),
    );
  }
}

/// 複数選択用のフィルタチップ。選択中は塗り＋チェック、未選択は枠線のみ。
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final labelWidget = AppText.bodyMedium(
      label,
      fontWeight: FontWeight.w600,
      color:
          selected
              ? Theme.of(context).colorScheme.surfaceContainerLowest
              : Theme.of(context).colorScheme.onSurface,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color:
              selected
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color:
                selected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.outline,
          ),
        ),
        // ON 状態（チェック＋テキスト）の幅を常に確保しておき、ON/OFF を切り替えても
        // チップ幅が変わらない（＝後続のチップがズレない）ようにする。見せる内容は
        // 中央寄せで、OFF はテキストのみ、ON はチェックマークを含めて中央に配置する。
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 幅を固定するための不可視サイザー。常に ON 状態の内容を占有させる。
            Opacity(
              opacity: 0,
              child: _content(context, labelWidget, withCheck: true),
            ),
            _content(context, labelWidget, withCheck: selected),
          ],
        ),
      ),
    );
  }

  Widget _content(
    BuildContext context,
    Widget labelWidget, {
    required bool withCheck,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (withCheck) ...[
          Icon(
            Icons.check,
            size: 16,
            color: Theme.of(context).colorScheme.surfaceContainerLowest,
          ),
          const SizedBox(width: 4),
        ],
        labelWidget,
      ],
    );
  }
}
