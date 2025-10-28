import "dart:async";

import "package:firebase_auth/firebase_auth.dart" as fb;
import "package:temptune/auth/domain/entities/user.dart";
import "package:temptune/auth/domain/repos/auther_repo.dart";

final class FirebaseAutherRepoImpl implements AutherRepo {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;

  @override
  Stream<User?> userChanges() =>
      _auth.userChanges().map((fbUser) => fbUser?.toDomain());

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on fb.FirebaseAuthException {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

extension on fb.User {
  User toDomain() => User(uid, email: email!);
}
