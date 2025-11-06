import 'package:shared_preferences/shared_preferences.dart';

class OrganizationProvider extends ChangeNotifier {
  final _apiService = new ApiService();
  String _token;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();

    this._token = prefs.getString('token');
  }
}