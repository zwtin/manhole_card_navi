import 'package:firebase_auth/firebase_auth.dart';

/// 利用者の認証。返すのは利用者の ID だけで、SDK の型は外に出さない。
class AuthDataSource {
  AuthDataSource(this._auth);

  final FirebaseAuth _auth;

  /// まだログインしていなければ null。
  String? get currentUserId => _auth.currentUser?.uid;

  Future<String?> signInAnonymously() async {
    return (await _auth.signInAnonymously()).user?.uid;
  }
}
