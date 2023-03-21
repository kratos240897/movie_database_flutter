import 'app_cache.dart';

class CacheService {
  final homeCache = AppCache();
  void clearAll() {
    homeCache.clearAll();
  }
}
