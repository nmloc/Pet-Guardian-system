import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petcare_staff/src/layers/domain/branch.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'branch_repository.g.dart';

class BranchRepository {
  BranchRepository(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Branch> queryBranches() =>
      _firestore.collection('branch').withConverter<Branch>(
            fromFirestore: (snapshot, _) => Branch.fromMap(snapshot.data()!),
            toFirestore: (branch, _) => branch.toMap(),
          );

  Stream<Branch> watch(String branchId) => queryBranches()
      .doc(branchId)
      .snapshots()
      .map((branchDoc) => branchDoc.data()!);

  Stream<List<Branch>> watchBranches() =>
      queryBranches().snapshots().map((snapshot) =>
          snapshot.docs.map((branchDoc) => branchDoc.data()).toList());
}

@riverpod
BranchRepository branchRepository(BranchRepositoryRef ref) =>
    BranchRepository(FirebaseFirestore.instance);
