import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../router/use_screen_view.dart';
import '../view_data/setting_view_data.dart';
import '../view_model/setting_view_model.dart';
import '../widget/custom_text.dart';

/// 設定タブ。
class SettingPage extends HookConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingViewModelProvider).valueOrNull ??
        const SettingViewData();
    final viewModel = ref.read(settingViewModelProvider.notifier);

    useScreenView(ref, viewModel.sendScreenView);

    return Scaffold(
      appBar: AppBar(
        title: const TitleLargeText('設定', fontWeight: FontWeight.bold),
      ),
      body: Stack(
        children: [
          Container(color: Theme.of(context).colorScheme.background),
          SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            ListTile(
                              title: const TitleMediumText('アプリの使い方'),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              onTap: viewModel.onTapHowToUse,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16.0),
                                  bottom: Radius.circular(16.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            ListTile(
                              title: const TitleMediumText('改善要望・不具合報告'),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              onTap: viewModel.onTapRequestImprovement,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16.0),
                                  bottom: Radius.circular(16.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            ListTile(
                              title: const TitleMediumText('利用規約'),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              onTap: viewModel.onTapTermsOfService,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16.0),
                                ),
                              ),
                            ),
                            Container(
                              color: Theme.of(context).dividerColor,
                              height: 1,
                            ),
                            ListTile(
                              title: const TitleMediumText('プライバシーポリシー'),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              onTap: viewModel.onTapPrivacyPolicy,
                            ),
                            Container(
                              color: Theme.of(context).dividerColor,
                              height: 1,
                            ),
                            ListTile(
                              title: const TitleMediumText('ライセンス'),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              onTap: viewModel.onTapLicense,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(16.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TitleMediumText(state.appName),
                    TitleMediumText('バージョン ${state.appVersion}'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
