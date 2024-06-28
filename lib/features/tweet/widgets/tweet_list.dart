import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_clone/models/tweet_model.dart';

class TweetList extends ConsumerWidget {
  const TweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getTweetsProvider).when(
        data: (tweets) {
          return ref.watch(getLatestTweetProvider).when(
                data: (data) {
                  if (data.events.contains(
                    'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.create',
                  )) {
                    // if data was created, * is any databases
                    // print data.events for better understanding

                    // if created, show it up in the tweets
                    tweets.insert(0, Tweet.fromMap(data.payload));
                  } else if (data.events.contains(
                    'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.update',
                  )) {
                    // some shitty logic to get INDEX OF NEWLY ADDED, search in string for id...

                    // get id of tweet, remove it
                    // place new tweet there, it is update!
                    final startingPoint =
                        data.events[0].lastIndexOf("documents.");
                    final endPoint = data.events[0].lastIndexOf(".update");
                    final tweetId = data.events[0].substring(
                      startingPoint + 10,
                      endPoint,
                    );

                    // find id
                    var tweet =
                        tweets.where((element) => element.id == tweetId).first;
                    final tweetIndex = tweets.indexOf(tweet);
                    tweets.removeWhere((e) => e.id == tweet.id);
                    tweet = Tweet.fromMap(data.payload);
                    tweets.insert(tweetIndex, tweet);
                  }
                  return ListView.builder(
                    itemCount: tweets.length,
                    itemBuilder: (context, index) {
                      final tweet = tweets[index];
                      return TweetCard(
                        tweet: tweet,
                      );
                    },
                  );
                },
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
                loading: () {
                  return ListView.builder(
                    itemCount: tweets.length,
                    itemBuilder: (context, index) {
                      final tweet = tweets[index];
                      return TweetCard(
                        tweet: tweet,
                      );
                    },
                  );
                },
              );
        },
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}
