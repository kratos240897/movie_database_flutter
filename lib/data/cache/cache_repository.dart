import 'package:movie_database/data/cache/app_cache.dart';

class CacheRepo {
  static final homeCache = AppCache();
  static void clearAll() {
    homeCache.clearAll();
  }
}
