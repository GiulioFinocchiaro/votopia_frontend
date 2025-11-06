import 'package:votopia/core/models/organization_model.dart';
import 'package:votopia/core/utils/utils.dart';

class ListSchool {
  final int _id;
  final String _name;
  final String _description;
  final String? _slogan;
  final Color? _color_primary;
  final Color? _color_secondary;
  final String? _logo_url;
  final Organization _organization;
  final DateTime? _created_at;

  ListSchool({
    required int id,
    required String name,
    required String description,
    String? slogan,
    Color? color_primary,
    Color? color_secondary,
    String? logo_url,
    required Organization organization,
    DateTime? created_at,
  }) :
      _id = id,
      _name = name,
      _description = description,
      _slogan = slogan,
      _color_primary = color_primary,
      _color_secondary = color_secondary,
      _logo_url = logo_url,
      _organization = organization,
      _created_at = created_at;

  factory ListSchool.fromJson(Map<String, dynamic> json){
    return ListSchool(
        id: json['id'] is int
            ? json['id']
            : int.tryParse(json['id'].toString())
            ?? 0,
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        slogan: json['slogan'] ?? null,
        color_primary: Utils().colorFromHex(json['color_primary']) ?? null,
        color_secondary: Utils().colorFromHex(json['color_secondary']) ?? null,
        logo_url: json['logo_url'] ?? null,
        organization: Organization.fromJson(json['organization'] ?? Organization.empty()),
        created_at: json['created_at'] ?? null
    );
  }

  DateTime get created_at => _created_at;

  Organization get organization => _organization;

  String get description => _description;

  String get name => _name;

  int get id => _id;


  String get slogan => _slogan;


  @override
  String toString() {
    return 'ListSchool{_id: $_id, _name: $_name, _description: $_description, _slogan: $_slogan, _color_primary: $_color_primary, _color_secondary: $_color_secondary, _logo_url: $_logo_url, _organization: $_organization, _created_at: $_created_at}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ListSchool && runtimeType == other.runtimeType &&
              _id == other._id;

  @override
  int get hashCode => _id.hashCode;

  Color get color_primary => _color_primary;

  Color get color_secondary => _color_secondary;

  String get logo_url => _logo_url;
}