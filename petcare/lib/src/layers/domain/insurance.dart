// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Insurance extends Equatable {
  final String orderId;
  final DateTime start;
  final DateTime end;
  final bool renewed;
  
  const Insurance({
    required this.orderId,
    required this.start,
    required this.end,
    required this.renewed,
  });

  Insurance copyWith({
    String? orderId,
    DateTime? start,
    DateTime? end,
    bool? renewed,
  }) {
    return Insurance(
      orderId: orderId ?? this.orderId,
      start: start ?? this.start,
      end: end ?? this.end,
      renewed: renewed ?? this.renewed,
    );
  }

  @override
  List<Object> get props => [orderId, start, end, renewed];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderId': orderId,
      'start': start.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch,
      'renewed': renewed,
    };
  }

  factory Insurance.fromMap(Map<String, dynamic> map) {
    return Insurance(
      orderId: map['orderId'] as String,
      start: DateTime.fromMillisecondsSinceEpoch(map['start'] as int),
      end: DateTime.fromMillisecondsSinceEpoch(map['end'] as int),
      renewed: map['renewed'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Insurance.fromJson(String source) => Insurance.fromMap(json.decode(source) as Map<String, dynamic>);
}
