import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class GardenProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _habits = [];
  List<Map<String, dynamic>> _journalEntries = [];
  int _currentStreak = 0;
  int _gardenLevel = 1;
  double _levelProgress = 0.0;
  int _plantCount = 0;
  List<String> _achievements = [];

  // Getters
  List<Map<String, dynamic>> get habits => _habits;
  List<Map<String, dynamic>> get journalEntries => _journalEntries;
  int get currentStreak => _currentStreak;
  int get gardenLevel => _gardenLevel;
  double get levelProgress => _levelProgress;
  int get plantCount => _plantCount;
  List<String> get achievements => _achievements;

  int get completedHabitsCount {
    return _habits.where((habit) => habit['completed'] == true).length;
  }

  double get dailyProgress {
    if (_habits.isEmpty) return 0.0;
    return completedHabitsCount / _habits.length;
  }

  String get nextLevelProgress {
    return '${(_levelProgress * 100).toInt()}%';
  }

  List<Color> get skyGradient {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) {
      return [const Color(0xFF87CEEB), const Color(0xFFFFE066)];
    } else if (hour >= 12 && hour < 18) {
      return [const Color(0xFFB0BEC5), const Color(0xFF90A4AE)];
    } else {
      return [const Color(0xFF546E7A), const Color(0xFF37474F)];
    }
  }

  GardenProvider() {
    _loadMockData();
  }

  void _loadMockData() {
    // Add some mock habits for testing
    _habits = [
      {
        'name': 'Morning Meditation',
        'category': 'Mindfulness',
        'frequency': 'Daily',
        'completed': false,
      },
      {
        'name': 'Drink Water',
        'category': 'Health',
        'frequency': 'Daily',
        'completed': true,
      },
      {
        'name': 'Read 30 mins',
        'category': 'Learning',
        'frequency': 'Daily',
        'completed': false,
      },
    ];

    // Add some mock journal entries
    _journalEntries = [
      {
        'title': 'Great progress!',
        'content': 'Today I completed all my habits and feel very productive.',
        'mood': 'Happy',
        'date': DateTime.now().toString().split(' ')[0],
      },
      {
        'title': 'Building consistency',
        'content': 'Working on maintaining my streak. Small steps every day.',
        'mood': 'Good',
        'date': DateTime.now()
            .subtract(const Duration(days: 1))
            .toString()
            .split(' ')[0],
      },
    ];

    _currentStreak = 3;
    _gardenLevel = 2;
    _levelProgress = 0.6;
    _plantCount = 2;
    _achievements = ['First Steps', 'Consistent Beginner'];

    notifyListeners();
  }

  void toggleHabit(int index) {
    if (index >= 0 && index < _habits.length) {
      _habits[index]['completed'] = !(_habits[index]['completed'] ?? false);

      if (_habits[index]['completed'] == true) {
        _updateProgress();
      }

      notifyListeners();
    }
  }

  void addHabit(String name, String category, String frequency) {
    _habits.add({
      'name': name,
      'category': category,
      'frequency': frequency,
      'completed': false,
    });
    notifyListeners();
  }

  void removeHabit(int index) {
    if (index >= 0 && index < _habits.length) {
      _habits.removeAt(index);
      notifyListeners();
    }
  }

  void addJournalEntry(String title, String content, String mood) {
    _journalEntries.insert(0, {
      'title': title,
      'content': content,
      'mood': mood,
      'date': DateTime.now().toString().split(' ')[0],
    });

    if (_journalEntries.length == 1) {
      _addAchievement('First Journal Entry!');
    }

    notifyListeners();
  }

  void removeJournalEntry(int index) {
    if (index >= 0 && index < _journalEntries.length) {
      _journalEntries.removeAt(index);
      notifyListeners();
    }
  }

  void _updateProgress() {
    _currentStreak++;

    _levelProgress += 0.1;
    if (_levelProgress >= 1.0) {
      _levelProgress = 0.0;
      _gardenLevel++;
      _plantCount++;
    }

    notifyListeners();
  }

  void _addAchievement(String achievement) {
    if (!_achievements.contains(achievement)) {
      _achievements.add(achievement);
    }
  }
}
