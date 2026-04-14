import 'package:flutter/material.dart';

const kBurgundy = Color(0xFF6D1A2A);
const kBrown = Color(0xFF3E1A0E);
const kLightBrown = Color(0xFF8B5E3C);
const kCream = Color(0xFFFDF6F0);

class SetupSubjectsDialog extends StatefulWidget {
  final List<String> currentSubjects;
  const SetupSubjectsDialog({super.key, required this.currentSubjects});

  @override
  State<SetupSubjectsDialog> createState() => _SetupSubjectsDialogState();
}

class _SetupSubjectsDialogState extends State<SetupSubjectsDialog> {
  late List<TextEditingController> _ctrls;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _ctrls = widget.currentSubjects
        .map((s) => TextEditingController(text: s))
        .toList();
    if (_ctrls.isEmpty) _ctrls.add(TextEditingController());
  }

  @override
  void dispose() {
    for (final c in _ctrls) c.dispose();
    super.dispose();
  }

  void _add() {
    if (_ctrls.length >= 10) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Maximum 10 subjects.')));
      return;
    }
    setState(() => _ctrls.add(TextEditingController()));
  }

  void _remove(int i) {
    if (_ctrls.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('At least 1 subject required.')));
      return;
    }
    setState(() {
      _ctrls[i].dispose();
      _ctrls.removeAt(i);
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final subjects =
        _ctrls.map((c) => c.text.trim()).where((s) => s.isNotEmpty).toList();
    Navigator.pop(context, subjects);
  }

  @override
  Widget build(BuildContext context) {
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
              const Text('📚  Setup Subjects',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kBurgundy)),
              const SizedBox(height: 4),
              const Text('Define subjects for your class (1–10)',
                  style: TextStyle(fontSize: 13, color: kLightBrown)),
              const SizedBox(height: 16),
              ..._ctrls.asMap().entries.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(children: [
                      Expanded(
                        child: TextFormField(
                          controller: _ctrls[e.key],
                          decoration: InputDecoration(
                            labelText: 'Subject ${e.key + 1}',
                            prefixIcon:
                                const Icon(Icons.menu_book, color: kLightBrown),
                          ),
                          textCapitalization: TextCapitalization.words,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Enter subject name'
                              : null,
                        ),
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        icon: const Icon(Icons.remove_circle, color: kBurgundy),
                        onPressed: () => _remove(e.key),
                      ),
                    ]),
                  )),
              TextButton.icon(
                onPressed: _add,
                icon: const Icon(Icons.add, color: kBurgundy),
                label: const Text('Add Subject',
                    style: TextStyle(color: kBurgundy)),
              ),
              const SizedBox(height: 14),
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
                    onPressed: _save,
                    child: const Text('Save'),
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
