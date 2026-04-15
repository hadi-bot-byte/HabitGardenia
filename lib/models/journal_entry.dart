import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'journal_entry.g.dart';

@HiveType(typeId: 2)
class JournalEntry extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String body;

  @HiveField(3)
  late DateTime createdAt;

  @HiveField(4)
  late String mood; // "happy", "calm", "tired", "motivated"

  @HiveField(5)
  List<String> tags;

  JournalEntry({
    String? id,
    required this.title,
    required this.body,
    required this.mood,
    this.tags = const [],
  }) {
    this.id = id ?? const Uuid().v4();
    createdAt = DateTime.now();
  }
}
