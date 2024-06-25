import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:petcare_staff/src/constants/app_colors.dart';
import 'package:petcare_staff/src/layers/domain/app_user.dart';
import 'package:petcare_staff/src/routing/app_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository(this._auth, this._firestore);
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Stream<User?> authStateChanges() => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<String?> permissionGranted(String email) async => await _firestore
      .collection('branch')
      .where('staffs', arrayContains: email)
      .get()
      .then((querySnapshot) =>
          querySnapshot.docs.isEmpty ? null : querySnapshot.docs[0].id);

  Future<bool> isRegistered(String email) async => await _firestore
      .collection('staff')
      .where('email', isEqualTo: email)
      .get()
      .then((snapshot) => snapshot.docs.isNotEmpty);

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await _auth.signInWithCredential(credential).then(
          (userCredential) async =>
              await permissionGranted(userCredential.user!.email!)
                  .then((branchId) async {
            if (branchId != null) {
              await isRegistered(userCredential.user!.email!).then(
                (isRegistered) async {
                  if (!isRegistered) {
                    await _firestore
                        .collection('staff')
                        .doc(userCredential.user!.uid)
                        .set(AppUser(
                          uid: userCredential.user!.uid,
                          photoURL: userCredential.user!.photoURL ?? '',
                          displayName: userCredential.user!.displayName ?? '',
                          email: userCredential.user!.email ?? '',
                          phoneNumber: userCredential.user!.phoneNumber ?? '',
                          branchId: branchId,
                          startDate: DateTime.now(),
                          onTask: '',
                        ).toMap());
                  }
                  Fluttertoast.showToast(
                    msg: 'Authenticated successfully as staff.',
                    backgroundColor: AppColors.blue500,
                    timeInSecForIosWeb: 4,
                  );
                },
              );
            } else {
              await _auth.signOut().then((_) => Fluttertoast.showToast(
                    msg: 'This email is not granted permission as staff.',
                    backgroundColor: AppColors.red500,
                    timeInSecForIosWeb: 4,
                  ));
            }
          }),
        );
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
    AuthRepository(ref.watch(firebaseAuthProvider), FirebaseFirestore.instance);

@riverpod
Stream<User?> authStateChanges(AuthStateChangesRef ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
}
