// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<String> photos;
  final List<Variant> variants;
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.photos,
    required this.variants,
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? photos,
    List<Variant>? variants,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      photos: photos ?? this.photos,
      variants: variants ?? this.variants,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'photos': photos,
      'variants': variants.map((x) => x.toMap()).toList(),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      photos: List<String>.from((map['photos'] as List<String>)),
      variants: (map['variants'] as List<Map<String, dynamic>>)
          .map((variant) => Variant.fromMap(variant))
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      name,
      description,
      photos,
      variants,
    ];
  }
}

class Variant extends Equatable {
  final String id;
  final String price;
  final String size;
  final int availableQuantity;
  const Variant({
    required this.id,
    required this.price,
    required this.size,
    required this.availableQuantity,
  });

  Variant copyWith({
    String? id,
    String? price,
    String? size,
    int? availableQuantity,
  }) {
    return Variant(
      id: id ?? this.id,
      price: price ?? this.price,
      size: size ?? this.size,
      availableQuantity: availableQuantity ?? this.availableQuantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'price': price,
      'size': size,
      'availableQuantity': availableQuantity,
    };
  }

  factory Variant.fromMap(Map<String, dynamic> map) {
    return Variant(
      id: map['id'] as String,
      price: map['price'] as String,
      size: map['size'] as String,
      availableQuantity: map['availableQuantity'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Variant.fromJson(String source) => Variant.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, price, size, availableQuantity];
}
