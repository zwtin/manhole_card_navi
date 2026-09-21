/// Analytics に送るイベント（名前とパラメータ）。
class AnalyticsEventModel {
  const AnalyticsEventModel({required this.name, required this.parameters});

  final String name;
  final Map<String, Object> parameters;
}
