import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/storage_api.dart';
import 'package:twitter_clone/apis/tweet_api.dart';
import 'package:twitter_clone/core/enums/tweet_type_enum.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/models/tweet_model.dart';
import 'package:twitter_clone/models/user_model.dart';

final tweetControllerProvider =
    StateNotifierProvider<TweetController, bool>((ref) {
  return TweetController(
      ref: ref,
      tweetApi: ref.watch(tweetAPIProvider),
      storageAPI: ref.watch(storageAPIProvider));
});

final getTweetsProvider = FutureProvider((ref) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweets();
});

final getRepliesToTweetsProvider = FutureProvider.family((ref, Tweet tweet) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getRepliesToTweet(tweet);
});

final getLatestTweetProvider = StreamProvider.autoDispose((ref) {
  final tweetAPI = ref.watch(tweetAPIProvider);
  return tweetAPI.getLatestTweet();
});

final getTweetByIdProvider = FutureProvider.family((ref, String id) async {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweetById(id);
});

class TweetController extends StateNotifier<bool> {
  final TweetApi _tweetAPI;
  final StorageAPI _storageAPI;
  final Ref _ref;
  TweetController(
      {required Ref ref,
      required TweetApi tweetApi,
      required StorageAPI storageAPI})
      : _ref = ref,
        _tweetAPI = tweetApi,
        _storageAPI = storageAPI,
        super(false);

  Future<List<Tweet>> getTweets() async {
    final tweetList = await _tweetAPI.getTweets();
    return tweetList.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  Future<Tweet> getTweetById(String id) async {
    final tweet = await _tweetAPI.getTweetById(id);
    return Tweet.fromMap(tweet.data);
  }

// if used provider, it will throw error, so just pass user here
  void likeTweet(Tweet tweet, UserModel user) async {
    List<String> likes = tweet.likes;

// so it has already liked and we want to remove like
    if (tweet.likes.contains(user.uid)) {
      likes.remove(user.uid);
    } else {
      likes.add(user.uid);
    }

    tweet = tweet.copyWith(
        likes:
            likes); // modify it, we could use .add for this case, but it is immutable so use copyWith
    final res = await _tweetAPI.likeTweet(tweet);
    res.fold((l) => null, (r) => null); // We do not get any error
    // or any success message after liking.
    // we do not use state = false or something here too
    // since we should not hhave loading screen or smth here
  }

  // if used provider, it will throw error, so just pass user here
  void reshareTweet(
    Tweet tweet,
    UserModel currentUser,
    BuildContext context,
  ) async {
    tweet = tweet.copyWith(
      retweetedBy: currentUser.name,
      likes: [],
      commentIds: [],
      reshareCount: tweet.reshareCount + 1,
    );
    final res = await _tweetAPI.updateReshareCount(tweet);
    res.fold((l) => showSnackBar(context, l.message), (r) async {
      tweet = tweet.copyWith(
          id: ID.unique(), reshareCount: 0, tweetedAt: DateTime.now());
      final res2 = await _tweetAPI.shareTweet(tweet);
      res2.fold((l) => showSnackBar(context, l.message),
          (r) => showSnackBar(context, "Retweeted!"));
    });
  }

  void shareTweet(
      {required List<File> images,
      required String text,
      required BuildContext context,
      required String repliedTo,
      required String repliedToUserId}) {
    if (text.isEmpty) {
      showSnackBar(context, "Please, enter the text!");
    }
    if (images.isNotEmpty) {
      _shareImageTweet(
        images: images,
        text: text,
        context: context,
        repliedTo: repliedTo,
      );
    } else {
      _shareTextTweet(text: text, context: context, repliedTo: repliedTo);
    }
  }

  Future<List<Tweet>> getRepliesToTweet(Tweet tweet) async {
    final documents = await _tweetAPI.getRepliesToTweet(tweet);
    return documents.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  void _shareImageTweet(
      {required List<File> images,
      required String text,
      required BuildContext context,
      required String repliedTo}) async {
    state = true;
    final hashTags = _getHashtagsFromText(text: text);
    String link = _getLinkFromText(text: text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    final imageLinks = await _storageAPI.uploadImage(images);
    Tweet tweet = Tweet(
        text: text,
        hashtags: hashTags,
        link: link,
        imageLinks: imageLinks,
        uid: user.uid,
        tweetType: TweetType.image,
        tweetedAt: DateTime.now(),
        likes: const [],
        commentIds: const [],
        id: "",
        reshareCount: 0,
        retweetedBy: "",
        repliedTo: repliedTo);
    final res = await _tweetAPI.shareTweet(tweet);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  void _shareTextTweet({
    required String text,
    required BuildContext context,
    required String repliedTo,
  }) async {
    state = true;
    final hashTags = _getHashtagsFromText(text: text);
    String link = _getLinkFromText(text: text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    Tweet tweet = Tweet(
        text: text,
        hashtags: hashTags,
        link: link,
        imageLinks: const [],
        uid: user.uid,
        tweetType: TweetType.text,
        tweetedAt: DateTime.now(),
        likes: const [],
        commentIds: const [],
        id: "",
        reshareCount: 0,
        retweetedBy: "",
        repliedTo: repliedTo);
    final res = await _tweetAPI.shareTweet(tweet);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  String _getLinkFromText({required String text}) {
    String link = "";
    List<String> words = text.split(" ");
    for (String w in words) {
      if (w.startsWith("https://") || w.startsWith("www.")) {
        link = w;
      }
    }
    return link;
  }

  List<String> _getHashtagsFromText({required String text}) {
    List<String> hashtags = [];
    List<String> words = text.split(" ");
    for (String w in words) {
      if (w.startsWith("#")) {
        hashtags.add(w);
      }
    }
    return hashtags;
  }
}
