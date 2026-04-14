import 'package:flutter/material.dart';
import '../models/student.dart';

const kBurgundy = Color(0xFF6D1A2A);
const kBrown = Color(0xFF3E1A0E);
const kLightBrown = Color(0xFF8B5E3C);
const kCream = Color(0xFFFDF6F0);
const kRose = Color(0xFFD4A89A);

class AddStudentDialog extends StatefulWidget {
  final List<String> subjects;
  final Student? existingStudent;

  const AddStudentDialog({
    super.key,
    required this.subjects,
    this.existingStudent,
  });

  @override
  State<AddStudentDialog> createState() => _AddStudentDialogState();
}

class _AddStudentDialogState extends State<AddStudentDialog> {
  final _nameCtrl = TextEditingController();
  late List<TextEditingController> _scoreCtrl;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameCtrl.text = widget.existingStudent?.name ?? '';
    _scoreCtrl = List.generate(widget.subjects.length, (i) {
      final score = widget.existingStudent != null &&
              i < widget.existingStudent!.scores.length
          ? widget.existingStudent!.scores[i]
          : 0.0;
      return TextEditingController(
          text: score == 0 ? '' : score.toStringAsFixed(0));
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    for (final c in _scoreCtrl) c.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final scores =
        _scoreCtrl.map((c) => double.tryParse(c.text.trim()) ?? 0.0).toList();
    Navigator.pop(
      context,
      Student(
        name: _nameCtrl.text.trim(),
        subjects: widget.subjects,
        scores: scores,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingStudent != null;
    return Dialog(
      backgroundColor: kCream,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? '✏️  Edit Student' : '➕  Add Student',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kBurgundy),
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Student Name',
                  prefixIcon: Icon(Icons.person, color: kBurgundy),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Please enter a name'
                    : null,
              ),
              const SizedBox(height: 18),
              const Text('Enter Scores (0 – 100)',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: kBrown)),
              const SizedBox(height: 10),
              ...widget.subjects.asMap().entries.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextFormField(
                      controller: _scoreCtrl[e.key],
                      decoration: InputDecoration(
                        labelText: e.value,
                        prefixIcon: const Icon(Icons.grade, color: kLightBrown),
                        suffixText: '/100',
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Enter score';
                        final n = double.tryParse(v.trim());
                        if (n == null) return 'Invalid number';
                        if (n < 0 || n > 100) return '0–100 only';
                        return null;
                      },
                    ),
                  )),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: kBurgundy),
                      foregroundColor: kBurgundy,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: Text(isEditing ? 'Update' : 'Add'),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
