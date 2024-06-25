// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppUser extends Equatable {
  final String uid;
  final String photoURL;
  final String displayName;
  final String email;
  final String phoneNumber;
  final String branchId;

  const AppUser({
    this.uid = '',
    this.photoURL = '',
    this.displayName = '',
    this.email = '',
    this.phoneNumber = '',
    this.branchId = '',
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
      branchId,
    ];
  }

  AppUser copyWith({
    String? uid,
    String? photoURL,
    String? displayName,
    String? email,
    String? phoneNumber,
    String? branchId,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      photoURL: photoURL ?? this.photoURL,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      branchId: branchId ?? this.branchId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'photoURL': photoURL,
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber,
      'branchId': branchId,
    };
  }

  factory AppUser.fromFirebase(User firebaseUser) {
    return AppUser(
        uid: firebaseUser.uid,
        photoURL: firebaseUser.photoURL ?? "",
        displayName: firebaseUser.displayName ?? "",
        email: firebaseUser.email ?? "",
        phoneNumber: firebaseUser.phoneNumber ?? "",
        branchId: '');
  }

  @override
  bool get stringify => true;

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] as String,
      photoURL: map['photoURL'] as String,
      displayName: map['displayName'] as String,
      email: map['email'] as String,
      phoneNumber: map['phoneNumber'] as String,
      branchId: map['branchId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source) as Map<String, dynamic>);
}
