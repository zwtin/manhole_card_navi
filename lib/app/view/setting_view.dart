import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '/app/view_model/setting_view_model.dart';
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
          title: Text(
            '設定',
            style: Theme.of(context).textTheme.titleLarge,
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
                              title: Text(
                                '利用規約',
                                style: Theme.of(context).textTheme.titleMedium,
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
                              title: Text(
                                'プライバシーポリシー',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                              onTap: () async {
                                showLicensePage(context: context);
                              },
                            ),
                            Container(
                              color: Colors.white,
                              height: 1,
                            ),
                            ListTile(
                              title: Text(
                                'ライセンス',
                                style: Theme.of(context).textTheme.titleMedium,
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
                      Text(
                        'バージョン ${viewModel.currentAppVersion}',
                        style: Theme.of(context).textTheme.titleMedium,
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
