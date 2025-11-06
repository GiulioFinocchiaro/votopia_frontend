class Module {
  final int _id;
  final String _name;
  final String _description;

  Module({
    required int id,
    required String name,
    required String description
  }) :
      _id = id,
      _name = name,
      _description = description;

  factory Module.fromJson(Map<String, dynamic> json){
    return Module(
        id: json['id'] is int
            ? json['id']
            : int.tryParse(json['id'].toString())
            ?? 0,
        name: json['name'] ?? '',
        description: json['description'] ?? ''
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Module && runtimeType == other.runtimeType &&
              _id == other._id;

  @override
  int get hashCode => _id.hashCode;
}