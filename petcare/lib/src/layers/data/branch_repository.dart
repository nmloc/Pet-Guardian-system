import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petcare/src/layers/domain/branch.dart';
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

  Stream<Branch> watchBranch(String branchId) =>
      queryBranches().doc(branchId).snapshots().map((branchDoc) => branchDoc.data()!);

  Stream<List<Branch>> watchBranches() =>
      queryBranches().snapshots().map((snapshot) =>
          snapshot.docs.map((branchDoc) => branchDoc.data()).toList());

  Future<(List<Branch>, DocumentSnapshot?)> lazyFetchOrders(
      int limit, DocumentSnapshot? lastOrder) async {
    return await (lastOrder == null
            ? queryBranches()
                .limit(limit)
            : queryBranches()
                .limit(limit)
                .startAfterDocument(lastOrder))
        .get()
        .then(
          (snapshots) => snapshots.docs.isEmpty
              ? (List<Branch>.empty(), null)
              : (
                  snapshots.docs.map((snapshot) => snapshot.data()).toList(),
                  snapshots.docs.last
                ),
        );
  }
}

@riverpod
BranchRepository branchRepository(BranchRepositoryRef ref) =>
    BranchRepository(FirebaseFirestore.instance);
