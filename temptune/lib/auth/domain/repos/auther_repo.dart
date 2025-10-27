import "package:temptune/auth/domain/entities/user.dart";

abstract interface class AutherRepo {
  Future<User> signIn(String email, String password);
  Future<void> signOut();
}
