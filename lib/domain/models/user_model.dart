class UserModel {
  final String id;
  final String email;
  final String? name;

  UserModel({required this.id, required this.email, this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'email': email, 'name': name};
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(id: id, email: map['email'], name: map['name'] ?? '');
  }
}
