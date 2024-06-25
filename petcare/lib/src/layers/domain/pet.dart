import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:const_date_time/const_date_time.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Pet extends Equatable {
  String id;
  String species;
  String breed;
  String name;
  String photoURL;
  String gender;
  String size;
  String weight;
  String signs;
  DateTime birthDate;
  DateTime adoptionDate;
  String ownerId;

  Pet({
    this.id = "",
    this.species = "",
    this.breed = "",
    this.name = "",
    this.photoURL = "",
    this.gender = "",
    this.size = "",
    this.weight = "",
    this.signs = "",
    this.birthDate = const ConstDateTime.utc(1000, 1, 1),
    this.adoptionDate = const ConstDateTime.utc(1000, 1, 1),
    this.ownerId = "",
  });

  Pet copyWith({
    String? id,
    String? species,
    String? breed,
    String? name,
    String? photoURL,
    String? gender,
    String? size,
    String? weight,
    String? signs,
    DateTime? birthDate,
    DateTime? adoptionDate,
    String? ownerId,
  }) {
    return Pet(
      id: id ?? this.id,
      species: species ?? this.species,
      breed: breed ?? this.breed,
      name: name ?? this.name,
      photoURL: photoURL ?? this.photoURL,
      gender: gender ?? this.gender,
      size: size ?? this.size,
      weight: weight ?? this.weight,
      signs: signs ?? this.signs,
      birthDate: birthDate ?? this.birthDate,
      adoptionDate: adoptionDate ?? this.adoptionDate,
      ownerId: ownerId ?? this.ownerId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'species': species,
      'breed': breed,
      'name': name,
      'photoURL': photoURL,
      'gender': gender,
      'size': size,
      'weight': weight,
      'signs': signs,
      'birthDate': Timestamp.fromDate(birthDate),
      'adoptionDate': Timestamp.fromDate(adoptionDate),
      'ownerId': ownerId,
    };
  }

  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      id: map['id'] as String,
      species: map['species'] as String,
      breed: map['breed'] as String,
      name: map['name'] as String,
      photoURL: map['photoURL'] as String,
      gender: map['gender'] as String,
      size: map['size'] as String,
      weight: map['weight'] as String,
      signs: map['signs'] as String,
      birthDate: (map['birthDate'] as Timestamp).toDate(),
      adoptionDate: (map['adoptionDate'] as Timestamp).toDate(),
      ownerId: map['ownerId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Pet.fromJson(String source) =>
      Pet.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      species,
      breed,
      name,
      photoURL,
      gender,
      size,
      weight,
      signs,
      birthDate,
      adoptionDate,
      ownerId,
    ];
  }
}
