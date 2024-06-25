import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:petcare_store_owner/src/layers/domain/vaccine.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vaccine_repository.g.dart';

class VaccineRepository {
  VaccineRepository(this._firestore, this._storage);
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  Future<String> uploadPhoto(String id, String photoPath) async {
    final photoRef = _storage.ref().child('images').child('vaccines').child(id);
    await photoRef.putFile(File(photoPath));
    return await photoRef.getDownloadURL();
  }

  CollectionReference<Vaccine> queryVaccine() =>
      _firestore.collection('vaccine').withConverter(
            fromFirestore: (snapshot, _) => Vaccine.fromMap(snapshot.data()!),
            toFirestore: (vaccine, _) => vaccine.toMap(),
          );

  Future<void> createVaccine(Vaccine vaccine) async =>
      await queryVaccine().add(vaccine).then((docRef) {
        docRef.update({'id': docRef.id});
        uploadPhoto(docRef.id, vaccine.photoURL).then((photoDownloadURL) =>
            docRef.update({'photoURL': photoDownloadURL}));
      });

  Future<Vaccine> fetchVaccine(String vaccineId) =>
      queryVaccine().doc(vaccineId).get().then((snapshot) => snapshot.data()!);

  Stream<Vaccine> watch(String vaccineId) => queryVaccine()
      .doc(vaccineId)
      .snapshots()
      .map((snapshot) => snapshot.data()!);

  Stream<List<Vaccine>> watchVaccines() => queryVaccine()
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

  Future<(List<Vaccine>, DocumentSnapshot?)> lazyFetch(
      int limit, DocumentSnapshot? lastItem) async {
    return (lastItem == null
            ? queryVaccine().limit(limit)
            : queryVaccine().limit(limit).startAfterDocument(lastItem))
        .get()
        .then(
          (snapshots) => snapshots.docs.isEmpty
              ? (List<Vaccine>.empty(), null)
              : (
                  snapshots.docs.map((snapshot) => snapshot.data()).toList(),
                  snapshots.docs.last
                ),
        );
  }

  Future<void> deleteVaccine(String id, String photoURL) async => await _storage
      .refFromURL(photoURL)
      .delete()
      .then((_) async => await queryVaccine().doc(id).delete());
}

@riverpod
VaccineRepository vaccineRepository(VaccineRepositoryRef ref) =>
    VaccineRepository(FirebaseFirestore.instance, FirebaseStorage.instance);
