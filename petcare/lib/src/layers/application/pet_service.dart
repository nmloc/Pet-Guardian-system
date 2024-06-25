import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petcare/src/layers/data/auth_repository.dart';
import 'package:petcare/src/layers/data/pet_repository.dart';
import 'package:petcare/src/layers/domain/pet.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pet_service.g.dart';

@Riverpod(keepAlive: true)
class NewPet extends _$NewPet {
  @override
  Pet build() => Pet()
      .copyWith(ownerId: ref.read(authRepositoryProvider).currentUser!.uid);

  void updateSpecies(String species) =>
      state = state.copyWith(species: species);
  void updateBreed(String breed) => state = state.copyWith(breed: breed);
  void updateImage(String photoURL) =>
      state = state.copyWith(photoURL: photoURL);
  void updateName(String name) => state = state.copyWith(name: name);
  void updateGender(String gender) => state = state.copyWith(gender: gender);
  void updateSize(String size) => state = state.copyWith(size: size);
  void updateWeight(String weight) => state = state.copyWith(weight: weight);
  void updateSigns(String signs) => state = state.copyWith(signs: signs);
  void updateBirthDate(DateTime birthDate) =>
      state = state.copyWith(birthDate: birthDate);
  void updateAdoptionDate(DateTime adoptionDate) =>
      state = state.copyWith(adoptionDate: adoptionDate);
}

final petsProvider = FutureProvider<List<Pet>>(
    (ref) async => await ref.read(petRepositoryProvider).fetchPets());

final selectedPetIdProvider = StateProvider<String>((ref) {
  final _petsProvider = ref.watch(petsProvider);
  if (_petsProvider is AsyncData) {
    ref.watch(petsProvider).asData!.value[0].id;
  }
  return '';
});
