import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'habit.g.dart';

@HiveType(typeId: 0)
enum HabitCategory {
  @HiveField(0)
  exercise,
  @HiveField(1)
  meditation,
  @HiveField(2)
  reading,
  @HiveField(3)
  journaling,
  @HiveField(4)
  custom,
}

@HiveType(typeId: 1)
class Habit extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late HabitCategory category;

  @HiveField(3)
  late List<DateTime> completedDates;

  @HiveField(4)
  late int targetMinutes; // daily goal in minutes

  @HiveField(5)
  late String plantType; // which plant this habit grows

  Habit({
    String? id,
    required this.name,
    required this.category,
    required this.targetMinutes,
    required this.plantType,
  }) {
    this.id = id ?? const Uuid().v4();
    completedDates = [];
  }

  bool isCompletedToday() {
    final today = DateTime.now();
    return completedDates.any(
      (d) =>
          d.year == today.year && d.month == today.month && d.day == today.day,
    );
  }

  int get currentStreak {
    if (completedDates.isEmpty) return 0;
    final sorted = completedDates..sort((a, b) => b.compareTo(a));
    int streak = 0;
    DateTime check = DateTime.now();
    for (final date in sorted) {
      final diff = check.difference(date).inDays;
      if (diff <= 1) {
        streak++;
        check = date;
      } else
        break;
    }
    return streak;
  }

  // Health 0.0 to 1.0 — drives the garden visuals
  double get plantHealth {
    if (completedDates.isEmpty) return 0.1;
    final streak = currentStreak;
    if (streak >= 21) return 1.0;
    return (streak / 21).clamp(0.1, 1.0);
  }
}
