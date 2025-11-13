import 'package:votopia/core/models/list_school_model.dart';
import 'package:votopia/core/models/permission_model.dart';

import 'organization_model.dart';

class Role {
  final int _id;
  final Organization? _organization;
  final ListSchool _list;
  final String _name;
  final List<Permission> _permissions;
  final DateTime? _created_at;

  Role({
    required int id,
    Organization? organization,
    required ListSchool list,
    required String name,
    required List<Permission> permissions,
    DateTime? created_at,
  }) : _id = id,
        _organization = organization,
        _list = list,
        _name = name,
        _permissions = permissions,
        _created_at = created_at;

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      organization: json['organization'] != null
          ? Organization.fromJson(json['organization'])
          : null,
      list: json['list'] != null
          ? ListSchool.fromJson(json['list'])
          : ListSchool.empty(),
      name: json['name'] ?? '',
      permissions: (json['permissions'] as List<dynamic>?)
          ?.map((p) => Permission.fromJson(p))
          .toList() ??
          [],
      created_at: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'organization': _organization?.toJson(),
      'list': _list.toJson(),
      'name': _name,
      'permissions': _permissions.map((p) => p.toJson()).toList(),
      'created_at': _created_at?.toIso8601String(),
    };
  }

  // Getters
  DateTime? get created_at => _created_at;
  List<Permission> get permissions => _permissions;
  String get name => _name;
  ListSchool get list => _list;
  Organization? get organization => _organization;
  int get id => _id;
}
