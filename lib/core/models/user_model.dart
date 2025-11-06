import 'organization_model.dart';

class User {
  final int _id;
  final String _email;
  final Organization _organization;
  final DateTime? _created_at;

  User({
    required int id,
    required String email,
    required Organization organization,
    DateTime? created_at
  }) :
      _id = id,
      _email = email,
      _organization = organization,
      _created_at = created_at;
  
  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString())
          ?? 0,
      email: json['email'] ?? '',
      organization: json['organization'] != null
          ? Organization.fromJson(json['organization'])
          : Organization.empty(),
      created_at: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is User && runtimeType == other.runtimeType && _id == other._id;

  @override
  int get hashCode => _id.hashCode;
}