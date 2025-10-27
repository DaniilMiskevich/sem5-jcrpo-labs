import "package:temptune/auth/domain/entities/user.dart";
import "package:temptune/auth/domain/repos/auther_repo.dart";

final class AuthUsecases {
  AuthUsecases(this._auther);

  final AutherRepo _auther;

  User? _user;
  User? get user => _user;

  Future<User> signIn(String email, String password) async {
    _user = await _auther.signIn(email, password);
    return _user!;
  }

  Future<void> signOut() async {
    await _auther.signOut();
    _user = null;
  }
}
