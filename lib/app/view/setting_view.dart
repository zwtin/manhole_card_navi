import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:manhole_card_navi/gen/colors.gen.dart';

import '/app/provider/tab_key_storage_provider.dart';
import '/app/view_model/bottom_tab_view_model.dart';
import '/app/view_model/setting_view_model.dart';
import '/app/widget/custom_text.dart';
import '/app/widget/router_widget.dart';

class SettingView extends HookConsumerWidget {
  const SettingView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(settingViewModelProvider(key));

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
            await ref.read(settingViewModelProvider(key)).onLoad();
          },
        );
        return null;
      },
      const [],
    );

    return RouterWidget(
      key: key,
      pop: () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          final bottomTabKey =
              ref.read(tabKeyStorageProvider).getBottomTabKey();
          ref.read(bottomTabViewModelProvider(bottomTabKey)).onTap(0);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const TitleLargeText(
            '設定',
            fontWeight: FontWeight.bold,
          ),
        ),
        body: Stack(
          children: [
            Container(
              color: ColorName.screenBackground,
            ),
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
                                title: const TitleMediumText(
                                  '利用規約',
                                ),
                                tileColor: ColorName.contentsBackground,
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                ),
                                onTap: () async {
                                  await ref
                                      .read(settingViewModelProvider(key))
                                      .onTapTermsOfService();
                                },
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
                                title: const TitleMediumText(
                                  'プライバシーポリシー',
                                ),
                                tileColor: ColorName.contentsBackground,
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                ),
                                onTap: () async {
                                  await ref
                                      .read(settingViewModelProvider(key))
                                      .onTapPrivacyPolicy();
                                },
                              ),
                              Container(
                                color: Theme.of(context).dividerColor,
                                height: 1,
                              ),
                              ListTile(
                                title: const TitleMediumText(
                                  'ライセンス',
                                ),
                                tileColor: ColorName.contentsBackground,
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                ),
                                onTap: () async {
                                  await ref
                                      .read(settingViewModelProvider(key))
                                      .onTapLicense();
                                },
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
                      Container(
                        height: 24,
                      ),
                      TitleMediumText(
                        viewModel.appName,
                      ),
                      TitleMediumText(
                        'バージョン ${viewModel.appVersion}',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
