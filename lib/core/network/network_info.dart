import 'package:http/http.dart' as http;

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    try {
      final result = await http.get(Uri.parse('https://dummyjson.com'));
      return result.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
