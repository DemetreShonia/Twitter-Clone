import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/core/providers.dart';
import 'package:twitter_clone/models/tweet_model.dart';

final tweetAPIProvider = Provider((ref) {
  return TweetApi(db: ref.watch(appwriteDatabaseProvider));
});

abstract class ITweetAPI {
  FutureEither<Document> shareTweet(Tweet tweet);
  Future<List<Document>> getTweets();
}

class TweetApi implements ITweetAPI {
  final Databases _db;
  TweetApi({required Databases db}) : _db = db;

  @override
  FutureEither<Document> shareTweet(Tweet tweet) async {
    try {
      final document = await _db.createDocument(
          databaseId: AppwriteConstants.dataBaseId,
          collectionId: AppwriteConstants.tweetsCollection,
          documentId: ID.unique(),
          data: tweet.toMap());
      return right(document);
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
  Future<List<Document>> getTweets() async {
    final documents = await _db.listDocuments(
        databaseId: AppwriteConstants.dataBaseId,
        collectionId: AppwriteConstants.tweetsCollection);
    return documents.documents; // to get list version of it
  }
}
