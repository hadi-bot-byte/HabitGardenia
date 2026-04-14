import 'package:flutter/material.dart';
import '../models/student.dart';

const kBurgundy = Color(0xFF6D1A2A);
const kDarkBurgundy = Color(0xFF4A0E1A);
const kBrown = Color(0xFF3E1A0E);
const kLightBrown = Color(0xFF8B5E3C);
const kCream = Color(0xFFFDF6F0);
const kRose = Color(0xFFD4A89A);

class ResultsScreen extends StatelessWidget {
  final List<Student> students;
  const ResultsScreen({super.key, required this.students});

  List<Student> get _sorted {
    final s = List<Student>.from(students);
    s.sort((a, b) => b.average.compareTo(a.average));
    return s;
  }

  double get _highest =>
      students.map((s) => s.average).reduce((a, b) => a > b ? a : b);
  double get _lowest =>
      students.map((s) => s.average).reduce((a, b) => a < b ? a : b);
  double get _classAvg =>
      students.map((s) => s.average).reduce((a, b) => a + b) / students.length;
  double get _passRate =>
      (students.where((s) => s.isPassing).length / students.length) * 100;

  @override
  Widget build(BuildContext context) {
    final sorted = _sorted;
    return Scaffold(
      backgroundColor: kCream,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [kDarkBurgundy, kBurgundy],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text('📊 Class Results',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.4)),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Grading Key',
            onPressed: () => _showGradingKey(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionLabel('Class Statistics'),
          const SizedBox(height: 10),
          _buildStatsGrid(),
          const SizedBox(height: 22),
          _sectionLabel('Class Rankings'),
          const SizedBox(height: 10),
          ...sorted
              .asMap()
              .entries
              .map((e) => _buildStudentCard(e.key + 1, e.value)),
          const SizedBox(height: 22),
          _sectionLabel('Grade Distribution'),
          const SizedBox(height: 10),
          _buildDistribution(sorted),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _sectionLabel(String t) => Row(children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: kBurgundy,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(t,
            style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: kBrown,
                letterSpacing: 0.3)),
      ]);

