import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/auth_api.dart';
import 'package:twitter_clone/core/utils.dart';

// 1:35:00

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(authApi: ref.watch(authAPIProvider));
});

// read and only provider
class AuthController extends StateNotifier<bool> {
  final AuthApi _authApi;

  AuthController({required AuthApi authApi})
      : _authApi = authApi,
        super(false); // default to false
  // isloading?

// if we want to test  model too, remove build context from here,
// we only test api stuff
  void signUp(
      {required String email,
      required String password,
      required BuildContext context}) async {
    // we want to use snackbar in case of error, so use context here too to be able to do that
    state = true;
    final res = await _authApi.signUp(
        email: email, password: password, name: "Demetre");
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) => print(r.email));
  }
}
