import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/auth_api.dart';
import 'package:twitter_clone/apis/user_api.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/features/auth/view/login_view.dart';
import 'package:twitter_clone/features/home/view/home_view.dart';
import 'package:twitter_clone/models/user_model.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authApi: ref.watch(authAPIProvider),
    userApi: ref.watch(userAPIProvider),
  );
});

final currentUserAccountProvider = FutureProvider((ref) async {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

// read and only provider
class AuthController extends StateNotifier<bool> {
  final AuthApi _authApi;
  final UserApi _userApi;

  AuthController({required AuthApi authApi, required UserApi userApi})
      : _authApi = authApi,
        _userApi = userApi,
        super(false); // default to false
  // isloading?

  Future<User?> currentUser() => _authApi.currentUserAccount();
// if we want to test  model too, remove build context from here,
// we only test api stuff
  void signUp(
      {required String email,
      required String password,
      required BuildContext context}) async {
    // we want to use snackbar in case of error, so use context here too to be able to do that
    state = true;
    final res = await _authApi.signUp(email: email, password: password);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        UserModel userModel = UserModel(
            email: email,
            name: getNameFromEmail(email),
            followers: const [],
            following: const [],
            profilePic: "",
            bannerPic: "",
            uid: "",
            bio: "",
            isTwitterBlue: false);
        final res2 = await _userApi.saveUserData(userModel);
        res2.fold(
          (l) => showSnackBar(context, l.message),
          (_) {
            showSnackBar(context, "Account has been created, please login!");
            Navigator.push(context, LoginView.route());
          },
        );
      },
    );
  }

  void logIn(
      {required String email,
      required String password,
      required BuildContext context}) async {
    state = true;
    final res = await _authApi.logIn(email: email, password: password);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, "Successful Login!");
        Navigator.push(context, HomeView.route());
      },
    );
  }
}
