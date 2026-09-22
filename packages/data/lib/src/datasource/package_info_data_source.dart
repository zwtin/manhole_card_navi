import 'package:package_info_plus/package_info_plus.dart';

/// 端末に入っているアプリ自身の情報。
class PackageInfoDataSource {
  PackageInfoDataSource(this._packageInfo);

  final PackageInfo _packageInfo;

  String get version => _packageInfo.version;
}
