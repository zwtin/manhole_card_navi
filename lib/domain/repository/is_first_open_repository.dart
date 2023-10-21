import '/domain/entity/is_first_open.dart';
import '/domain/entity/result.dart';

abstract class IsFirstOpenRepository {
  Future<Result<IsFirstOpen>> get();
  Future<Result<void>> set({
    required IsFirstOpen isFirstOpen,
  });
}
