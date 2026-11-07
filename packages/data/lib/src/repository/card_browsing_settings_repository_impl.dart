import 'package:data/src/datasource/crashlytics_data_source.dart';
import 'package:data/src/datasource/preferences_data_source.dart';
import 'package:data/src/mapper/card_browsing_settings_mapper.dart';
import 'package:data/src/mapper/domain_exception_mapper.dart';
import 'package:data/src/model/search_condition_model.dart';
import 'package:domain/domain.dart';

/// 検索条件とマップの表示は、1 つのキーに 1 つの JSON で保存する。片方だけ
/// 保存された状態を作らないため。キーと JSON の形は、2 つを分ける前の
/// 「検索条件」のときのまま。
class CardBrowsingSettingsRepositoryImpl
    implements CardBrowsingSettingsRepository {
  CardBrowsingSettingsRepositoryImpl(this._preferences, this._crashlytics);

  static const _key = 'search_condition';

  final PreferencesDataSource _preferences;
  final CrashlyticsDataSource _crashlytics;

  @override
  Stream<CardBrowsingSettings> watch() {
    return _preferences.watchString(_key).map(_toSettings);
  }

  @override
  Future<Result<void>> save({required CardBrowsingSettings settings}) async {
    try {
      final saved = await _preferences.writeString(
        _key,
        CardBrowsingSettingsMapper.toModel(settings).toJsonString(),
      );
      if (!saved) {
        throw const PersistenceException(detail: '検索条件を保存できませんでした');
      }
      return const Result.success(null);
    } on Exception catch (error, stackTrace) {
      _crashlytics.recordNonFatal(error, stackTrace);
      return Result.failure(DomainExceptionMapper.from(error));
    }
  }

  /// 壊れていても、絞り込みなしで使い続けられるようにする。次に保存すれば直る。
  CardBrowsingSettings _toSettings(String source) {
    try {
      return CardBrowsingSettingsMapper.toCardBrowsingSettings(
        SearchConditionModel.fromJsonString(source),
      );
    } on Exception catch (error, stackTrace) {
      _crashlytics.recordNonFatal(error, stackTrace);
      return CardBrowsingSettings.initial();
    }
  }
}
