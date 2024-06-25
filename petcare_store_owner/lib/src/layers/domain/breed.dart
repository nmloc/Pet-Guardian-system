class Breed {
  String name;
  String photoURL;

  Breed({
    required this.name,
    required this.photoURL,
  });

  static Breed fromJson(Map<String, dynamic> json) => Breed(
        name: json['name'],
        photoURL: json['photoURL'],
      );
}
