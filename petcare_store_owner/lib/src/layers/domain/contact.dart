class Contact {
  String role;
  String photoURL;
  String firstName;
  String lastName;
  String phone;
  String email;
  String rating;

  Contact({
    required this.role,
    required this.photoURL,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.rating,
  });

  static Contact fromJson(Map<String, dynamic> json) => Contact(
        role: json['role'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        photoURL: json['photoURL'],
        phone: json['phone'],
        email: json['email'],
        rating: json['rating'],
      );
}
