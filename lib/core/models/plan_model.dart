import 'module_model.dart';

class Plan {
  final int _id;
  final String _name;
  final double _price;
  final List<Module> _modules;
  final DateTime? _created_at;

  Plan({
    required int id,
    required String name,
    required double price,
    required List<Module> modules,
    DateTime? created_at
  }) :
        _id = id,
        _name = name,
        _price = price,
        _modules = modules,
        _created_at = created_at;

  Plan.empty() :
        _id = 0,
        _name = '',
        _price = 0.0,
        _modules = [],
        _created_at = null;

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      price: json['price'] is double
          ? json['price']
          : double.tryParse(json['price'].toString()) ?? 0,
      modules: (json['modules'] as List<dynamic>?)
          ?.map((m) => Module.fromJson(m))
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
      'name': _name,
      'price': _price,
      'modules': _modules.map((m) => m.toJson()).toList(),
      'created_at': _created_at?.toIso8601String(),
    };
  }

  // Getters
  int get id => _id;
  String get name => _name;
  double get price => _price;
  List<Module> get modules => _modules;
  DateTime? get created_at => _created_at;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Plan && runtimeType == other.runtimeType && _id == other._id;

  @override
  int get hashCode => _id.hashCode;
}