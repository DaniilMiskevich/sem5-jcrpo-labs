import "dart:async";

import "package:temptune/auth/domain/entities/user.dart";
import "package:temptune/auth/domain/repos/auther_repo.dart";

final class MockAutherRepoImpl implements AutherRepo {
  final _map = <(String, String), User>{};
  final _userChanges = StreamController<User?>.broadcast();

  @override
  Stream<User?> userChanges() => _userChanges.stream;

  @override
  Future<void> signIn(String email, String password) async {
    var user = _map[(email, password)];
    if (user == null) {
      user = User(
        DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
      );
      _map[(email, password)] = user;
    }
    _userChanges.add(user);
  }

  @override
  Future<void> signOut() async => _userChanges.add(null);
}
