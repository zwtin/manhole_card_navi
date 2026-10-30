import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/src/router/use_screen_view.dart';
import 'package:app/src/theme/app_colors.dart';
import 'package:app/src/view_data/search_condition_view_data.dart';
import 'package:app/src/view_model/search_condition_view_model.dart';
import 'package:app/src/widget/app_bar_title.dart';
import 'package:app/src/widget/app_text.dart';

/// 検索条件。マップとリストの両方から開く。
class SearchConditionPage extends HookConsumerWidget {
  const SearchConditionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(searchConditionViewModelProvider).valueOrNull;
    final viewModel = ref.read(searchConditionViewModelProvider.notifier);

    useScreenView(ref, viewModel.sendScreenView);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
      // 端末から読むだけで一瞬なので、読み込み中は何も出さない。
      body:
          state == null
              ? null
              : ListView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                children: [
                  _SectionCard(
                    title: '表示',
                    child: _Segmented(
                      options: state.alreadyGetFilters,
                      onChanged: viewModel.selectAlreadyGetFilter,
                    ),
                  ),

                  _SectionCard(
                    title: '弾数',
                    actions: _QuickActions(
                      onSelectAll: viewModel.selectAllVolumes,
                      onClear: viewModel.clearVolumes,
                    ),
                    child: _FilterChips(
                      options: state.volumes,
                      onTap: viewModel.toggleVolume,
                    ),
                  ),

                  _SectionCard(
                    title: '配布状態',
                    actions: _QuickActions(
                      onSelectAll: viewModel.selectAllDistributionStates,
                      onClear: viewModel.clearDistributionStates,
                    ),
                    child: _FilterChips(
                      options: state.distributionStates,
                      onTap: viewModel.toggleDistributionState,
                    ),
                  ),

                  _SectionCard(
                    title: 'マップ表示',
                    pill: 'マップのみ',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.bodySmall('表示する場所', color: _subColor(context)),
                        const SizedBox(height: 8),
                        _Segmented(
                          options: state.coordinateTypes,
                          onChanged: viewModel.selectCoordinateType,
                        ),
                        const SizedBox(height: 16),
                        _StepSlider(
                          title: 'ピンの大きさ',
                          options: state.pinSizes,
                          onChanged: viewModel.selectPinSize,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
    this.pill,
    this.actions,
  });

  final String title;
  final Widget child;

  /// 見出しの横に出す札（「マップのみ」など）。
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

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.onSelectAll, required this.onClear});

  final void Function() onSelectAll;
  final void Function() onClear;

  @override
  Widget build(BuildContext context) {
    // アプリの TextButtonTheme は余白を 0 にしているので、そのままだと
    // 「すべて」「クリア」が密着してタップしづらい。
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

/// 選択の移動のアニメーションとドラッグは、[CupertinoSlidingSegmentedControl] に
/// 任せる。
class _Segmented extends StatelessWidget {
  const _Segmented({required this.options, required this.onChanged});

  final List<OptionViewData> options;

  /// 押された選択肢が [options] の何番目か。
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final selectedIndex = options.indexWhere((option) => option.selected);
    return SizedBox(
      // 幅いっぱいのタイトな制約を与えることで、各セグメントが均等幅になる。
      width: double.infinity,
      // 本体のトラックの角丸（9）は変えられないので、背景は透明にして、カードや
      // チップとそろう 12 の角丸を外側で描く。
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
        ),
        child: CupertinoSlidingSegmentedControl<int>(
          groupValue: selectedIndex < 0 ? null : selectedIndex,
          backgroundColor: Colors.transparent,
          thumbColor: Theme.of(context).primaryColor,
          padding: const EdgeInsets.all(4),
          onValueChanged: (index) {
            if (index != null) {
              onChanged(index);
            }
          },
          children: {
            for (final (index, option) in options.indexed)
              index: _SegmentLabel(
                label: option.label,
                selected: option.selected,
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

/// [CupertinoSlidingSegmentedControl] はサムをドラッグしている間 `onValueChanged`
/// を呼ばないので、[selected] だけを見ると、文字色が指を離すまで変わらない。
///
/// 本体はドラッグ中も、サムがいるセグメントに `FontWeight.w600`、それ以外に `w500`
/// の [DefaultTextStyle] を敷いている。その太さから今の位置を読み、サムに合わせて
/// 文字色を変える。想定外の太さ（SDK の実装が変わったとき）なら [selected] に戻り、
/// 指を離したときに色が変わる。
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

/// 段階を選ぶスライダー。目盛りの真下に段階の名前を並べる。
class _StepSlider extends StatelessWidget {
  const _StepSlider({
    required this.title,
    required this.options,
    required this.onChanged,
  });

  final String title;
  final List<OptionViewData> options;

  /// 選ばれた選択肢が [options] の何番目か。
  final ValueChanged<int> onChanged;

  static const _trackHeight = 4.0;
  static const _overlayRadius = 20.0;

  /// スライダーの端から、端の目盛りの中心までの長さ。名前を目盛りの真下に置く
  /// ため、寸法を固定して求める。Slider はトラックの両端をつまみの影（overlay）の
  /// 半径だけ内側に置き、角の丸いトラックでは目盛りをさらにトラックの太さの半分
  /// だけ内側に置く。
  static const _tickInset = _overlayRadius + _trackHeight / 2;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedIndex = options.indexWhere((option) => option.selected);
    final selected = selectedIndex < 0 ? null : options[selectedIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.bodySmall(title, color: _subColor(context)),
            if (selected != null)
              AppText.bodySmall(selected.label, fontWeight: FontWeight.bold),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: _trackHeight,
            trackShape: const RoundedRectSliderTrackShape(),
            thumbShape: const RoundSliderThumbShape(),
            overlayShape: const RoundSliderOverlayShape(
              overlayRadius: _overlayRadius,
            ),
            activeTrackColor: theme.primaryColor,
            inactiveTrackColor: theme.colorScheme.surfaceContainerHigh,
            thumbColor: theme.primaryColor,
            overlayColor: theme.primaryColor.withValues(alpha: 0.12),
            activeTickMarkColor: theme.colorScheme.surfaceContainerLowest,
            inactiveTickMarkColor: theme.colorScheme.outline,
          ),
          child: Slider(
            value: (selectedIndex < 0 ? 0 : selectedIndex).toDouble(),
            max: (options.length - 1).toDouble(),
            divisions: options.length - 1,
            semanticFormatterCallback: (value) => options[value.round()].label,
            onChanged: (value) {
              // 指で動かしている間は、同じ目盛りのまま何度も呼ばれる。
              final index = value.round();
              if (index != selectedIndex) {
                onChanged(index);
              }
            },
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final step =
                (constraints.maxWidth - _tickInset * 2) / (options.length - 1);
            return Stack(
              clipBehavior: Clip.none,
              children: [
                // 名前はすべて目盛りの位置に置くので、Stack の高さを決めるため
                // だけに見えない名前を 1 つ置く。
                Opacity(
                  opacity: 0,
                  child: AppText.labelMedium(options.first.label),
                ),
                for (final (index, option) in options.indexed)
                  Positioned(
                    left: _tickInset + step * index,
                    child: FractionalTranslation(
                      translation: const Offset(-0.5, 0),
                      child: AppText.labelMedium(
                        option.label,
                        fontWeight: option.selected ? FontWeight.bold : null,
                        color:
                            option.selected
                                ? theme.colorScheme.onSurface
                                : _subColor(context),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.options, required this.onTap});

  final List<OptionViewData> options;

  /// 押された選択肢が [options] の何番目か。
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 9,
      runSpacing: 9,
      children: [
        for (final (index, option) in options.indexed)
          _FilterChip(
            label: option.label,
            selected: option.selected,
            onTap: () => onTap(index),
          ),
      ],
    );
  }
}

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
        // 選んでも外してもチップの幅が変わらない（後ろのチップがずれない）よう、
        // チェック付きの幅を常に取っておく。
        child: Stack(
          alignment: Alignment.center,
          children: [
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
