import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoDataSource {
  PackageInfoDataSource(this._packageInfo);

  final PackageInfo _packageInfo;

  String get version => _packageInfo.version;
}
