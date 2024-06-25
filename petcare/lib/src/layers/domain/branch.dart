// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Branch extends Equatable {
  final String id;
  final String name;
  final String storeOwnerId;
  final String phoneNumber;
  final String email;
  final GeoPoint lat_long;
  final String street;
  final String ward;
  final String district;
  final String city;

  String address() =>
      "$street Street, Ward $ward, District $district, $city City.";

  const Branch({
    required this.id,
    required this.name,
    required this.storeOwnerId,
    required this.phoneNumber,
    required this.email,
    required this.lat_long,
    required this.street,
    required this.ward,
    required this.district,
    required this.city,
  });

  Branch copyWith({
    String? id,
    String? name,
    String? storeOwnerId,
    String? phoneNumber,
    String? email,
    GeoPoint? lat_long,
    String? street,
    String? ward,
    String? district,
    String? city,
  }) {
    return Branch(
      id: id ?? this.id,
      name: name ?? this.name,
      storeOwnerId: storeOwnerId ?? this.storeOwnerId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      lat_long: lat_long ?? this.lat_long,
      street: street ?? this.street,
      ward: ward ?? this.ward,
      district: district ?? this.district,
      city: city ?? this.city,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'storeOwnerId': storeOwnerId,
      'phoneNumber': phoneNumber,
      'email': email,
      'lat_long': lat_long,
      'street': street,
      'ward': ward,
      'district': district,
      'city': city,
    };
  }

  factory Branch.fromMap(Map<String, dynamic> map) {
    return Branch(
      id: map['id'] as String,
      name: map['name'] as String,
      storeOwnerId: map['storeOwnerId'] as String,
      phoneNumber: map['phoneNumber'] as String,
      email: map['email'] as String,
      lat_long: map['lat_long'] as GeoPoint,
      street: map['street'] as String,
      ward: map['ward'] as String,
      district: map['district'] as String,
      city: map['city'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Branch.fromJson(String source) =>
      Branch.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      name,
      storeOwnerId,
      phoneNumber,
      email,
      lat_long,
      street,
      ward,
      district,
      city,
    ];
  }
}
