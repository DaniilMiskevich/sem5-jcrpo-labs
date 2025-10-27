import "package:firebase_auth/firebase_auth.dart" as fb;
import "package:temptune/auth/domain/entities/user.dart";
import "package:temptune/auth/domain/repos/auther_repo.dart";

final class FirebaseAutherRepoImpl implements AutherRepo {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;

  @override
  Future<User> signIn(String email, String password) async {
    late final fb.UserCredential credential;
    try {
      credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on fb.FirebaseAuthException {
      credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    }

    final user = credential.user!;
    return User(user.uid, email: user.email ?? email);
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
