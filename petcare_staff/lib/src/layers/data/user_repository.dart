import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petcare_staff/src/layers/data/auth_repository.dart';
import 'package:petcare_staff/src/layers/domain/app_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_repository.g.dart';

class UserRepository {
  UserRepository(this._authRepository, this._firestore);
  final AuthRepository _authRepository;
  final FirebaseFirestore _firestore;

  CollectionReference<AppUser> queryUsers() =>
      _firestore.collection('staff').withConverter(
            fromFirestore: (snapshot, _) => AppUser.fromMap(snapshot.data()!),
            toFirestore: (user, _) => user.toMap(),
          );

  Future<String> branchId() async => await _firestore
      .collection('staff')
      .doc(_authRepository.currentUser!.email)
      .get()
      .then((snapshot) => snapshot['branchId']);

  Future<String> getName(String userId) async => await _firestore
      .collection('pet owner')
      .doc(userId)
      .get()
      .then((snapshot) => snapshot['displayName']);

  Stream<AppUser> watch({String? uid, String? email}) => queryUsers()
      .where(uid != null ? 'uid' : 'email', isEqualTo: uid ?? email)
      .snapshots()
      .map((snapshot) => snapshot.docs.first.data());
}

@riverpod
UserRepository userRepository(UserRepositoryRef ref) => UserRepository(
    ref.watch(authRepositoryProvider), FirebaseFirestore.instance);
