import 'package:votopia/core/models/list_school_model.dart';
import 'package:votopia/core/models/role_model.dart';

import 'organization_model.dart';

class User {
  final int id;
  final String email;
  final String name;
  final Organization organization;
  final List<Role> roles;
  final List<ListSchool> lists;
  final DateTime? createdAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.organization,
    required this.roles,
    required this.lists,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    print("this");
    return User(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      organization: json['organization'] != null
        ? Organization.fromJson(json['organization'])
        : Organization.empty(),
      roles: (json['roles'] as List<dynamic>?)
              ?.map((r) => Role.fromJson(r))
              .toList() ??
          [],
      lists: (json['lists'] as List<dynamic>?)
              ?.map((m) => ListSchool.fromJson(m))
              .toList() ??
          [],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
