import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petcare/src/layers/application/pet_service.dart';
import 'package:petcare/src/layers/data/pet_repository.dart';
import 'package:petcare/src/layers/data/vaccine_repository.dart';
import 'package:petcare/src/layers/domain/vaccine.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vaccines_lazy_load.g.dart';

@riverpod
class VaccinesLazyLoad extends _$VaccinesLazyLoad {
  final int _itemsPerBatch = 6;
  bool hasMore = true;
  DocumentSnapshot? _lastItem;

  @override
  Future<List<Vaccine>> build() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);

    return state.value ?? [];
  }

  Future<List<Vaccine>> _fetch() async {
    final pet = await ref
        .read(petRepositoryProvider)
        .fetchPet(ref.watch(selectedPetIdProvider));
    await Future.delayed(const Duration(seconds: 1));
    final result = await ref
        .read(vaccineRepositoryProvider)
        .lazyFetch(_itemsPerBatch, _lastItem, pet.species);
    hasMore = result.$1.isNotEmpty;

    if (result.$2 != null) {
      _lastItem = result.$2;
    }

    return result.$1;
  }

  Future<void> fetchMore() async {
    if (state.isLoading || !hasMore || _lastItem == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final newItems = await _fetch();
      return [...?state.value, ...newItems];
    });
  }
}
