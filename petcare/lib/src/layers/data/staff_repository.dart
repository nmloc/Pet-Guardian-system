import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petcare/src/layers/data/auth_repository.dart';
import 'package:petcare/src/layers/domain/app_user.dart';
import 'package:petcare/src/layers/domain/staff.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'staff_repository.g.dart';

class StaffRepository {
  StaffRepository(this._authRepository, this._firestore);
  final AuthRepository _authRepository;
  final FirebaseFirestore _firestore;

  Future<void> checkIfUserIsNewToFirestore() async {
    bool isNewUser = await _authRepository.isNewUser();
    if (isNewUser) {
      await _firestore
          .collection('pet owner')
          .doc(_authRepository.currentUser!.uid)
          .set(AppUser.fromFirebase(_authRepository.currentUser!).toMap());
    }
  }

  CollectionReference<Staff> queryStaffs() =>
      _firestore.collection('staff').withConverter(
            fromFirestore: (snapshot, _) => Staff.fromMap(snapshot.data()!),
            toFirestore: (staff, _) => staff.toMap(),
          );

  Stream<Staff> watch(String staffId) => queryStaffs()
      .doc(staffId)
      .snapshots()
      .map((snapshot) => snapshot.data()!);

  Stream<List<Staff>> watchStaffs(String branchId) => queryStaffs()
      .where('branchId', isEqualTo: branchId)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((staffDoc) => staffDoc.data()).toList());

  Future<void> deleteTask(String orderId) =>
      queryStaffs().where("onTask", isEqualTo: orderId).get().then(
        (querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            querySnapshot.docs.first.reference.update({"onTask": ""});
          }
        },
      );
}

@riverpod
StaffRepository staffRepository(StaffRepositoryRef ref) => StaffRepository(
    ref.watch(authRepositoryProvider), FirebaseFirestore.instance);
