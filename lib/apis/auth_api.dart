import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/core.dart';

abstract class IAuthApi {
  FutureEither<User> signUp(
      {required String email, required String password, required String name});
}

class AuthApi implements IAuthApi {
  final Account _account;
  AuthApi({required account}) : _account = account;

  @override
  FutureEither<User> signUp(
      {required String email,
      required String password,
      required String name}) async {
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
}