  Widget _buildStatsGrid() {
    return Column(children: [
      Row(children: [
        Expanded(
          child: _statCard(
            icon: Icons.emoji_events,
            label: 'Highest Grade',
            value: '${_highest.toStringAsFixed(1)}%',
            subtitle: _sorted.first.name,
            color: const Color(0xFF2E7D32),
            bg: const Color(0xFFEDF7ED),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(
            icon: Icons.trending_down,
            label: 'Lowest Grade',
            value: '${_lowest.toStringAsFixed(1)}%',
            subtitle: _sorted.last.name,
            color: kBurgundy,
            bg: const Color(0xFFFAECEE),
          ),
        ),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(
          child: _statCard(
            icon: Icons.school,
            label: 'Class Average',
            value: '${_classAvg.toStringAsFixed(1)}%',
            subtitle: _gradeLabel(_classAvg),
            color: kBrown,
            bg: const Color(0xFFF5EDE5),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(
            icon: Icons.check_circle_outline,
            label: 'Pass Rate',
            value: '${_passRate.toStringAsFixed(1)}%',
            subtitle:
                '${students.where((s) => s.isPassing).length}/${students.length} passed',
            color: kLightBrown,
            bg: const Color(0xFFFDF3EC),
          ),
        ),
      ]),
    ]);
  }

  Widget _statCard({
    required IconData icon,
    required String label,
    required String value,
    required String subtitle,
    required Color color,
    required Color bg,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Expanded(
              child: Text(label,
                  style: TextStyle(
                      fontSize: 11,
                      color: color,
                      fontWeight: FontWeight.w600))),
        ]),
        const SizedBox(height: 8),
        Text(value,
            style: TextStyle(
                fontSize: 26, fontWeight: FontWeight.bold, color: color)),
        Text(subtitle,
            style: TextStyle(fontSize: 11, color: color.withOpacity(0.75)),
            overflow: TextOverflow.ellipsis),
      ]),
    );
  }

  Widget _buildStudentCard(int rank, Student student) {
    final medals = {1: '🥇', 2: '🥈', 3: '🥉'};
    final isTop = rank <= 3;

    Color rankColor;
    Color cardBg;
    Color borderColor;

    if (rank == 1) {
      rankColor = const Color(0xFFB8860B);
      cardBg = const Color(0xFFFFFBED);
      borderColor = const Color(0xFFFFD700).withOpacity(0.5);
    } else if (rank == 2) {
      rankColor = const Color(0xFF607D8B);
      cardBg = const Color(0xFFF5F5F5);
      borderColor = const Color(0xFF90A4AE).withOpacity(0.4);
    } else if (rank == 3) {
      rankColor = const Color(0xFF795548);
      cardBg = const Color(0xFFFBF3EE);
      borderColor = const Color(0xFFBCAAA4).withOpacity(0.5);
    } else {
      rankColor = kLightBrown;
      cardBg = Colors.white;
      borderColor = Colors.transparent;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: kBurgundy.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              // Rank badge
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: rankColor.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    isTop ? medals[rank]! : '#$rank',
                    style: TextStyle(
                        fontSize: isTop ? 22 : 15,
                        fontWeight: FontWeight.bold,
                        color: rankColor),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(student.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: kBrown)),
                    Text(student.remark,
                        style: TextStyle(
                            fontSize: 12,
                            color: student.gradeColor,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              // Grade badge
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          student.gradeColor,
                          student.gradeColor.withOpacity(0.75)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(student.letterGrade,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                  ),
                  const SizedBox(height: 4),
                  Text('${student.average.toStringAsFixed(1)}%',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: student.gradeColor,
                          fontSize: 15)),
                ],
              ),
            ]),
            const SizedBox(height: 10),
            // Subject chips
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: student.subjects.asMap().entries.map((e) {
                final score =
                    e.key < student.scores.length ? student.scores[e.key] : 0.0;
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: kRose.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: kRose.withOpacity(0.4)),
                  ),
                  child: Text('${e.value}: ${score.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 11, color: kBrown)),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            // Progress bar
            Row(children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: student.average / 100,
                    minHeight: 9,
                    backgroundColor: kRose.withOpacity(0.2),
                    valueColor:
                        AlwaysStoppedAnimation<Color>(student.gradeColor),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Total: ${student.total.toStringAsFixed(0)}/${student.subjects.length * 100}',
                style: const TextStyle(
                    fontSize: 11,
                    color: kLightBrown,
                    fontWeight: FontWeight.w500),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildDistribution(List<Student> sorted) {
    final order = ['A+', 'A', 'B+', 'B', 'C+', 'C', 'D+', 'D', 'F'];
    final colors = {
      'A+': const Color(0xFF1B5E20),
      'A': const Color(0xFF388E3C),
      'B+': kBrown,
      'B': kLightBrown,
      'C+': const Color(0xFF795548),
      'C': const Color(0xFF8D6E63),
      'D+': const Color(0xFFE65100),
      'D': const Color(0xFFF57F17),
      'F': kBurgundy,
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: kBurgundy.withOpacity(0.07),
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        children: order.map((grade) {
          final count = sorted.where((s) => s.letterGrade == grade).length;
          if (count == 0) return const SizedBox.shrink();
          final fraction = count / sorted.length;
          final color = colors[grade] ?? kBrown;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(children: [
              SizedBox(
                  width: 30,
                  child: Text(grade,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                          fontSize: 13))),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LinearProgressIndicator(
                    value: fraction,
                    minHeight: 16,
                    backgroundColor: kRose.withOpacity(0.15),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text('$count student${count > 1 ? 's' : ''}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            ]),
          );
        }).toList(),
      ),
    );
  }

  void _showGradingKey(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('📋 Grading Key',
            style: TextStyle(color: kBurgundy, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            _GRow('A+', '90–100', 'Excellent'),
            _GRow('A', '80–89', 'Very Good'),
            _GRow('B+', '75–79', 'Very Good'),
            _GRow('B', '70–74', 'Good'),
            _GRow('C+', '65–69', 'Good'),
            _GRow('C', '60–64', 'Average'),
            _GRow('D+', '55–59', 'Pass'),
            _GRow('D', '50–54', 'Pass'),
            _GRow('F', '0–49', 'Fail'),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: kBurgundy)))
        ],
      ),
    );
  }

  String _gradeLabel(double avg) {
    if (avg >= 90) return 'Excellent';
    if (avg >= 80) return 'Very Good';
    if (avg >= 70) return 'Good';
    if (avg >= 60) return 'Average';
    if (avg >= 50) return 'Pass';
    return 'Fail';
  }
}

class _GRow extends StatelessWidget {
  final String grade, range, remark;
  const _GRow(this.grade, this.range, this.remark);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        SizedBox(
            width: 36,
            child: Text(grade,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: kBurgundy))),
        SizedBox(
            width: 80,
            child: Text(range,
                style: const TextStyle(fontSize: 13, color: kBrown))),
        Text(remark,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
      ]),
    );
  }
}
