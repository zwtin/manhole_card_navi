import '/domain/entity/is_first_open.dart';
import '/domain/entity/result.dart';

abstract class FirstOpenRepository {
  Future<Result<IsFirstOpen>> getIsFirstOpen();
  Future<Result<void>> setIsFirstOpen({
    required IsFirstOpen isFirstOpen,
  });
}
