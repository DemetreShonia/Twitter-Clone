import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/core/providers.dart';
import 'package:twitter_clone/models/user_model.dart';

final userAPIProvider = Provider((ref) {
  return UserApi(db: ref.watch(appwriteDatabaseProvider));
});

abstract class IUserAPI {
  FutureEitherVoid saveUserData(UserModel userModel);
}

class UserApi implements IUserAPI {
  final Databases _db;

  UserApi({required Databases db}) : _db = db;
  @override
  FutureEitherVoid saveUserData(UserModel userModel) async {
    try {
      await _db.createDocument(
          databaseId: AppwriteConstants.dataBaseId,
          collectionId: AppwriteConstants.usersCollection,
          documentId: ID.unique(),
          data: userModel.toMap());
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(Failure(
        e.message ?? "Some unexpected error occurred",
        st,
      ));
    } catch (e, st) {
      return left(Failure(
        e.toString(),
        st,
      ));
    }
  }
}
