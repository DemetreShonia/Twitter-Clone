import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:twitter_clone/common/common.dart";
import "package:twitter_clone/constants/assets_constants.dart";
import "package:twitter_clone/features/auth/controller/auth_controller.dart";
import "package:twitter_clone/theme/pallete.dart";

class CreateTweetScreen extends ConsumerStatefulWidget {
  static route() {
    return MaterialPageRoute(
      builder: (context) => const CreateTweetScreen(),
    );
  }

  const CreateTweetScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateTweetScreenState();
}

class _CreateTweetScreenState extends ConsumerState<CreateTweetScreen> {
  final TweetTextController = TextEditingController();

  @override
  void dispose() {
    TweetTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close, size: 30),
        ),
        actions: [
          RoundedSmallButton(
            onTap: () {},
            label: "Tweet",
            backgroundColor: Pallete.blueColor,
            textColor: Pallete.whiteColor,
          ),
        ],
      ),
      body: currentUser == null
          ? const LoadingPage()
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(currentUser.profilePic),
                          radius: 30,
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: TextField(
                            controller: TweetTextController,
                            style: const TextStyle(fontSize: 22),
                            decoration: const InputDecoration(
                                hintText: "What's happening?",
                                hintStyle: TextStyle(color: Pallete.greyColor),
                                border: InputBorder.none),
                            maxLines: null,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 15),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Pallete.greyColor, width: 0.3),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8).copyWith(left: 15, right: 15),
              child: SvgPicture.asset(AssetsConstants.galleryIcon),
            ),
            Padding(
              padding: const EdgeInsets.all(8).copyWith(left: 15, right: 15),
              child: SvgPicture.asset(AssetsConstants.gifIcon),
            ),
            Padding(
              padding: const EdgeInsets.all(8).copyWith(left: 15, right: 15),
              child: SvgPicture.asset(AssetsConstants.emojiIcon),
            ),
          ],
        ),
      ),
    );
  }
}
