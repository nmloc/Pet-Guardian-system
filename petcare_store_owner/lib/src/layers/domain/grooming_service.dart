// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class GroomingService extends Equatable {
  final String id;
  final String name;
  final int price;
  final String photoURL;
  
  const GroomingService({
    required this.id,
    required this.name,
    required this.price,
    required this.photoURL,
  });

  GroomingService copyWith({
    String? id,
    String? name,
    int? price,
    String? photoURL,
  }) {
    return GroomingService(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      photoURL: photoURL ?? this.photoURL,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'price': price,
      'photoURL': photoURL,
    };
  }

  factory GroomingService.fromMap(Map<String, dynamic> map) {
    return GroomingService(
      id: map['id'] as String,
      name: map['name'] as String,
      price: map['price'] as int,
      photoURL: map['photoURL'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory GroomingService.fromJson(String source) => GroomingService.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, name, price, photoURL];
}
