import 'package:hive/hive.dart';

abstract class FavoritesLocalDataSource {
  Future<void> toggleFavorite(String id);
  List<String> getFavoriteIds();
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final Box<String> box;

  FavoritesLocalDataSourceImpl({required this.box});

  @override
  Future<void> toggleFavorite(String id) async {
    if (box.containsKey(id)) {
      await box.delete(id);
    } else {
      await box.put(id, id);
    }
  }

  @override
  List<String> getFavoriteIds() {
    return box.values.toList();
  }
}