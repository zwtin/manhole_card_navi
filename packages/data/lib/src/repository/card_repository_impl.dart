import 'dart:async';
import 'dart:typed_data';

import 'package:data/src/datasource/analytics_data_source.dart';
import 'package:data/src/datasource/card_image_data_source.dart';
import 'package:data/src/datasource/crashlytics_data_source.dart';
import 'package:data/src/datasource/master_data_local_data_source.dart';
import 'package:data/src/mapper/analytics_event_mapper.dart';
import 'package:data/src/mapper/domain_exception_mapper.dart';
import 'package:data/src/mapper/local_card_mapper.dart';
import 'package:data/src/model/local_card_model.dart';
import 'package:domain/domain.dart';

class CardRepositoryImpl implements CardRepository {
  CardRepositoryImpl(
    this._masterData,
    this._cardImage,
    this._analytics,
    this._crashlytics,
  );

  final MasterDataLocalDataSource _masterData;
  final CardImageDataSource _cardImage;
  final AnalyticsDataSource _analytics;
  final CrashlyticsDataSource _crashlytics;

  @override
  Future<Result<ManholeCard>> get({
    required String id,
  }) async {
    try {
      return Result.success(LocalCardMapper.toCard(await _find(id)));
    } on Exception catch (error, stackTrace) {
      _crashlytics.recordNonFatal(error, stackTrace);
      return Result.failure(DomainExceptionMapper.from(error));
    }
  }

  @override
  Future<Result<List<ManholeCard>>> fetchAll() async {
    try {
      return Result.success([
        for (final card in await _readAll()) LocalCardMapper.toCard(card),
      ]);
    } on Exception catch (error, stackTrace) {
      _crashlytics.recordNonFatal(error, stackTrace);
      return Result.failure(DomainExceptionMapper.from(error));
    }
  }

  /// 端末に保存済みならそれを返し、なければ配信元から取って保存する。主系
  /// （Cloudflare R2）で取れなければ、代わりの配信元（Firebase Hosting）から取る。
  /// 一部のネットワークが主系のドメインを遮断するため。
  ///
  /// 取得の失敗は Crashlytics に記録しない。非重大の 1 セッション 8 件の枠を
  /// 使い切り、ほかの失敗が押し出されるため。
  @override
  Future<Result<Uint8List>> fetchImage({required String cardId}) async {
    final LocalCardModel card;
    final Uint8List? cached;
    try {
      card = await _find(cardId);
      cached = await _cardImage.readCache(card.image) ??
          await _cardImage.readCache(card.imageSub);
    } on Exception catch (error, stackTrace) {
      _crashlytics.recordNonFatal(error, stackTrace);
      return Result.failure(DomainExceptionMapper.from(error));
    }
    if (cached != null) {
      return Result.success(cached);
    }

    late Exception failure;
    for (final url in [card.image, card.imageSub]) {
      try {
        return Result.success(await _cardImage.download(url));
      } on Exception catch (error) {
        _send(AnalyticsEventMapper.toImageLoadFailed(url: url, error: error));
        failure = error;
      }
    }
    return Result.failure(DomainExceptionMapper.from(failure));
  }

  /// 計測を待たず、送れなくても画像の取得は続ける。
  void _send(AnalyticsEvent event) {
    unawaited(
      // Error はバグなので捨てずに流し、根でクラッシュとして記録させる。
      _analytics.send(AnalyticsEventMapper.toModel(event)).onError<Exception>(
            _crashlytics.recordNonFatal,
          ),
    );
  }

  Future<LocalCardModel> _find(String id) async {
    final card = (await _readAll()).where((card) => card.id == id);
    if (card.isEmpty) {
      throw const NotFoundException(detail: 'そのカードが端末にありません');
    }
    return card.first;
  }

  Future<List<LocalCardModel>> _readAll() async {
    final cards = await _masterData.readAll();
    if (cards == null || cards.isEmpty) {
      throw const NotFoundException(detail: '端末にマスターデータがありません');
    }
    return cards;
  }
}
