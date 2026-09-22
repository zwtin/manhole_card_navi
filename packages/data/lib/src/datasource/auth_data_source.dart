import 'package:firebase_auth/firebase_auth.dart';

class AuthDataSource {
  AuthDataSource(this._auth);

  final FirebaseAuth _auth;

  /// まだログインしていなければ null。
  String? get currentUserId => _auth.currentUser?.uid;

  Future<String?> signInAnonymously() async {
    return (await _auth.signInAnonymously()).user?.uid;
  }
}
