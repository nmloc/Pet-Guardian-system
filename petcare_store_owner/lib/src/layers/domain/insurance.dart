// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Insurance extends Equatable {
  final String id;
  final String name;
  final int price;
  final String species;
  final String photoURL;
  final Map<String, dynamic> details;
  const Insurance({
    required this.id,
    required this.name,
    required this.price,
    required this.species,
    required this.photoURL,
    required this.details,
  });

  Insurance copyWith({
    String? id,
    String? name,
    int? price,
    String? species,
    String? photoURL,
    Map<String, dynamic>? details,
  }) {
    return Insurance(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      species: species ?? this.species,
      photoURL: photoURL ?? this.photoURL,
      details: details ?? this.details,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'price': price,
      'species': species,
      'photoURL': photoURL,
      'details': details,
    };
  }

  factory Insurance.fromMap(Map<String, dynamic> map) {
    return Insurance(
      id: map['id'] as String,
      name: map['name'] as String,
      price: map['price'] as int,
      species: map['species'] as String,
      photoURL: map['photoURL'] as String,
      details:
          Map<String, dynamic>.from((map['details'] as Map<String, dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory Insurance.fromJson(String source) =>
      Insurance.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      name,
      price,
      species,
      photoURL,
      details,
    ];
  }
}
