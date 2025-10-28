import "package:temptune/auth/domain/entities/user.dart";

abstract interface class AutherRepo {
  Stream<User?> userChanges();

  Future<void> signIn(String email, String password);
  Future<void> signOut();
}
