// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:const_date_time/const_date_time.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppUser extends Equatable {
  final String uid;
  final String photoURL;
  final String displayName;
  final String email;
  final String phoneNumber;
  final String branchId;
  final DateTime startDate;
  final String onTask;

  const AppUser({
    this.uid = '',
    this.photoURL = '',
    this.displayName = '',
    this.email = '',
    this.phoneNumber = '',
    this.branchId = '',
    this.startDate = const ConstDateTime(1000, 1, 1),
    this.onTask = '',
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
      startDate,
      onTask,
    ];
  }

  AppUser copyWith({
    String? uid,
    String? photoURL,
    String? displayName,
    String? email,
    String? phoneNumber,
    String? branchId,
    DateTime? startDate,
    String? onTask,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      photoURL: photoURL ?? this.photoURL,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      branchId: branchId ?? this.branchId,
      startDate: startDate ?? this.startDate,
      onTask: onTask ?? this.onTask,
    );
  }

  Map<String, dynamic> toFirebaseMap() {
    return <String, dynamic>{
      'uid': uid,
      'photoURL': photoURL,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'photoURL': photoURL,
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber,
      'branchId': branchId,
      'startDate': Timestamp.fromDate(startDate),
      'onTask': onTask,
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

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] as String,
      photoURL: map['photoURL'] as String,
      displayName: map['displayName'] as String,
      email: map['email'] as String,
      phoneNumber: map['phoneNumber'] as String,
      branchId: map['branchId'] as String,
      startDate: (map['startDate'] as Timestamp).toDate(),
      onTask: map['onTask'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source) as Map<String, dynamic>);
}
