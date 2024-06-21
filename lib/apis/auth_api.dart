import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/core/providers.dart';

abstract class IAuthApi {
  FutureEither<User> signUp({
    required String email,
    required String password,
  });
  FutureEither<Session> logIn(
      {required String email, required String password});
}

// provider provides read only value
// there are other type of Providers too
// state provider and state notifier provider gives ability to
// read and write
final authAPIProvider = Provider((ref) {
  Account account = ref.watch(appwriteAccountProvider);
  return AuthApi(account: account);
});

class AuthApi implements IAuthApi {
  final Account _account;
  AuthApi({required account}) : _account = account;

  @override
  FutureEither<User> signUp({
    required String email,
    required String password,
  }) async {
    try {
      // appwrite will generate unique id "unique()"
      final account = await _account.create(
          userId: ID.unique(), email: email, password: password);

      return right(account); // Either's right, so success
    } on AppwriteException catch (e, stacktrace) {
      // either's left, so failure
      return left(
          Failure(e.message ?? "Some unexpected error occured", stacktrace));
    } catch (e, stacktrace) {
      // either's left, so failure
      return left(Failure(e.toString(), stacktrace));
    }
  }

  @override
  FutureEither<Session> logIn({
    required String email,
    required String password,
  }) async {
    try {
      // appwrite will generate unique id "unique()"
      final session = await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      return right(session); // Either's right, so success
    } on AppwriteException catch (e, stacktrace) {
      // either's left, so failure
      return left(
          Failure(e.message ?? "Some unexpected error occured", stacktrace));
    } catch (e, stacktrace) {
      // either's left, so failure
      return left(Failure(e.toString(), stacktrace));
    }
  }
}
