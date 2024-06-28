import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:twitter_clone/theme/pallete.dart';

class FollowCount extends StatelessWidget {
  final int count;
  final String text;
  const FollowCount({super.key, required this.count, required this.text});

  @override
  Widget build(BuildContext context) {
    double fontSize = 18;
    return Row(
      children: [
        Text(
          '$count',
          style: TextStyle(
              color: Pallete.whiteColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 3,
        ),
        Text(
          text,
          style: TextStyle(
              color: Pallete.greyColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
