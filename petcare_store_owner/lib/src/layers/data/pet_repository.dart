import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:petcare_store_owner/src/layers/data/auth_repository.dart';
import 'package:petcare_store_owner/src/layers/domain/pet.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pet_repository.g.dart';

class PetRepository {
  const PetRepository(this._authRepository, this._firestore, this._storage);
  final AuthRepository _authRepository;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  String petPath(String petId) => 'pet/$petId';
  String currentUserPath() => 'pet owner/${_authRepository.currentUser!.uid}';

  Future<String> uploadPhoto(String petId, String photoPath) async {
    final photoRef = FirebaseStorage.instance
        .ref()
        .child('images')
        .child('pets')
        .child(petId);
    await photoRef.putFile(File(photoPath));
    return await photoRef.getDownloadURL();
  }

  // create
  Future<void> addPet(Pet pet) async {
    DocumentReference newPetRef = await _firestore.collection('pet').add({});
    pet.id = newPetRef.id;
    pet.photoURL = await uploadPhoto(newPetRef.id, pet.photoURL);
    // Update new pet info to firebase storage
    await newPetRef.update(pet.toMap()).then((_) => _firestore
        .doc(currentUserPath())
        .get()
        .then((doc) async => await doc.reference.update({
              'petIds': FieldValue.arrayUnion([newPetRef.id])
            })));
  }

  // read
  DocumentReference<Pet> queryPet(String petId) =>
      _firestore.doc(petPath(petId)).withConverter(
            fromFirestore: (snapshot, _) => Pet.fromMap(snapshot.data()!),
            toFirestore: (pet, _) => pet.toMap(),
          );

  Future<Pet> fetchPet(String petId) async =>
      queryPet(petId).get().then((snapshot) => snapshot.data()!);

  Stream<Pet> watchPet(String petId) =>
      queryPet(petId).snapshots().map((snapshot) => snapshot.data()!);

  Query<Pet> queryPets() => _firestore
      .collection('pet')
      .where('ownerId', isEqualTo: _authRepository.currentUser!.uid)
      .withConverter(
        fromFirestore: (snapshot, _) => Pet.fromMap(snapshot.data()!),
        toFirestore: (pet, _) => pet.toMap(),
      );

  Stream<List<Pet>> watchPets() => queryPets()
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

  // update
  Future<void> updatePet(Pet pet, String? newPhotoPath) async {
    if (newPhotoPath != null) {
      await _storage
          .refFromURL(pet.photoURL)
          .delete()
          .then((_) async =>
              pet.photoURL = await uploadPhoto(pet.id, newPhotoPath))
          .then((_) => _firestore.doc(petPath(pet.id)).update(pet.toMap()));
    }
    await _firestore.doc(petPath(pet.id)).update(pet.toMap());
  }

  // delete
  Future<void> deletePet(String petId, String petPhotoURL) async {
    // remove petId from current user's owned petIds list
    _firestore.doc(currentUserPath()).get().then((doc) async {
      await doc.reference.update({
        'petIds': FieldValue.arrayRemove([petId]),
      });
    });
    await _storage.refFromURL(petPhotoURL).delete();
    await _firestore.doc(petPath(petId)).delete();
  }
}

@riverpod
PetRepository petRepository(PetRepositoryRef ref) {
  return PetRepository(ref.watch(authRepositoryProvider),
      FirebaseFirestore.instance, FirebaseStorage.instance);
}
