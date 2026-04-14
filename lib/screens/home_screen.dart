import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart' as ex hide Border;
import '../models/student.dart';
import '../widgets/add_student_dialog.dart';
import '../widgets/setup_subjects_dialog.dart';
import 'results_screen.dart';

// ─── Palette ────────────────────────────────────────────────────────────────
const kBurgundy = Color(0xFF6D1A2A);
const kDarkBurgundy = Color(0xFF4A0E1A);
const kBrown = Color(0xFF3E1A0E);
const kLightBrown = Color(0xFF8B5E3C);
const kCream = Color(0xFFFDF6F0);
const kRose = Color(0xFFD4A89A);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ── Upload tab state ──────────────────────────────────────────
  bool _isLoading = false;
  String? _fileName;
  String? _errorMessage;

  // ── Manual tab state ──────────────────────────────────────────
  List<String> _subjects = ['Mathematics', 'English', 'Science'];

  // ── Shared ────────────────────────────────────────────────────
  List<Student> _students = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ════════════════════════════════════════════════════════════════
  //  FILE UPLOAD LOGIC
  // ════════════════════════════════════════════════════════════════
  Future<void> _pickAndParseFile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _students = [];
      _fileName = null;
    });
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
        withData: true,
      );
      if (result == null || result.files.isEmpty) {
        setState(() => _isLoading = false);
        return;
      }
      final file = result.files.first;
      _fileName = file.name;
      final bytes = file.bytes;
      if (bytes == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Could not read file. Please try again.';
        });
        return;
      }
      final excel = ex.Excel.decodeBytes(bytes);
      final sheet = excel.tables[excel.tables.keys.first];
      if (sheet == null || sheet.rows.isEmpty) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'The Excel file is empty.';
        });
        return;
      }
      final headers =
          sheet.rows[0].map((c) => c?.value?.toString().trim() ?? '').toList();
      if (headers.isEmpty || headers[0].isEmpty) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'First column must be the student name.';
        });
        return;
      }
      final subjects = headers.sublist(1).where((h) => h.isNotEmpty).toList();
      if (subjects.isEmpty) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'No subject columns found in row 1.';
        });
        return;
      }
      final List<Student> students = [];
      for (int i = 1; i < sheet.rows.length; i++) {
        final row = sheet.rows[i];
        if (row.isEmpty) continue;
        final name = row[0]?.value?.toString().trim() ?? '';
        if (name.isEmpty) continue;
        final List<double> scores = [];
        for (int j = 1; j <= subjects.length; j++) {
          final raw = j < row.length ? row[j]?.value?.toString() : null;
          double score = double.tryParse(raw ?? '') ?? 0;
          scores.add(score.clamp(0, 100));
        }
        students.add(Student(name: name, subjects: subjects, scores: scores));
      }
      if (students.isEmpty) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'No student data found from row 2 onwards.';
        });
        return;
      }
      setState(() {
        _students = students;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to parse file: $e';
      });
    }
  }

  // ════════════════════════════════════════════════════════════════
  //  MANUAL ENTRY LOGIC
  // ════════════════════════════════════════════════════════════════
  void _openSetupSubjects() async {
    final result = await showDialog<List<String>>(
      context: context,
      builder: (_) => SetupSubjectsDialog(currentSubjects: _subjects),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        _subjects = result;
        _students = _students
            .map((s) => Student(
                  name: s.name,
                  subjects: _subjects,
                  scores: List.filled(_subjects.length, 0),
                ))
            .toList();
      });
    }
  }

  void _addStudent() async {
    if (_subjects.isEmpty) {
      _snack('Please set up subjects first.');
      return;
    }
    final result = await showDialog<Student>(
      context: context,
      builder: (_) => AddStudentDialog(subjects: _subjects),
    );
    if (result != null) setState(() => _students.add(result));
  }

  void _editStudent(int index) async {
    final result = await showDialog<Student>(
      context: context,
      builder: (_) => AddStudentDialog(
        subjects: _subjects,
        existingStudent: _students[index],
      ),
    );
    if (result != null) setState(() => _students[index] = result);
  }

  void _deleteStudent(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Remove Student',
            style: TextStyle(color: kBurgundy, fontWeight: FontWeight.bold)),
        content: Text('Remove ${_students[index].name}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  const Text('Cancel', style: TextStyle(color: kLightBrown))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kBurgundy),
            onPressed: () {
              setState(() => _students.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: kBurgundy,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  void _viewResults() {
    if (_students.isEmpty) {
      _snack('No students to show results for.');
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => ResultsScreen(students: List.from(_students))),
    );
  }

  // ════════════════════════════════════════════════════════════════
  //  BUILD
  // ════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
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
        title: const Text(
          '🎓 Student Grade Calculator',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 19, letterSpacing: 0.5),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: kRose,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(icon: Icon(Icons.upload_file), text: 'Upload Excel'),
            Tab(icon: Icon(Icons.edit_note), text: 'Manual Entry'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUploadTab(),
          _buildManualTab(),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════
  //  UPLOAD TAB
  // ════════════════════════════════════════════════════════════════
  Widget _buildUploadTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUploadHero(),
          const SizedBox(height: 20),
          _buildFormatGuide(),
          if (_students.isNotEmpty) ...[
            const SizedBox(height: 20),
            _buildPreview(),
            const SizedBox(height: 16),
            _resultsButton(),
          ],
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildUploadHero() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kDarkBurgundy, kBurgundy],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kBurgundy.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.upload_file, size: 52, color: Colors.white),
          ),
          const SizedBox(height: 14),
          const Text('Upload Student Excel File',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.4)),
          const SizedBox(height: 6),
          Text(
            'Upload an .xlsx file with student names\nand subject scores in columns',
            textAlign: TextAlign.center,
            style:
                TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
          ),
          const SizedBox(height: 22),
          if (_isLoading)
            const CircularProgressIndicator(color: Colors.white)
          else
            ElevatedButton.icon(
              icon: const Icon(Icons.folder_open),
              label: Text(
                _fileName != null ? 'Change File' : 'Choose File (.xlsx)',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: kBurgundy,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: _pickAndParseFile,
            ),
          if (_fileName != null) ...[
            const SizedBox(height: 14),
            _pill(
              icon: Icons.check_circle,
              iconColor: Colors.greenAccent,
              text: _fileName!,
              bg: Colors.white.withOpacity(0.18),
            ),
          ],
          if (_errorMessage != null) ...[
            const SizedBox(height: 10),
            _pill(
              icon: Icons.error_outline,
              iconColor: Colors.redAccent.shade100,
              text: _errorMessage!,
              bg: Colors.red.withOpacity(0.2),
            ),
          ],
        ],
      ),
    );
  }

  Widget _pill(
      {required IconData icon,
      required Color iconColor,
      required String text,
      required Color bg}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(30)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 15),
          const SizedBox(width: 7),
          Flexible(
            child: Text(text,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatGuide() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Icon(Icons.table_view, color: kBurgundy, size: 20),
              const SizedBox(width: 8),
              const Text('Expected File Format',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: kBurgundy)),
            ]),
            const SizedBox(height: 12),
            const Text('Row 1 = headers, Row 2+ = student data:',
                style: TextStyle(fontSize: 13)),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Table(
                border: TableBorder.all(color: kRose.withOpacity(0.5)),
                children: const [
                  TableRow(
                    decoration: BoxDecoration(color: Color(0xFFF5DDD5)),
                    children: [
                      _TCell('Name', h: true),
                      _TCell('Maths', h: true),
                      _TCell('English', h: true),
                      _TCell('Science', h: true),
                    ],
                  ),
                  TableRow(children: [
                    _TCell('Alice'),
                    _TCell('85'),
                    _TCell('78'),
                    _TCell('92'),
                  ]),
                  TableRow(children: [
                    _TCell('Bob'),
                    _TCell('60'),
                    _TCell('55'),
                    _TCell('70'),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _tip('First column = student names'),
            _tip('Remaining columns = subjects (scores 0–100)'),
            _tip('Any number of subjects is supported'),
          ],
        ),
      ),
    );
  }

  Widget _tip(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(children: [
          const Icon(Icons.check_circle, color: kBurgundy, size: 14),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 12, color: kBrown)),
        ]),
      );

  Widget _buildPreview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Icon(Icons.people, color: kBurgundy, size: 20),
              const SizedBox(width: 8),
              Text('${_students.length} Students Loaded',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: kBurgundy)),
            ]),
            const SizedBox(height: 10),
            ..._students.take(5).map((s) => Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: kCream,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: kRose.withOpacity(0.4)),
                  ),
                  child: Row(children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: kBurgundy.withOpacity(0.12),
                      child: Text(s.name[0].toUpperCase(),
                          style: const TextStyle(
                              color: kBurgundy,
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(s.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14))),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: s.gradeColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${s.average.toStringAsFixed(1)}% · ${s.letterGrade}',
                        style: TextStyle(
                            color: s.gradeColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ),
                  ]),
                )),
            if (_students.length > 5)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '+ ${_students.length - 5} more students…',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      fontStyle: FontStyle.italic),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════
  //  MANUAL TAB
  // ════════════════════════════════════════════════════════════════
  Widget _buildManualTab() {
    return Column(
      children: [
        // Subjects bar
        Container(
          color: kBurgundy.withOpacity(0.06),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(children: [
            const Icon(Icons.menu_book, color: kBurgundy, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Subjects: ${_subjects.join(' · ')}',
                style: const TextStyle(
                    color: kBurgundy,
                    fontWeight: FontWeight.w600,
                    fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(
              onPressed: _openSetupSubjects,
              child: const Text('Edit',
                  style: TextStyle(color: kBurgundy, fontSize: 12)),
            ),
          ]),
        ),

        // Student count header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_students.length} Student${_students.length == 1 ? '' : 's'}',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: kBrown),
              ),
              if (_students.isNotEmpty)
                TextButton.icon(
                  onPressed: () => setState(() => _students.clear()),
                  icon: const Icon(Icons.clear_all, size: 16, color: kBurgundy),
                  label: const Text('Clear All',
                      style: TextStyle(color: kBurgundy, fontSize: 12)),
                ),
            ],
          ),
        ),

        // List
        Expanded(
          child: _students.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.people_outline,
                          size: 72, color: kRose.withOpacity(0.5)),
                      const SizedBox(height: 12),
                      const Text('No students yet',
                          style: TextStyle(
                              fontSize: 17,
                              color: kLightBrown,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 6),
                      const Text('Tap Add Student to begin',
                          style: TextStyle(fontSize: 13, color: kRose)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _students.length,
                  itemBuilder: (_, i) {
                    final s = _students[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        leading: CircleAvatar(
                          backgroundColor: kBurgundy.withOpacity(0.13),
                          child: Text(
                            s.name[0].toUpperCase(),
                            style: const TextStyle(
                                color: kBurgundy, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(s.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, color: kBrown)),
                        subtitle: Text(
                          'Scores: ${s.scores.map((sc) => sc.toStringAsFixed(0)).join(', ')}',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: s.gradeColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                s.letterGrade,
                                style: TextStyle(
                                    color: s.gradeColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  size: 20, color: kLightBrown),
                              onPressed: () => _editStudent(i),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  size: 20, color: kBurgundy),
                              onPressed: () => _deleteStudent(i),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),

        // Bottom bar
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: kBurgundy.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, -3),
              )
            ],
          ),
          child: Row(children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.person_add),
                label: const Text('Add Student'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: kBurgundy),
                  foregroundColor: kBurgundy,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _addStudent,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: _resultsButton()),
          ]),
        ),
      ],
    );
  }

  Widget _resultsButton() => ElevatedButton.icon(
        icon: const Icon(Icons.bar_chart),
        label: const Text('Calculate Results',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        style: ElevatedButton.styleFrom(
          backgroundColor: kBurgundy,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: _viewResults,
      );
}

// ─── Small helper widgets ────────────────────────────────────────────────────
class _TCell extends StatelessWidget {
  final String text;
  final bool h;
  const _TCell(this.text, {this.h = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      child: Text(text,
          style: TextStyle(
              fontSize: 12,
              fontWeight: h ? FontWeight.bold : FontWeight.normal,
              color: h ? kBurgundy : kBrown)),
    );
  }
}
