// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Staff extends Equatable {
  final String uid;
  final String photoURL;
  final String displayName;
  final String email;
  final String phoneNumber;
  final String branchId;
  final DateTime startDate;
  const Staff({
    required this.uid,
    required this.photoURL,
    required this.displayName,
    required this.email,
    required this.phoneNumber,
    required this.branchId,
    required this.startDate,
  });

  Staff copyWith({
    String? uid,
    String? photoURL,
    String? displayName,
    String? email,
    String? phoneNumber,
    String? branchId,
    DateTime? startDate,
  }) {
    return Staff(
      uid: uid ?? this.uid,
      photoURL: photoURL ?? this.photoURL,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      branchId: branchId ?? this.branchId,
      startDate: startDate ?? this.startDate,
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
      'startDate': Timestamp.fromDate(startDate),
    };
  }

  factory Staff.fromMap(Map<String, dynamic> map) {
    return Staff(
      uid: map['uid'] as String,
      photoURL: map['photoURL'] as String,
      displayName: map['displayName'] as String,
      email: map['email'] as String,
      phoneNumber: map['phoneNumber'] as String,
      branchId: map['branchId'] as String,
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
      photoURL,
      displayName,
      email,
      phoneNumber,
      branchId,
      startDate,
    ];
  }
}
