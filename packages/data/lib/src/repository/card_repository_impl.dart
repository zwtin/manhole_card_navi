import 'dart:typed_data';


import 'package:data/src/datasource/card_image_data_source.dart';
import 'package:data/src/datasource/image_load_monitor.dart';
import 'package:data/src/repository/failure_recorder.dart';
import 'package:data/src/datasource/master_data_local_data_source.dart';
import 'package:data/src/mapper/domain_exception_mapper.dart';
import 'package:data/src/mapper/local_card_mapper.dart';
import 'package:data/src/model/local_card_model.dart';
import 'package:domain/domain.dart';

class CardRepositoryImpl implements CardRepository {
  CardRepositoryImpl(
    this._masterData,
    this._cardImage,
    this._imageLoadMonitor,
    this._failureRecorder,
  );

  final MasterDataLocalDataSource _masterData;
  final CardImageDataSource _cardImage;
  final ImageLoadMonitor _imageLoadMonitor;
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

  /// 端末に保存済みならそれを返し、なければ配信元から取って保存する。主系
  /// （Cloudflare R2）で取れなければ、代わりの配信元（Firebase Hosting）から取る。
  /// 一部のネットワークが主系のドメインを遮断するため。
  ///
  /// 失敗は FailureRecorder で記録しない。遮断されている端末では大量に出てほかの
  /// 失敗が埋もれるので、代わりに ImageLoadMonitor（Analytics）で数える。
  @override
  Future<Result<Uint8List>> fetchImage({required String cardId}) async {
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

    final cached = await _cardImage.readCache(card.image) ??
        await _cardImage.readCache(card.imageSub);
    if (cached != null) {
      return Result.success(cached);
    }

    DomainException? failure;
    for (final url in [card.image, card.imageSub]) {
      try {
        return Result.success(await _cardImage.download(url));
      } on Exception catch (error, stackTrace) {
        _imageLoadMonitor.recordFailure(url: url, error: error);
        failure = DomainExceptionMapper.fromHttp(error, stackTrace);
      }
    }
    return Result.failure(failure!);
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
}
