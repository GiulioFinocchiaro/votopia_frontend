import 'package:votopia/core/models/plan_model.dart';

class Organization {
  final int _id;
  final String _code;
  final String _name;
  final Plan _plan;
  final bool _status;
  final int _max_lists;
  final DateTime? _created_at;

  Organization({
    required int id,
    required String code,
    required String name,
    required Plan plan,
    required bool status,
    required int max_lists,
    DateTime? created_at,
  })  : _id = id,
        _code = code,
        _name = name,
        _plan = plan,
        _status = status,
        _max_lists = max_lists,
        _created_at = created_at;

  Organization.empty()
      : _id = 0,
        _code = '',
        _name = '',
        _plan = Plan.empty(),
        _status = false,
        _max_lists = 0,
        _created_at = null;

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      plan: json['plan'] != null ? Plan.fromJson(json['plan']) : Plan.empty(),
      status: json['status'] == true || json['status'] == 1 || json['status'] == 'active',
      max_lists: json['max_lists'] is int
          ? json['max_lists']
          : int.tryParse(json['max_lists'].toString())
          ?? 0,
      created_at: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
    );
  }

  DateTime? get created_at => _created_at;
  bool get status => _status;
  Plan get plan => _plan;
  String get name => _name;
  String get code => _code;
  int get id => _id;
  int get max_lists => _max_lists;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Organization && runtimeType == other.runtimeType && _id == other._id;

  @override
  int get hashCode => _id.hashCode;
}