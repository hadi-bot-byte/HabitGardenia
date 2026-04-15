import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/habit.dart';

class HabitProvider extends ChangeNotifier {
  late Box<Habit> _habitBox;
  List<Habit> _habits = [];

  List<Habit> get habits => _habits;

  List<Habit> get todaysPending =>
      _habits.where((h) => !h.isCompletedToday()).toList();

  List<Habit> get todaysCompleted =>
      _habits.where((h) => h.isCompletedToday()).toList();

  Future<void> init() async {
    _habitBox = await Hive.openBox<Habit>('habits');
    _habits = _habitBox.values.toList();

    // Seed default habits if empty
    if (_habits.isEmpty) {
      await _seedDefaultHabits();
    }
    notifyListeners();
  }

  Future<void> _seedDefaultHabits() async {
    final defaults = [
      Habit(
        name: 'Morning Exercise',
        category: HabitCategory.exercise,
        targetMinutes: 30,
        plantType: 'sunflower',
      ),
      Habit(
        name: 'Meditation',
        category: HabitCategory.meditation,
        targetMinutes: 10,
        plantType: 'lotus',
      ),
      Habit(
        name: 'Reading',
        category: HabitCategory.reading,
        targetMinutes: 20,
        plantType: 'fern',
      ),
      Habit(
        name: 'Journaling',
        category: HabitCategory.journaling,
        targetMinutes: 15,
        plantType: 'rose',
      ),
    ];
    for (final h in defaults) {
      await _habitBox.put(h.id, h);
    }
    _habits = _habitBox.values.toList();
  }

  Future<void> completeHabit(String habitId) async {
    final habit = _habits.firstWhere((h) => h.id == habitId);
    if (!habit.isCompletedToday()) {
      habit.completedDates.add(DateTime.now());
      await habit.save();
      notifyListeners();
    }
  }

  Future<void> addHabit(Habit habit) async {
    await _habitBox.put(habit.id, habit);
    _habits = _habitBox.values.toList();
    notifyListeners();
  }

  Future<void> deleteHabit(String habitId) async {
    final habit = _habits.firstWhere((h) => h.id == habitId);
    await habit.delete();
    _habits = _habitBox.values.toList();
    notifyListeners();
  }

  int get totalCompletionsToday => todaysCompleted.length;

  double get todayProgress =>
      _habits.isEmpty ? 0 : totalCompletionsToday / _habits.length;
}
