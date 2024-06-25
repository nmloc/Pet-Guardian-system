import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petcare/src/layers/application/pet_service.dart';
import 'package:petcare/src/layers/data/order_repository.dart';
import 'package:petcare/src/layers/domain/order.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'grooming_tab_lazy_load.g.dart';

@riverpod
class GroomingTabLazyLoad extends _$GroomingTabLazyLoad {
  final int _itemsPerBatch = 6;
  bool hasMore = true;
  DocumentSnapshot? _lastItem;

  @override
  Future<List<OrderModel>> build() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);

    return state.value ?? [];
  }

  Future<List<OrderModel>> _fetch() async {
    await Future.delayed(const Duration(seconds: 1));
    final result = await ref.read(orderRepositoryProvider).lazyFetchOrdersBy(
        _itemsPerBatch, _lastItem, 'Grooming', ref.read(selectedPetIdProvider));
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
