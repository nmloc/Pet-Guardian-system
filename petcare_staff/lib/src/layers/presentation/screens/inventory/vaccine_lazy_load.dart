import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petcare_staff/src/layers/data/vaccine_repository.dart';
import 'package:petcare_staff/src/layers/domain/vaccine.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vaccine_lazy_load.g.dart';

@riverpod
class VaccineLazyLoad extends _$VaccineLazyLoad {
  final int _itemsPerBatch = 5;
  bool hasMore = true;
  DocumentSnapshot? _lastItem;

  @override
  Future<List<Vaccine>> build() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);

    return state.value ?? [];
  }

  Future<List<Vaccine>> _fetch() async {
    await Future.delayed(const Duration(seconds: 1));
    final result = await ref
        .read(vaccineRepositoryProvider)
        .lazyFetchVaccines(_itemsPerBatch, _lastItem);
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
