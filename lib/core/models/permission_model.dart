class Permission {
  final int _id;
  final String _name;
  final String _description;

  Permission({
    required int id,
    required String name,
    required String description
  }) : _id = id,
    _name = name,
    _description = description;

  factory Permission.fromJson(Map<String, dynamic> json){
    return Permission(
        id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString())
          ?? 0,
        name: json['name'] ?? '',
        description: json['description'] ?? '',
    );
  }

  factory Permission.empty(){
    return Permission(
        id: 0,
        name: '',
        description: ''
    );
  }

  @override
  String toString() {
    return 'Permission{_id: $_id, _name: $_name, _description: $_description}';
  }
}