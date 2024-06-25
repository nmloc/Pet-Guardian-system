import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petcare_staff/src/layers/data/auth_repository.dart';
import 'package:petcare_staff/src/layers/domain/order.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'order_repository.g.dart';

class OrderRepository {
  const OrderRepository(this.userId, this._firestore);
  final String userId;
  final FirebaseFirestore _firestore;

  CollectionReference<OrderModel> queryOrders() =>
      _firestore.collection('order').withConverter(
            fromFirestore: (snapshot, _) =>
                OrderModel.fromMap(snapshot.data()!),
            toFirestore: (order, _) => order.toMap(),
          );

  // read
  Stream<List<OrderModel>> watchOrders() async* {
    yield* await queryOrders()
        .where('staffId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Stream<List<OrderModel>> watchAvailableOrders() async* {
    yield* await queryOrders()
        .where('staffId', isEqualTo: userId)
        .where('dateCompleted',
            isLessThan: Timestamp.fromDate(DateTime.utc(1000, 1, 30)))
        .orderBy('dateCompleted')
        .orderBy('dateRequired', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Stream<OrderModel> watch(String id) =>
      queryOrders().doc(id).snapshots().map((snapshot) => snapshot.data()!);

  Future<(List<OrderModel>, DocumentSnapshot?)> lazyFetchOrders(
      int orderLimit, DocumentSnapshot? lastOrder) async {
    return (lastOrder == null
            ? queryOrders()
                .where('staffId', isEqualTo: userId)
                .orderBy('dateRequired', descending: true)
                .limit(orderLimit)
            : queryOrders()
                .where('staffId', isEqualTo: userId)
                .orderBy('dateRequired', descending: true)
                .limit(orderLimit)
                .startAfterDocument(lastOrder))
        .get()
        .then(
          (snapshots) => snapshots.docs.isEmpty
              ? (List<OrderModel>.empty(), null)
              : (
                  snapshots.docs.map((snapshot) => snapshot.data()).toList(),
                  snapshots.docs.last
                ),
        );
  }

  // update
  Future<void> update(String id, String notes, DateTime? dateCompleted) =>
      _firestore.collection('order').doc(id).set({
        'notes': notes,
        'paid': true,
        'dateCompleted': dateCompleted ?? DateTime.now()
      }, SetOptions(merge: true));
}

@riverpod
OrderRepository orderRepository(OrderRepositoryRef ref) {
  return OrderRepository(ref.watch(authRepositoryProvider).currentUser!.uid,
      FirebaseFirestore.instance);
}
