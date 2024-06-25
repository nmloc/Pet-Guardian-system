import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:petcare/src/routing/app_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository(this._auth);
  final FirebaseAuth _auth;

  Stream<User?> authStateChanges() => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<bool> isNewUser() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('pet owner')
        .where('email', isEqualTo: _auth.currentUser!.email)
        .get();

    return querySnapshot.docs.isEmpty;
  }

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    try {
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<User?> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();

    if (loginResult.accessToken != null) {
      final credential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      final res = await _auth.signInWithCredential(credential);
      return res.user;
    }

    return null;
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> signInWithApple() async {
    // try {
    //   final rawNonce = generateNonce();
    //   final nonce = sha256ofString(rawNonce);

    //   // Request credential for the currently signed in Apple account.
    //   final credential = await SignInWithApple.getAppleIDCredential(
    //     scopes: [
    //       AppleIDAuthorizationScopes.email,
    //       AppleIDAuthorizationScopes.fullName,
    //     ],
    //     nonce: nonce,
    //   );

    //   // Create an `OAuthCredential` from the credential returned by Apple.
    //   final oauthCredential = OAuthProvider("apple.com").credential(
    //     idToken: credential.identityToken,
    //     rawNonce: rawNonce,
    //   );

    //   await _auth
    //       .signInWithCredential(oauthCredential)
    //       .then((res) async => updateFirebaseUser(await getAppUser(res.user!)));
    // } on FirebaseAuthException catch (e) {
    //   snackbarKey.currentState?.showSnackBar(
    //       SnackBar(content: Text('Apple Sign In error: ${e.message!}')));
    // }
  }

  Future<void> signOut() async {
    try {
      await FacebookAuth.instance.logOut();
      await GoogleSignIn().disconnect();
      await GoogleSignIn().signOut();
      await _auth.signOut();
    } catch (PlatFormException) {
      print(PlatFormException.toString());
      snackbarKey.currentState
          ?.showSnackBar(SnackBar(content: Text(PlatFormException.toString())));
    }
  }
}

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) {
  return FirebaseAuth.instance;
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) =>
    AuthRepository(ref.watch(firebaseAuthProvider));

@riverpod
Stream<User?> authStateChanges(AuthStateChangesRef ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
}
