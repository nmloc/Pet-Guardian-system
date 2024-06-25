import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:petcare/src/layers/data/auth_repository.dart';
import 'package:petcare/src/layers/domain/order.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'order_repository.g.dart';

class OrderRepository {
  const OrderRepository(this._authRepository, this._firestore);
  final AuthRepository _authRepository;
  final FirebaseFirestore _firestore;

  static String petPath(String petId) => 'pet/$petId';

  Future<DocumentReference> createOrder({
    required String petId,
    required String branchId,
    required String itemCategory,
    required List<String> items,
    required int total,
    bool? paid,
    DateTime? dateRequired,
    DateTime? dateCompleted,
    required String staffId,
  }) async =>
      await _firestore.collection('order').add({
        'id': '',
        'dateRequired': dateRequired ?? Timestamp.fromDate(DateTime.now()),
        'dateCompleted': dateCompleted ??
            Timestamp.fromDate(DateTime.utc(1000, 1, 1, 0, 0, 0, 0, 0)),
        'staffId': staffId,
        'petId': petId,
        'petOwnerId': _authRepository.currentUser!.uid,
        'branchId': branchId,
        'itemCategory': itemCategory,
        'items': items,
        'total': total,
        'paid': paid ?? false,
        'notes': ''
      }).then(
        (docRef) => docRef.update({'id': docRef.id}).then((_) {
          Fluttertoast.showToast(
              msg: "Your order has been created successfully.",
              timeInSecForIosWeb: 4);
          return docRef;
        }),
      );

  CollectionReference<OrderModel> queryOrders() =>
      _firestore.collection('order').withConverter(
            fromFirestore: (snapshot, _) =>
                OrderModel.fromMap(snapshot.data()!),
            toFirestore: (order, _) => order.toMap(),
          );

  Stream<OrderModel> watch(String id) =>
      queryOrders().doc(id).snapshots().map((snapshot) => snapshot.data()!);

  Stream<OrderModel?> fetchValidInsurance(String petId) => queryOrders()
      .where('petId', isEqualTo: petId)
      .where('itemCategory', isEqualTo: 'Insurance')
      .where('dateCompleted', isGreaterThanOrEqualTo: Timestamp.now())
      .snapshots()
      .map((snapshots) => snapshots.docs.firstOrNull == null
          ? null
          : snapshots.docs.first.data());

  Future<bool> isAvailable(String staffId, DateTime dateTime) => queryOrders()
      .where('staffId', isEqualTo: staffId)
      .where('dateRequired', isEqualTo: Timestamp.fromDate(dateTime))
      .where('dateCompleted',
          isEqualTo: Timestamp.fromDate(DateTime.utc(1000, 1, 1)))
      .get()
      .then((snapshot) => snapshot.docs.isEmpty);

  Future<(List<OrderModel>, DocumentSnapshot?)> lazyFetchOrders(
      int orderLimit, DocumentSnapshot? lastOrder) async {
    return await (lastOrder == null
            ? queryOrders()
                .where('petOwnerId',
                    isEqualTo: _authRepository.currentUser!.uid)
                .orderBy('dateRequired', descending: true)
                .limit(orderLimit)
            : queryOrders()
                .where('petOwnerId',
                    isEqualTo: _authRepository.currentUser!.uid)
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

  Future<(List<OrderModel>, DocumentSnapshot?)> lazyFetchOrdersBy(
      int orderLimit,
      DocumentSnapshot? lastOrder,
      String category,
      String petId) async {
    return await (lastOrder == null
            ? queryOrders()
                .where('petId', isEqualTo: petId)
                .where('itemCategory', isEqualTo: category)
                .orderBy('dateRequired', descending: true)
                .limit(orderLimit)
            : queryOrders()
                .where('petId', isEqualTo: petId)
                .where('itemCategory', isEqualTo: category)
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

  Future<void> delete(String orderId) async =>
      await queryOrders().doc(orderId).delete();
}

@riverpod
OrderRepository orderRepository(OrderRepositoryRef ref) {
  return OrderRepository(
      ref.watch(authRepositoryProvider), FirebaseFirestore.instance);
}
