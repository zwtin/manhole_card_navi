import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '/app/view_model/setting_view_model.dart';
import '/app/widget/custom_text.dart';
import '/app/widget/router_widget.dart';
import '/gen/colors.gen.dart';

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
      child: Scaffold(
        appBar: AppBar(
          title: const TitleLargeBoldText(
            '設定',
          ),
        ),
        body: Stack(
          children: [
            Container(
              color: ColorName.main,
            ),
            SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              title: const TitleMediumBoldText(
                                '利用規約',
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                              onTap: () async {
                                await ref
                                    .read(settingViewModelProvider(key))
                                    .onTapTermsOfService();
                              },
                            ),
                            Container(
                              color: Colors.white,
                              height: 1,
                            ),
                            ListTile(
                              title: const TitleMediumBoldText(
                                'プライバシーポリシー',
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                              onTap: () async {
                                await ref
                                    .read(settingViewModelProvider(key))
                                    .onTapPrivacyPolicy();
                              },
                            ),
                            Container(
                              color: Colors.white,
                              height: 1,
                            ),
                            ListTile(
                              title: const TitleMediumBoldText(
                                'ライセンス',
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                              onTap: () async {
                                await ref
                                    .read(settingViewModelProvider(key))
                                    .onTapLicense();
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 24,
                      ),
                      TitleMediumBoldText(
                        viewModel.appName,
                      ),
                      TitleMediumBoldText(
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
