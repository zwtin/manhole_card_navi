import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '/app/view_model/search_condition_view_model.dart';
import '/app/widget/common_widget.dart';
import '/app/widget/custom_text.dart';
import '/app/widget/pv_sender_widget.dart';
import '/app/widget/router_widget.dart';
import '/domain/entity/display_filter.dart';
import '/domain/entity/map_coordinate_type.dart';

/// 検索条件画面。
///
/// マップ・リストの両方から遷移する共通の検索条件編集画面。ナビゲーションバーと
/// 下部の「この条件で表示」ボタンは固定し、その間のセクション群だけをスクロールで
/// 表示する。編集内容はドラフトとして保持し、「この条件で表示」で端末保存され、
/// Stream 経由で両画面へ反映される。
class SearchConditionView extends CommonWidget {
  const SearchConditionView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(searchConditionViewModelProvider(key));
    final palette = _Palette.of(context);

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
            await ref.read(searchConditionViewModelProvider(key)).onLoad();
          },
        );
        return null;
      },
      const [],
    );

    return PVSenderWidget(
      key: key,
      parent: this,
      child: RouterWidget(
        key: key,
        parent: this,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          // ==== 固定: ナビゲーションバー ====
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close),
              tooltip: '閉じる',
              onPressed: () {
                ref.read(searchConditionViewModelProvider(key)).onClose();
              },
            ),
            title: const TitleLargeText(
              '検索条件',
              fontWeight: FontWeight.bold,
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor: palette.sub,
                ),
                onPressed: () {
                  ref
                      .read(searchConditionViewModelProvider(key))
                      .clearAllFilters();
                },
                child: TitleMediumText(
                  'リセット',
                  color: palette.sub,
                ),
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
                palette: palette,
                title: '表示',
                child: _Segmented<DisplayFilter>(
                  palette: palette,
                  value: viewModel.displayFilter,
                  options: const [
                    ('すべて', DisplayFilter.all),
                    ('取得済みのみ', DisplayFilter.acquired),
                    ('未取得のみ', DisplayFilter.unacquired),
                  ],
                  onChanged: (value) {
                    ref
                        .read(searchConditionViewModelProvider(key))
                        .setDisplayFilter(value);
                  },
                ),
              ),

              // ---- 弾数: 複数選択（空＝すべて表示） ----
              _SectionCard(
                palette: palette,
                title: '弾数',
                actions: _QuickActions(
                  palette: palette,
                  onSelectAll: () {
                    ref
                        .read(searchConditionViewModelProvider(key))
                        .selectAllVolumes();
                  },
                  onClear: () {
                    ref
                        .read(searchConditionViewModelProvider(key))
                        .clearVolumes();
                  },
                ),
                child: Wrap(
                  spacing: 9,
                  runSpacing: 9,
                  children: viewModel.volumeOptions
                      .map(
                        (option) => _FilterChip(
                          palette: palette,
                          label: option.name,
                          selected: viewModel.isVolumeSelected(option.id),
                          onTap: () {
                            ref
                                .read(searchConditionViewModelProvider(key))
                                .toggleVolume(option.id);
                          },
                        ),
                      )
                      .toList(),
                ),
              ),

              // ---- 配布状態: 複数選択（空＝すべて表示） ----
              _SectionCard(
                palette: palette,
                title: '配布状態',
                actions: _QuickActions(
                  palette: palette,
                  onSelectAll: () {
                    ref
                        .read(searchConditionViewModelProvider(key))
                        .selectAllDistributionStates();
                  },
                  onClear: () {
                    ref
                        .read(searchConditionViewModelProvider(key))
                        .clearDistributionStates();
                  },
                ),
                child: Wrap(
                  spacing: 9,
                  runSpacing: 9,
                  children: SearchConditionViewModel.distributionStateOptions
                      .map(
                        (option) => _FilterChip(
                          palette: palette,
                          label: option.name,
                          selected: viewModel
                              .isDistributionStateSelected(option.state),
                          onTap: () {
                            ref
                                .read(searchConditionViewModelProvider(key))
                                .toggleDistributionState(option.state);
                          },
                        ),
                      )
                      .toList(),
                ),
              ),

              // ---- マップ表示（マップ画面にのみ適用）: 単一選択 ----
              _SectionCard(
                palette: palette,
                title: 'マップ表示',
                pill: 'マップのみ',
                helpText: '地図に表示する座標の種類。一覧には影響しません。',
                child: _Segmented<MapCoordinateType>(
                  palette: palette,
                  value: viewModel.coordinateType,
                  options: const [
                    ('配布場所', MapCoordinateType.distribution),
                    ('蓋の座標', MapCoordinateType.position),
                  ],
                  onChanged: (value) {
                    ref
                        .read(searchConditionViewModelProvider(key))
                        .setCoordinateType(value);
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
          // ==== 固定: 「この条件で表示」ボタン ====
          bottomNavigationBar: Container(
            color: Theme.of(context).colorScheme.surface,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: palette.primary,
                      foregroundColor: palette.onPrimary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      ref
                          .read(searchConditionViewModelProvider(key))
                          .onApply();
                    },
                    child: Text(
                      'この条件で表示',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: palette.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Future<void> sendPV(WidgetRef ref) async {
    await ref.read(searchConditionViewModelProvider(key)).sendPV();
  }

  @override
  Future<void> onCameBack(WidgetRef ref) async {}
}

/// 画面配色。アプリのテーマ色（`ColorName` 由来）を `Theme` から取得し、
/// ライト/ダークで自動的に切り替える。
class _Palette {
  const _Palette({
    required this.dark,
    required this.primary,
    required this.onPrimary,
    required this.card,
    required this.sub,
    required this.track,
    required this.chipBorder,
    required this.cardLine,
    required this.pillColor,
    required this.pillBg,
  });

  final bool dark;

  /// 選択状態の塗り色（テーマの primary = #86B6F6）。
  final Color primary;

  /// primary 上の文字色（テーマの surface = ライト白 / ダーク濃色）。
  final Color onPrimary;

  /// セクションカードの背景（テーマの surface）。
  final Color card;

  /// 補助テキスト・テキストボタンの色（テーマの icon 色）。
  final Color sub;

  /// セグメントコントロールのトラック色。
  final Color track;

  /// 未選択チップの枠線色。
  final Color chipBorder;

  /// ダーク時のカード枠線色。
  final Color cardLine;

  /// 「マップのみ」バッジの文字色（セカンダリ系）。
  final Color pillColor;

  /// 「マップのみ」バッジの背景色。
  final Color pillBg;

  factory _Palette.of(BuildContext context) {
    final theme = Theme.of(context);
    // このアプリの darkTheme は brightness を light のまま色だけ差し替えているため、
    // theme.brightness ではダーク判定できない。実際に効いている surface 色
    // （ダークテーマでは暗色 #222222）の明るさで判定する。
    final dark = theme.colorScheme.surface.computeLuminance() < 0.5;
    return _Palette(
      dark: dark,
      primary: theme.primaryColor,
      onPrimary: theme.colorScheme.surface,
      card: theme.colorScheme.surface,
      sub: theme.iconTheme.color ?? (dark ? Colors.white70 : Colors.black54),
      track: dark ? const Color(0xFF3A3A3A) : const Color(0xFFE6E6E6),
      chipBorder: dark ? const Color(0xFF555555) : const Color(0xFFC9C9C9),
      cardLine: const Color(0xFF2E2E2E),
      pillColor: dark ? const Color(0xFF8ECFE4) : const Color(0xFF176B87),
      pillBg: dark ? const Color(0xFF16333B) : const Color(0xFFE4EFF2),
    );
  }
}

/// セクションカード。見出し・任意のバッジ／補助テキスト／右上クイックアクションを持つ。
class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.palette,
    required this.title,
    required this.child,
    this.pill,
    this.helpText,
    this.actions,
  });

  final _Palette palette;
  final String title;
  final Widget child;
  final String? pill;
  final String? helpText;
  final Widget? actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(16),
        border: palette.dark ? Border.all(color: palette.cardLine) : null,
        boxShadow: palette.dark
            ? null
            : const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 3,
                  offset: Offset(0, 1),
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
                      child: TitleMediumText(
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
                          color: palette.pillBg,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          pill!,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: palette.pillColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (actions != null) actions!,
            ],
          ),
          if (helpText != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: BodySmallText(
                helpText!,
                color: palette.sub,
              ),
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
  const _QuickActions({
    required this.palette,
    required this.onSelectAll,
    required this.onClear,
  });

  final _Palette palette;
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
      foregroundColor: palette.sub,
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          style: style,
          onPressed: onSelectAll,
          child: TitleSmallText('すべて', color: palette.sub),
        ),
        Text('|', style: TextStyle(color: palette.chipBorder)),
        TextButton(
          style: style,
          onPressed: onClear,
          child: TitleSmallText('クリア', color: palette.sub),
        ),
      ],
    );
  }
}

/// 単一選択のセグメントコントロール。
class _Segmented<T> extends StatelessWidget {
  const _Segmented({
    required this.palette,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  final _Palette palette;
  final List<(String, T)> options;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: palette.track,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: options.map((option) {
          final selected = option.$2 == value;
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onChanged(option.$2),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: selected ? palette.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                ),
                alignment: Alignment.center,
                child: Text(
                  option.$1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: selected ? palette.onPrimary : palette.sub,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// 複数選択用のフィルタチップ。選択中は塗り＋チェック、未選択は枠線のみ。
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.palette,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final _Palette palette;
  final String label;
  final bool selected;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? palette.primary : palette.card,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? palette.primary : palette.chipBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // チェックマークのスペースは常に確保する。ON/OFF でチップ幅が変わって
            // 後続のチップ位置がズレるのを防ぐため、未選択でも同じ幅の空きを取る。
            SizedBox(
              width: 16,
              height: 16,
              child: selected
                  ? Icon(Icons.check, size: 16, color: palette.onPrimary)
                  : null,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: selected
                    ? palette.onPrimary
                    : Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
