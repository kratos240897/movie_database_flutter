abstract class Cache {
  Future<dynamic>? get (String id);
  void set (String id, dynamic object);
  void clear(String id);
  void clearAll();
}
