// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class OrderModel extends Equatable {
  final String id;
  final DateTime dateRequired;
  final DateTime dateCompleted;
  final String staffId;
  final String petId;
  final String petOwnerId;
  final String branchId;
  final String itemCategory;
  final List<dynamic> items;
  final int total;
  final bool paid;
  final String notes;

  const OrderModel({
    required this.id,
    required this.dateRequired,
    required this.dateCompleted,
    required this.staffId,
    required this.petId,
    required this.petOwnerId,
    required this.branchId,
    required this.itemCategory,
    required this.items,
    required this.total,
    required this.paid,
    required this.notes,
  });

  OrderModel copyWith({
    String? id,
    DateTime? dateRequired,
    DateTime? dateCompleted,
    String? staffId,
    String? petId,
    String? petOwnerId,
    String? branchId,
    String? itemCategory,
    List<dynamic>? items,
    int? total,
    bool? paid,
    String? notes,
  }) {
    return OrderModel(
      id: id ?? this.id,
      dateRequired: dateRequired ?? this.dateRequired,
      dateCompleted: dateCompleted ?? this.dateCompleted,
      staffId: staffId ?? this.staffId,
      petId: petId ?? this.petId,
      petOwnerId: petOwnerId ?? this.petOwnerId,
      branchId: branchId ?? this.branchId,
      itemCategory: itemCategory ?? this.itemCategory,
      items: items ?? this.items,
      total: total ?? this.total,
      paid: paid ?? this.paid,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'dateRequired': Timestamp.fromDate(dateRequired),
      'dateCompleted': Timestamp.fromDate(dateCompleted),
      'staffId': staffId,
      'petId': petId,
      'petOwnerId': petOwnerId,
      'branchId': branchId,
      'itemCategory': itemCategory,
      'items': items,
      'total': total,
      'paid': paid,
      'notes': notes,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] as String,
      dateRequired: (map['dateRequired'] as Timestamp).toDate(),
      dateCompleted: (map['dateCompleted'] as Timestamp).toDate(),
      staffId: map['staffId'] as String,
      petId: map['petId'] as String,
      petOwnerId: map['petOwnerId'] as String,
      branchId: map['branchId'] as String,
      itemCategory: map['itemCategory'] as String,
      items: map['items'] as List<dynamic>,
      total: map['total'] as int,
      paid: map['paid'] as bool,
      notes: map['notes'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      dateRequired,
      dateCompleted,
      staffId,
      petId,
      petOwnerId,
      branchId,
      itemCategory,
      items,
      total,
      paid,
      notes,
    ];
  }
}
