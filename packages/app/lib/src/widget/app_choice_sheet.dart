import 'package:flutter/material.dart';

import 'package:app/src/widget/app_text.dart';

/// 画面の下から選択肢を出し、選ばれたものが [options] の何番目かを返す。選ばずに
/// 閉じたら null。
///
/// [context] には root Navigator の context を渡す。
Future<int?> showAppChoiceSheet(
  BuildContext context, {
  required List<String> options,
}) {
  return showModalBottomSheet<int>(
    context: context,
    builder: (sheetContext) {
      return SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final (index, option) in options.indexed)
                ListTile(
                  title: AppText.titleMedium(option),
                  tileColor: Colors.transparent,
                  onTap: () => Navigator.of(sheetContext).pop(index),
                ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      );
    },
  );
}
