import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petcare_store_owner/src/layers/data/user_repository.dart';
import 'package:petcare_store_owner/src/layers/domain/order.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'order_repository.g.dart';

class OrderRepository {
  const OrderRepository(this._userRepository, this._firestore);
  final UserRepository _userRepository;
  final FirebaseFirestore _firestore;

  // read
  Stream<List<OrderModel>> watchOrders() async* {
    yield* queryOrders(await _userRepository.branchId())
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Query<OrderModel> queryOrders(String branchId) => _firestore
      .collection('order')
      .where('branchId', isEqualTo: branchId)
      .withConverter(
        fromFirestore: (snapshot, _) => OrderModel.fromMap(snapshot.data()!),
        toFirestore: (order, _) => order.toMap(),
      );

  Future<(List<OrderModel>, DocumentSnapshot?)> lazyFetch(
      int orderLimit, DocumentSnapshot? lastOrder) async {
    return await _userRepository.branchId().then(
          (branchId) => (lastOrder == null
                  ? queryOrders(branchId).limit(orderLimit)
                  : queryOrders(branchId)
                      .limit(orderLimit)
                      .startAfterDocument(lastOrder))
              .get()
              .then(
                (snapshots) => snapshots.docs.isEmpty
                    ? (List<OrderModel>.empty(), null)
                    : (
                        snapshots.docs
                            .map((snapshot) => snapshot.data())
                            .toList(),
                        snapshots.docs.last
                      ),
              ),
        );
  }
}

@riverpod
OrderRepository orderRepository(OrderRepositoryRef ref) {
  return OrderRepository(
      ref.watch(userRepositoryProvider), FirebaseFirestore.instance);
}
