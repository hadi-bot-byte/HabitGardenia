import 'package:flutter/material.dart';

class Student {
  final String name;
  final List<double> scores;
  final List<String> subjects;

  Student({
    required this.name,
    required this.scores,
    required this.subjects,
  });

  double get average {
    if (scores.isEmpty) return 0;
    return scores.reduce((a, b) => a + b) / scores.length;
  }

  double get total => scores.isEmpty ? 0 : scores.reduce((a, b) => a + b);

  double get percentage {
    double maxTotal = subjects.length * 100.0;
    if (maxTotal == 0) return 0;
    return (total / maxTotal) * 100;
  }

  String get letterGrade {
    final avg = average;
    if (avg >= 90) return 'A+';
    if (avg >= 80) return 'A';
    if (avg >= 75) return 'B+';
    if (avg >= 70) return 'B';
    if (avg >= 65) return 'C+';
    if (avg >= 60) return 'C';
    if (avg >= 55) return 'D+';
    if (avg >= 50) return 'D';
    return 'F';
  }

  String get remark {
    final avg = average;
    if (avg >= 90) return 'Excellent';
    if (avg >= 80) return 'Very Good';
    if (avg >= 70) return 'Good';
    if (avg >= 60) return 'Average';
    if (avg >= 50) return 'Pass';
    return 'Fail';
  }

  bool get isPassing => average >= 50;

  Color get gradeColor {
    final avg = average;
    if (avg >= 80) return const Color(0xFF2E7D32);
    if (avg >= 60) return const Color(0xFF5D4037);
    if (avg >= 50) return const Color(0xFFE65100);
    return const Color(0xFF6D1A2A);
  }
}
