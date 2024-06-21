import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';

final appwriteClientProvider = Provider((ref) {
  Client client = Client();

  return client
      .setEndpoint(AppwriteConstants.endPoint)
      .setProject(AppwriteConstants.projectId)
      .setSelfSigned(status: true); // this is for ignoring ssl certificate
});

final appwriteAccountProvider = Provider((ref) {
  // helps to interact with other providers ref
  final client = ref.watch(appwriteClientProvider);
  return Account(client);
});

final appwriteDatabaseProvider = Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Databases(client);
});
