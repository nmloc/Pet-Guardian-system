// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Staff extends Equatable {
  final String uid;
  final String branchId;
  final String displayName;
  final String email;
  final String onTask;
  final String phoneNumber;
  final String photoURL;
  final DateTime startDate;
  const Staff({
    required this.uid,
    required this.branchId,
    required this.displayName,
    required this.email,
    required this.onTask,
    required this.phoneNumber,
    required this.photoURL,
    required this.startDate,
  });

  Staff copyWith({
    String? uid,
    String? branchId,
    String? displayName,
    String? email,
    String? onTask,
    String? phoneNumber,
    String? photoURL,
    DateTime? startDate,
  }) {
    return Staff(
      uid: uid ?? this.uid,
      branchId: branchId ?? this.branchId,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      onTask: onTask ?? this.onTask,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoURL: photoURL ?? this.photoURL,
      startDate: startDate ?? this.startDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'branchId': branchId,
      'displayName': displayName,
      'email': email,
      'onTask': onTask,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'startDate': Timestamp.fromDate(startDate),
    };
  }

  factory Staff.fromMap(Map<String, dynamic> map) {
    return Staff(
      uid: map['uid'] as String,
      branchId: map['branchId'] as String,
      displayName: map['displayName'] as String,
      email: map['email'] as String,
      onTask: map['onTask'] as String,
      phoneNumber: map['phoneNumber'] as String,
      photoURL: map['photoURL'] as String,
      startDate: (map['startDate'] as Timestamp).toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Staff.fromJson(String source) =>
      Staff.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      uid,
      branchId,
      displayName,
      email,
      onTask,
      phoneNumber,
      photoURL,
      startDate,
    ];
  }
}
