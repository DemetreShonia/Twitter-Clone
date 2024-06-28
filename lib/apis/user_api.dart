import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/core/providers.dart';
import 'package:twitter_clone/models/user_model.dart';

final userAPIProvider = Provider((ref) {
  return UserApi(
      db: ref.watch(appwriteDatabaseProvider),
      realtime: ref.watch(appwriteRealtimeProvider));
});

abstract class IUserAPI {
  FutureEitherVoid saveUserData(UserModel userModel);
  Future<Document> getUserData(String uid);
  Future<List<Document>> searchUserByName(String name);
  FutureEitherVoid updateUserData(UserModel userModel);
  Stream<RealtimeMessage> getLatestUserProfileData();
}

class UserApi implements IUserAPI {
  final Databases _db;
  final Realtime _realtime;

  UserApi({required Realtime realtime, required Databases db})
      : _realtime = realtime,
        _db = db;
  @override
  FutureEitherVoid saveUserData(UserModel userModel) async {
    try {
      await _db.createDocument(
          databaseId: AppwriteConstants.dataBaseId,
          collectionId: AppwriteConstants.usersCollection,
          documentId: userModel.uid,
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

  @override
  Future<Document> getUserData(String uid) {
    return _db.getDocument(
        databaseId: AppwriteConstants.dataBaseId,
        collectionId: AppwriteConstants.usersCollection,
        documentId: uid);
  }

  @override
  Future<List<Document>> searchUserByName(String name) async {
    final documents = await _db.listDocuments(
        databaseId: AppwriteConstants.dataBaseId,
        collectionId: AppwriteConstants.usersCollection,
        queries: [
          Query.search('name', name),
        ]);
    return documents.documents;
  }

  @override
  FutureEitherVoid updateUserData(UserModel userModel) async {
    try {
      await _db.updateDocument(
          databaseId: AppwriteConstants.dataBaseId,
          collectionId: AppwriteConstants.usersCollection,
          documentId: userModel.uid,
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

  @override
  Stream<RealtimeMessage> getLatestUserProfileData() {
    // this is second approach we can do specific user too!
//      'databases.${AppwriteConstants.dataBaseId}.collections.${AppwriteConstants.usersCollection}.documents.$uid'

    return _realtime.subscribe([
      'databases.${AppwriteConstants.dataBaseId}.collections.${AppwriteConstants.usersCollection}.documents'
    ]).stream;
  }
}
