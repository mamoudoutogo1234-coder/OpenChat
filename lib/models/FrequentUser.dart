import 'package:hive/hive.dart';

part 'FrequentUser.g.dart';

@HiveType(typeId: 2)
class FrequentUser extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String lastMessage;

  @HiveField(2)
  DateTime updatedAt;

  @HiveField(3)
  Map<String, dynamic> sender;

  @HiveField(4)
  Map<String, dynamic> receiver;

  FrequentUser({
    required this.id,
    required this.lastMessage,
    required this.updatedAt,
    required this.sender,
    required this.receiver,
  });
}
