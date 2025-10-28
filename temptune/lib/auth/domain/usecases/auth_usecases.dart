import "dart:async";

import "package:async/async.dart";
import "package:temptune/auth/domain/entities/user.dart";
import "package:temptune/auth/domain/repos/auther_repo.dart";

final class AuthUsecases {
  AuthUsecases(this._auther) {
    _auther.userChanges().forEach((user) {
      _currentUser = user;
      _userChanges.add(user);
    });
  }

  final AutherRepo _auther;

  final _userChanges = StreamController<User?>.broadcast();
  User? _currentUser;
  Stream<User?> get userChanges =>
      StreamGroup.merge([Stream.value(_currentUser), _userChanges.stream]);

  Future<void> signIn(String email, String password) async =>
      _auther.signIn(email, password);
  Future<void> signOut() async => _auther.signOut();
}
