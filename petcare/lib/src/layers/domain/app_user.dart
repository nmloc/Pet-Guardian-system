// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppUser extends Equatable {
  final String uid;
  final String photoURL;
  final String displayName;
  final String email;
  final String phoneNumber;

  const AppUser({
    this.uid = '',
    this.photoURL = '',
    this.displayName = '',
    this.email = '',
    this.phoneNumber = '',
  });

  @override
  // TODO: implement props
  List<Object> get props {
    return [
      uid,
      photoURL,
      displayName,
      email,
      phoneNumber,
    ];
  }

  AppUser copyWith({
    String? uid,
    String? photoURL,
    String? displayName,
    String? email,
    String? phoneNumber,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      photoURL: photoURL ?? this.photoURL,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'photoURL': photoURL,
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }

  factory AppUser.fromFirebase(User firebaseUser) {
    return AppUser(
      uid: firebaseUser.uid,
      photoURL: firebaseUser.photoURL ?? "",
      displayName: firebaseUser.displayName ?? "",
      email: firebaseUser.email ?? "",
      phoneNumber: firebaseUser.phoneNumber ?? "",
    );
  }

  @override
  bool get stringify => true;
}
