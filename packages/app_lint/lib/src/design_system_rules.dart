// custom_lint_core の LintCode がまだ ErrorSeverity / ErrorReporter を使うので、
// 新しい名前には移れない。
// ignore_for_file: deprecated_member_use

import 'package:analyzer/error/error.dart' show ErrorSeverity;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// 見た目の定義そのもの。ここだけは素の Flutter を使ってよい。
const _designSystem = {
  '/widget/app_text.dart',
  '/theme/app_colors.dart',
  '/theme/app_theme.dart',
};

bool _isDesignSystem(CustomLintResolver resolver) {
  return _designSystem.any(resolver.path.endsWith);
}

/// `Text` ではなく `AppText` を使わせる。素の `Text` は `style` を自由に渡せて
/// しまい、アプリ全体で見た目がそろわなくなる。
class UseAppText extends DartLintRule {
  const UseAppText() : super(code: _code);

  static const _code = LintCode(
    name: 'use_app_text',
    problemMessage: 'Text ではなく AppText を使う。見た目は AppText に並べたものから選ぶ。',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    if (_isDesignSystem(resolver)) {
      return;
    }
    context.registry.addInstanceCreationExpression((node) {
      if (node.constructorName.type.name.lexeme == 'Text') {
        reporter.atNode(node, _code);
      }
    });
  }
}

/// `TextStyle` を画面で組み立てさせない。文字の大きさ・太さはテーマの型スケール
/// から選ぶ。
class UseTextTheme extends DartLintRule {
  const UseTextTheme() : super(code: _code);

  static const _code = LintCode(
    name: 'use_text_theme',
    problemMessage: 'TextStyle を直接作らない。テーマの型スケール（textTheme）から選ぶ。',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    if (_isDesignSystem(resolver)) {
      return;
    }
    context.registry.addInstanceCreationExpression((node) {
      if (node.constructorName.type.name.lexeme == 'TextStyle') {
        reporter.atNode(node, _code);
      }
    });
  }
}

/// 画面で色を作らせない。色は `ColorName`（colors.xml）に名前を付けてから
/// `Theme` か `AppColors` 経由で使う。
class UseColorToken extends DartLintRule {
  const UseColorToken() : super(code: _code);

  static const _code = LintCode(
    name: 'use_color_token',
    problemMessage: '色を直接作らない。colors.xml に名前を付けて、Theme か AppColors から引く。',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    if (_isDesignSystem(resolver)) {
      return;
    }
    context.registry.addInstanceCreationExpression((node) {
      if (node.constructorName.type.name.lexeme == 'Color') {
        reporter.atNode(node, _code);
      }
    });
  }
}
