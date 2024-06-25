import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petcare/src/layers/domain/vaccine.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vaccine_repository.g.dart';

class VaccineRepository {
  VaccineRepository(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Vaccine> queryVaccines() =>
      _firestore.collection('vaccine').withConverter(
            fromFirestore: (snapshot, _) => Vaccine.fromMap(snapshot.data()!),
            toFirestore: (vaccine, _) => vaccine.toMap(),
          );

  Stream<Vaccine> watch(String id) =>
      queryVaccines().doc(id).snapshots().map((snapshot) => snapshot.data()!);

  Stream<List<Vaccine>> watchInsurances(String species) => queryVaccines()
      .where('species', isEqualTo: species)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

  Future<(List<Vaccine>, DocumentSnapshot?)> lazyFetch(
      int orderLimit, DocumentSnapshot? lastOrder, String species) async {
    return await (lastOrder == null
            ? queryVaccines()
                .where('species', arrayContains: species)
                .limit(orderLimit)
            : queryVaccines()
                .where('species', arrayContains: species)
                .limit(orderLimit)
                .startAfterDocument(lastOrder))
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
}

@riverpod
VaccineRepository vaccineRepository(VaccineRepositoryRef ref) =>
    VaccineRepository(FirebaseFirestore.instance);
