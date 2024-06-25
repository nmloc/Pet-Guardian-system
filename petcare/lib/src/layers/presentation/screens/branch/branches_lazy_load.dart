import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petcare/src/layers/data/branch_repository.dart';
import 'package:petcare/src/layers/domain/branch.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'branches_lazy_load.g.dart';

@riverpod
class BranchesLazyLoad extends _$BranchesLazyLoad {
  final int _itemsPerBatch = 6;
  bool hasMore = true;
  DocumentSnapshot? _lastItem;

  @override
  Future<List<Branch>> build() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);

    return state.value ?? [];
  }

  Future<List<Branch>> _fetch() async {
    await Future.delayed(const Duration(seconds: 1));
    final result = await ref
        .read(branchRepositoryProvider)
        .lazyFetchOrders(_itemsPerBatch, _lastItem);
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
