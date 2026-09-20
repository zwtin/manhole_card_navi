import 'dart:typed_data';


import 'package:data/src/datasource/card_image_data_source.dart';
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
    this._failureRecorder,
  );

  final MasterDataLocalDataSource _masterData;
  final CardImageDataSource _cardImage;
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

  /// 画像の取得の失敗は FailureRecorder で記録しない。ImageLoadMonitor と表示側の
  /// FlutterError で記録済みで、遮断されている端末では大量に出てほかの失敗が埋もれる。
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
    try {
      return Result.success(
        await _cardImage.fetch(
          url: card.image,
          subUrl: card.imageSub,
          maxWidth: maxWidth,
        ),
      );
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
}
