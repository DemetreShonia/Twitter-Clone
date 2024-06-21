import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});
  static route() {
    return MaterialPageRoute(
      builder: (context) => const HomeView(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold();
  }
}
