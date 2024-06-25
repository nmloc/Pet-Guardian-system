import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petcare/src/layers/domain/insurance_pack.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'insurance_repository.g.dart';

class InsuranceRepository {
  InsuranceRepository(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<InsurancePack> queryInsurances() =>
      _firestore.collection('insurance').withConverter(
            fromFirestore: (snapshot, _) =>
                InsurancePack.fromMap(snapshot.data()!),
            toFirestore: (pack, _) => pack.toMap(),
          );

  Stream<InsurancePack> watch(String id) =>
      queryInsurances().doc(id).snapshots().map((snapshot) => snapshot.data()!);

  Stream<List<InsurancePack>> watchInsurances(String species) =>
      queryInsurances()
          .where('species', isEqualTo: species)
          .orderBy('price')
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
}

@riverpod
InsuranceRepository insuranceRepository(InsuranceRepositoryRef ref) =>
    InsuranceRepository(FirebaseFirestore.instance);
