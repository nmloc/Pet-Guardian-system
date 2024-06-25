import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petcare/src/layers/data/auth_repository.dart';
import 'package:petcare/src/layers/domain/app_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_repository.g.dart';

class UserRepository {
  UserRepository(this._authRepository, this._firestore);
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
  
}

@riverpod
UserRepository userRepository(UserRepositoryRef ref) => UserRepository(
    ref.watch(authRepositoryProvider), FirebaseFirestore.instance);
