// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Vaccine extends Equatable {
  final String id;
  final String name;
  final String manufacturer;
  final List<dynamic> species;
  final List<dynamic> description;
  final int primaryDoses;
  final int repeatDoseWeek;
  final int validMonth;
  final int price;
  final String photoURL;
  const Vaccine({
    required this.id,
    required this.name,
    required this.manufacturer,
    required this.species,
    required this.description,
    required this.primaryDoses,
    required this.repeatDoseWeek,
    required this.validMonth,
    required this.price,
    required this.photoURL,
  });

  Vaccine copyWith({
    String? id,
    String? name,
    String? manufacturer,
    List<dynamic>? species,
    List<dynamic>? description,
    int? primaryDoses,
    int? repeatDoseWeek,
    int? validMonth,
    int? price,
    String? photoURL,
  }) {
    return Vaccine(
      id: id ?? this.id,
      name: name ?? this.name,
      manufacturer: manufacturer ?? this.manufacturer,
      species: species ?? this.species,
      description: description ?? this.description,
      primaryDoses: primaryDoses ?? this.primaryDoses,
      repeatDoseWeek: repeatDoseWeek ?? this.repeatDoseWeek,
      validMonth: validMonth ?? this.validMonth,
      price: price ?? this.price,
      photoURL: photoURL ?? this.photoURL,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'manufacturer': manufacturer,
      'species': species,
      'description': description,
      'primaryDoses': primaryDoses,
      'repeatDoseWeek': repeatDoseWeek,
      'validMonth': validMonth,
      'price': price,
      'photoURL': photoURL,
    };
  }

  factory Vaccine.fromMap(Map<String, dynamic> map) {
    return Vaccine(
      id: map['id'] as String,
      name: map['name'] as String,
      manufacturer: map['manufacturer'] as String,
      species: List<dynamic>.from((map['species'] as List<dynamic>)),
      description: List<dynamic>.from((map['description'] as List<dynamic>)),
      primaryDoses: map['primaryDoses'] as int,
      repeatDoseWeek: map['repeatDoseWeek'] as int,
      validMonth: map['validMonth'] as int,
      price: map['price'] as int,
      photoURL: map['photoURL'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Vaccine.fromJson(String source) => Vaccine.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      name,
      manufacturer,
      species,
      description,
      primaryDoses,
      repeatDoseWeek,
      validMonth,
      price,
      photoURL,
    ];
  }
}
