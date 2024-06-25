import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petcare_staff/src/layers/data/insurance_repository.dart';
import 'package:petcare_staff/src/layers/domain/insurance_pack.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'insurance_lazy_load.g.dart';

@riverpod
class InsuranceLazyLoad extends _$InsuranceLazyLoad {
  final int _itemsPerBatch = 7;
  bool hasMore = true;
  DocumentSnapshot? _lastItem;

  @override
  Future<List<InsurancePack>> build() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);

    return state.value ?? [];
  }

  Future<List<InsurancePack>> _fetch() async {
    await Future.delayed(const Duration(seconds: 1));
    final result = await ref
        .read(insuranceRepositoryProvider)
        .lazyFetchInsurances(_itemsPerBatch, _lastItem);
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
