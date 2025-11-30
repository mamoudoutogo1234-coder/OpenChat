import 'package:hive/hive.dart';
import 'package:openchat/models/FrequentUser.dart';

class HiveFrequentStorage {
  late Box<FrequentUser> box;

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(FrequentUserAdapter());
    }
    box = await Hive.openBox<FrequentUser>('frequents_box');
  }

  Future<void> saveMany(List<FrequentUser> items) async {
    for (var item in items) {
      await box.put(item.id, item);
    }
  }
  List<FrequentUser> getAll() {
    final list = box.values.toList();
    list.sort((a, b) => (b.updatedAt).compareTo(a.updatedAt));
    return list;
  }

}
