import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/journal_entry.dart';

class JournalProvider extends ChangeNotifier {
  late Box<JournalEntry> _journalBox;
  List<JournalEntry> _entries = [];

  List<JournalEntry> get entries =>
      _entries..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  Future<void> init() async {
    _journalBox = await Hive.openBox<JournalEntry>('journal');
    _entries = _journalBox.values.toList();
    notifyListeners();
  }

  Future<void> addEntry(JournalEntry entry) async {
    await _journalBox.put(entry.id, entry);
    _entries = _journalBox.values.toList();
    notifyListeners();
  }

  Future<void> updateEntry(JournalEntry entry) async {
    await entry.save();
    _entries = _journalBox.values.toList();
    notifyListeners();
  }

  Future<void> deleteEntry(String entryId) async {
    final entry = _entries.firstWhere((e) => e.id == entryId);
    await entry.delete();
    _entries = _journalBox.values.toList();
    notifyListeners();
  }

  List<JournalEntry> getEntriesForMonth(DateTime month) {
    return _entries
        .where(
          (e) =>
              e.createdAt.year == month.year &&
              e.createdAt.month == month.month,
        )
        .toList();
  }
}
