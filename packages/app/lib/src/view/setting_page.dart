import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/src/router/use_screen_view.dart';
import 'package:app/src/view_data/setting_view_data.dart';
import 'package:app/src/view_model/setting_view_model.dart';
import 'package:app/src/widget/app_bar_title.dart';
import 'package:app/src/widget/app_text.dart';

class SettingPage extends HookConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state =
        ref.watch(settingViewModelProvider).valueOrNull ??
        const SettingViewData();
    final viewModel = ref.read(settingViewModelProvider.notifier);

    useScreenView(ref, viewModel.sendScreenView);

    return Scaffold(
      appBar: AppBar(title: const AppBarTitle('設定')),
      body: Stack(
        children: [
          Container(color: Theme.of(context).colorScheme.surface),
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
                              title: const AppText.titleMedium('アプリの使い方'),
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
                              title: const AppText.titleMedium('改善要望・不具合報告'),
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
                              title: const AppText.titleMedium('利用規約'),
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
                              title: const AppText.titleMedium('プライバシーポリシー'),
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
                              title: const AppText.titleMedium('ライセンス'),
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
                    AppText.titleMedium(state.appName),
                    AppText.titleMedium('バージョン ${state.appVersion}'),
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
