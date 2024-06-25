import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petcare_store_owner/src/layers/domain/grooming_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'grooming_repository.g.dart';

class GroomingRepository {
  GroomingRepository(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<GroomingService> queryServices() =>
      _firestore.collection('grooming').withConverter(
            fromFirestore: (snapshot, _) =>
                GroomingService.fromMap(snapshot.data()!),
            toFirestore: (service, _) => service.toMap(),
          );

  Stream<GroomingService> watch(String id) =>
      queryServices().doc(id).snapshots().map((snapshot) => snapshot.data()!);

  Stream<List<GroomingService>> watchServices() => queryServices()
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

  Future<(List<GroomingService>, DocumentSnapshot?)> lazyFetch(
      int limit, DocumentSnapshot? lastItem) async {
    return (lastItem == null
            ? queryServices().limit(limit)
            : queryServices().limit(limit).startAfterDocument(lastItem))
        .get()
        .then((snapshots) => snapshots.docs.isEmpty
            ? (List<GroomingService>.empty(), null)
            : (
                snapshots.docs.map((snapshot) => snapshot.data()).toList(),
                snapshots.docs.last
              ));
  }
}

@riverpod
GroomingRepository groomingRepository(GroomingRepositoryRef ref) =>
    GroomingRepository(FirebaseFirestore.instance);
