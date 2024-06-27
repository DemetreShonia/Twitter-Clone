import 'package:flutter/material.dart';
import 'package:twitter_clone/theme/pallete.dart';

class HashtagText extends StatelessWidget {
  final String text;
  const HashtagText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textSpans = [];

    text.split(' ').forEach((element) {
      if (element.startsWith("#")) {
        textSpans.add(
          TextSpan(
              text: '$element ',
              style: const TextStyle(color: Pallete.blueColor, fontSize: 18)),
        );
      } else if (element.startsWith("www.") || element.startsWith("https://"))
        ;
      else {
        textSpans.add(
          TextSpan(text: '$element ', style: const TextStyle(fontSize: 18)),
        );
      }
    });
    return RichText(text: TextSpan(children: textSpans));
  }
}
