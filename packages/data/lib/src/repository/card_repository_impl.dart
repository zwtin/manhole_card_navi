import 'dart:typed_data';

import 'package:domain/domain.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:logger/logger.dart';

import '../datasource/card_image_cache_manager.dart';
import '../datasource/failure_recorder.dart';
import '../datasource/image_fallback.dart';
import '../datasource/master_data_local_data_source.dart';
import '../mapper/domain_exception_mapper.dart';
import '../mapper/local_card_mapper.dart';
import '../model/local_card_model.dart';

/// 端末に取り込んだカードと、その画像。
///
/// カードは端末の JSON ファイル（[MasterDataLocalDataSource]）から、画像は配信元から
/// 取って端末に保存したもの（[CardImageCacheManager]）から読む。
class CardRepositoryImpl implements CardRepository {
  CardRepositoryImpl(
    this._masterData,
    this._imageCacheManager,
    this._failureRecorder,
  );

  final _logger = Logger();
  final MasterDataLocalDataSource _masterData;
  final CardImageCacheManager _imageCacheManager;
  final FailureRecorder _failureRecorder;

  @override
  Future<Result<ManholeCard>> get({
    required String id,
  }) {
    return _failureRecorder.guard(
      () async => LocalCardMapper.toCard(await _find(id)),
      convert: DomainExceptionMapper.fromLocalStorage,
    );
  }

  @override
  Future<Result<List<ManholeCard>>> fetchAll() {
    return _failureRecorder.guard(
      () async => [
        for (final card in await _readAll()) LocalCardMapper.toCard(card),
      ],
      convert: DomainExceptionMapper.fromLocalStorage,
    );
  }

  /// 画像の取得の失敗は、ほかと違い FailureRecorder で記録しない。画像の失敗は
  /// ImageLoadMonitor（Analytics）と、表示側の FlutterError（Crashlytics の非重大）で
  /// 記録している。遮断されている端末では画像の失敗が大量に出るので、ここでも記録
  /// すると二重になるうえ、ほかの失敗の記録が埋もれる。
  ///
  /// 取った画像はすべて端末に保存する（一覧・詳細・マップのマーカーで使い回す）。
  @override
  Future<Result<Uint8List>> fetchImage({
    required String cardId,
    int? maxWidth,
  }) async {
    final LocalCardModel card;
    switch (await _failureRecorder.guard(
      () => _find(cardId),
      convert: DomainExceptionMapper.fromLocalStorage,
    )) {
      case Failure(:final exception):
        return Result.failure(exception);
      case Success(:final value):
        card = value;
    }
    if (card.image.isEmpty) {
      return Result.failure(
        NotFoundException(detail: 'ID が $cardId のカードに画像の URL がありません'),
      );
    }
    try {
      // 端末に保存済みなら、期限が切れていても先にそれが流れてくる（取り直しは
      // その後ろで行われ、失敗しても保存済みの画像は出せる）。最初の 1 件だけ使う。
      // R2 で取れなければ代わりの配信元（Hosting）から取る（ImageFallback）。
      final response = await _imageCacheManager
          .getImageFile(
            card.image,
            headers: ImageFallback.headers(card.imageSub),
            maxWidth: maxWidth,
          )
          .firstWhere((response) => response is FileInfo);
      final file = (response as FileInfo).file;
      return Result.success(await file.readAsBytes());
    } on Exception catch (error, stackTrace) {
      return Result.failure(
        DomainExceptionMapper.fromHttp(error, stackTrace),
      );
    }
  }

  Future<LocalCardModel> _find(String id) async {
    final card = (await _readAll()).where((card) => card.id == id);
    if (card.isEmpty) {
      throw NotFoundException(detail: 'ID が $id のカードが端末にありません');
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

  void dispose() {
    _logger.d('CardRepositoryImpl dispose');
  }
}
