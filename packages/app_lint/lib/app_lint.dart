import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'src/design_system_rules.dart';

PluginBase createPlugin() => _AppLint();

class _AppLint extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => const [
        UseAppText(),
        UseTextTheme(),
        UseColorToken(),
      ];
}
