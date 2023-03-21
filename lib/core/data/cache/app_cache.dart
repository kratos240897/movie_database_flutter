import 'dart:collection';
import 'cache.dart';

class AppCache extends Cache {
  AppCache._();
  static AppCache? _instance;
  factory AppCache() {
    if (_instance != null) {
      return _instance!;
    } else {
      _instance = AppCache._();
      return _instance!;
    }
  }
  final _map = HashMap<String, dynamic>();

  @override
  void clear(String id) {
    _map.removeWhere((key, value) => key == id);
  }

  @override
  void clearAll() {
    _map.clear();
    _instance = null;
  }

  @override
  Future<dynamic>? get(String id) {
    if (_map.containsKey(id)) {
      return Future<dynamic>.value(_map[id]);
    }
    return null;
  }

  @override
  void set(String id, object) {
    _map[id] = object;
  }
}
