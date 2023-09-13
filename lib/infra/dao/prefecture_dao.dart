import 'package:freezed_annotation/freezed_annotation.dart';

part 'prefecture_dao.freezed.dart';
part 'prefecture_dao.g.dart';

@freezed
abstract class PrefectureDAO implements _$PrefectureDAO {
  const factory PrefectureDAO({
    required String id,
    required String name,
  }) = _PrefectureDAO;

  const PrefectureDAO._();

  factory PrefectureDAO.fromJson(Map<String, dynamic> json) =>
      _$PrefectureDAOFromJson(json);
}
