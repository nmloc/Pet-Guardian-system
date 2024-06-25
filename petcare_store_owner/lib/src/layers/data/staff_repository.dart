import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:petcare_store_owner/src/constants/app_colors.dart';
import 'package:petcare_store_owner/src/layers/data/user_repository.dart';
import 'package:petcare_store_owner/src/layers/domain/staff.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'staff_repository.g.dart';

class StaffRepository {
  const StaffRepository(this._userRepository, this._firestore);
  final UserRepository _userRepository;
  final FirebaseFirestore _firestore;

  // create
  Future<void> addStaff(String email) async {
    await _firestore
        .collection('branch')
        .where('staffs', arrayContains: email)
        .get()
        .then((querySnapshot) async {
      if (querySnapshot.docs.isEmpty) {
        await _userRepository.branchId().then(
              (branchId) =>
                  _firestore.collection('branch').doc(branchId).get().then(
                (snapshot) {
                  List<dynamic> staffs = snapshot.data()?['staffs'] ?? [];
                  staffs.add(email);
                  snapshot.reference
                      .set({'staffs': staffs}, SetOptions(merge: true));
                  Fluttertoast.showToast(
                    msg: 'Added $email as staff successfully.',
                    backgroundColor: AppColors.blue500,
                    timeInSecForIosWeb: 4,
                  );
                },
              ),
            );
      } else {
        Fluttertoast.showToast(
          msg: 'Staff $email already exists.',
          backgroundColor: AppColors.blue500,
          timeInSecForIosWeb: 4,
        );
      }
    });
  }

  // read
  Query<Staff> queryStaffs(String branchId) => _firestore
      .collection('staff')
      .where('branchId', isEqualTo: branchId)
      .withConverter(
        fromFirestore: (snapshot, _) => Staff.fromMap(snapshot.data()!),
        toFirestore: (staff, _) => staff.toMap(),
      );

  Future<(List<Staff>, DocumentSnapshot?)> lazyFetch(
      int limit, DocumentSnapshot? lastStaff) async {
    return await _userRepository.branchId().then((branchId) async {
      final List<dynamic> permittedEmails = await _firestore
          .collection('branch')
          .doc(branchId)
          .get()
          .then((branchDoc) => branchDoc.get('staffs') as List<dynamic>);
      return (lastStaff == null
              ? queryStaffs(branchId).limit(limit)
              : queryStaffs(branchId)
                  .limit(limit)
                  .startAfterDocument(lastStaff))
          .get()
          .then((snapshots) {
        final queriedStaffs = snapshots.docs
            .where((doc) => permittedEmails.contains(doc.get('email')))
            .toList();
        return queriedStaffs.isEmpty
            ? (List<Staff>.empty(), null)
            : (
                queriedStaffs.map((snapshot) => snapshot.data()).toList(),
                queriedStaffs.last
              );
      });
    });
  }

  // delete
  Future<void> remove(String branchId, String email) async =>
      await _firestore.collection('branch').doc(branchId).update({
        'staffs': FieldValue.arrayRemove([email])
      });
}

@riverpod
StaffRepository staffRepository(StaffRepositoryRef ref) {
  return StaffRepository(
      ref.watch(userRepositoryProvider), FirebaseFirestore.instance);
}
