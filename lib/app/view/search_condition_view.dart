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
/// マップ・リストの両方から遷移する共通の検索条件編集画面。編集内容はドラフトとして
/// 保持し、「適用」を押すと端末保存され、Stream 経由で両画面へ反映される。
class SearchConditionView extends CommonWidget {
  const SearchConditionView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(searchConditionViewModelProvider(key));

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
                onPressed: () {
                  ref
                      .read(searchConditionViewModelProvider(key))
                      .clearAllFilters();
                },
                child: const Text('絞り込みをクリア'),
              ),
            ],
          ),
          body: ListView(
            children: [
              // ==== 表示（取得状態）: 単一選択 ====
              const _SectionHeader(title: '表示'),
              _SelectableTile(
                title: 'すべて',
                selected: viewModel.displayFilter == DisplayFilter.all,
                onTap: () {
                  ref
                      .read(searchConditionViewModelProvider(key))
                      .setDisplayFilter(DisplayFilter.all);
                },
              ),
              _SelectableTile(
                title: '取得済みのみ',
                selected: viewModel.displayFilter == DisplayFilter.acquired,
                onTap: () {
                  ref
                      .read(searchConditionViewModelProvider(key))
                      .setDisplayFilter(DisplayFilter.acquired);
                },
              ),
              _SelectableTile(
                title: '未取得のみ',
                selected: viewModel.displayFilter == DisplayFilter.unacquired,
                onTap: () {
                  ref
                      .read(searchConditionViewModelProvider(key))
                      .setDisplayFilter(DisplayFilter.unacquired);
                },
              ),
              const Divider(),

              // ==== 弾数: 複数選択（空＝すべて表示） ====
              _SectionHeader(
                title: '弾数',
                trailing: _SelectClearButtons(
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
              ),
              if (viewModel.isVolumeFilterEmpty)
                const _EmptyFilterHint(text: 'すべての弾を表示中'),
              ...viewModel.volumeOptions.map(
                (option) => CheckboxListTile(
                  title: TitleMediumText(option.name),
                  value: viewModel.isVolumeSelected(option.id),
                  onChanged: (_) {
                    ref
                        .read(searchConditionViewModelProvider(key))
                        .toggleVolume(option.id);
                  },
                ),
              ),
              const Divider(),

              // ==== 配布状態: 複数選択（空＝すべて表示） ====
              _SectionHeader(
                title: '配布状態',
                trailing: _SelectClearButtons(
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
              ),
              if (viewModel.isDistributionStateFilterEmpty)
                const _EmptyFilterHint(text: 'すべての配布状態を表示中'),
              ...SearchConditionViewModel.distributionStateOptions.map(
                (option) => CheckboxListTile(
                  title: TitleMediumText(option.name),
                  value: viewModel.isDistributionStateSelected(option.state),
                  onChanged: (_) {
                    ref
                        .read(searchConditionViewModelProvider(key))
                        .toggleDistributionState(option.state);
                  },
                ),
              ),
              const Divider(),

              // ==== マップ表示（マップ画面にのみ適用）: 単一選択 ====
              const _SectionHeader(title: 'マップ表示'),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: BodySmallText(
                  'この設定はマップ画面にのみ適用されます。',
                ),
              ),
              _SelectableTile(
                title: '配布場所',
                selected:
                    viewModel.coordinateType == MapCoordinateType.distribution,
                onTap: () {
                  ref
                      .read(searchConditionViewModelProvider(key))
                      .setCoordinateType(MapCoordinateType.distribution);
                },
              ),
              _SelectableTile(
                title: '蓋の座標',
                selected:
                    viewModel.coordinateType == MapCoordinateType.position,
                onTap: () {
                  ref
                      .read(searchConditionViewModelProvider(key))
                      .setCoordinateType(MapCoordinateType.position);
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(searchConditionViewModelProvider(key)).onApply();
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: TitleMediumText(
                      '適用',
                      fontWeight: FontWeight.bold,
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

/// 単一選択用のタイル。選択中は先頭にチェックアイコンを表示する。
/// 既存のボトムシート（配布/蓋の切替）と同じ作法。
class _SelectableTile extends StatelessWidget {
  const _SelectableTile({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 20,
        height: 20,
        child: selected
            ? Icon(
                Icons.check,
                color: Theme.of(context).primaryColor,
              )
            : null,
      ),
      title: TitleMediumText(title),
      tileColor: Colors.transparent,
      onTap: onTap,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.trailing,
  });

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TitleMediumText(
              title,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _SelectClearButtons extends StatelessWidget {
  const _SelectClearButtons({
    required this.onSelectAll,
    required this.onClear,
  });

  final void Function() onSelectAll;
  final void Function() onClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: onSelectAll,
          child: const Text('すべて'),
        ),
        TextButton(
          onPressed: onClear,
          child: const Text('クリア'),
        ),
      ],
    );
  }
}

class _EmptyFilterHint extends StatelessWidget {
  const _EmptyFilterHint({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: BodySmallText(text),
    );
  }
}
