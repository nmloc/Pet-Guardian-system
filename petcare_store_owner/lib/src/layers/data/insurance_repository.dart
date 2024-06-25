import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:petcare_store_owner/src/layers/domain/insurance.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'insurance_repository.g.dart';

class InsuranceRepository {
  InsuranceRepository(this._firestore, this._storage);
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  Future<String> uploadPhoto(String id, String photoPath) async {
    final photoRef =
        _storage.ref().child('images').child('insurances').child(id);
    await photoRef.putFile(File(photoPath));
    return await photoRef.getDownloadURL();
  }

  CollectionReference<Insurance> insuranceRef() =>
      _firestore.collection('insurance').withConverter(
            fromFirestore: (snapshot, _) => Insurance.fromMap(snapshot.data()!),
            toFirestore: (pack, _) => pack.toMap(),
          );

  Query<Insurance> queryPacks() => _firestore
      .collection('insurance')
      .orderBy('species')
      .orderBy('price')
      .withConverter(
        fromFirestore: (snapshot, _) => Insurance.fromMap(snapshot.data()!),
        toFirestore: (pack, _) => pack.toMap(),
      );

  Future<void> createPack(Insurance pack) async =>
      await insuranceRef().add(pack).then((docRef) {
        docRef.update({'id': docRef.id});
        // uploadPhoto(docRef.id, pack.photoURL).then((photoDownloadURL) =>
        //     docRef.update({'photoURL': photoDownloadURL}));
      });

  Stream<Insurance> watch(String packId) => insuranceRef()
      .doc(packId)
      .snapshots()
      .map((snapshot) => snapshot.data()!);

  Stream<List<Insurance>> watchPacks() => queryPacks()
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

  Future<Insurance> fetchPack(String packId) =>
      insuranceRef().doc(packId).get().then((snapshot) => snapshot.data()!);

  Future<(List<Insurance>, DocumentSnapshot?)> lazyFetch(
      int limit, DocumentSnapshot? lastItem) async {
    return (lastItem == null
            ? queryPacks().limit(limit)
            : queryPacks().limit(limit).startAfterDocument(lastItem))
        .get()
        .then((snapshots) => snapshots.docs.isEmpty
            ? (List<Insurance>.empty(), null)
            : (
                snapshots.docs.map((snapshot) => snapshot.data()).toList(),
                snapshots.docs.last
              ));
  }

  Future<void> deletePack(String id, String photoURL) async => await _storage
      .refFromURL(photoURL)
      .delete()
      .then((_) async => await insuranceRef().doc(id).delete());
}

@riverpod
InsuranceRepository insuranceRepository(InsuranceRepositoryRef ref) =>
    InsuranceRepository(FirebaseFirestore.instance, FirebaseStorage.instance);
