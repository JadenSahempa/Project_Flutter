import 'package:flutter/material.dart';

/// Hasil dari dialog Todo (dipakai di TodoListScreen)
class TodoFormResult {
  final String title;
  final String description;
  final DateTime? reminderAt;

  TodoFormResult({
    required this.title,
    required this.description,
    this.reminderAt,
  });
}

/// Dialog form untuk Create / Edit To-Do
class TodoFormDialog extends StatefulWidget {
  /// Judul dialog, misal: "Tambah To-Do" / "Edit To-Do"
  final String titleText;

  /// Nilai awal untuk mode edit
  final String? initialTitle;
  final String? initialDescription;
  final DateTime? initialReminderAt;

  const TodoFormDialog({
    super.key,
    this.titleText = 'Tambah To-Do',
    this.initialTitle,
    this.initialDescription,
    this.initialReminderAt,
  });

  @override
  State<TodoFormDialog> createState() => _TodoFormDialogState();
}

class _TodoFormDialogState extends State<TodoFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleC;
  late final TextEditingController _descC;
  DateTime? _reminderAt;

  @override
  void initState() {
    super.initState();
    _titleC = TextEditingController(text: widget.initialTitle ?? '');
    _descC = TextEditingController(text: widget.initialDescription ?? '');
    _reminderAt = widget.initialReminderAt;
  }

  @override
  void dispose() {
    _titleC.dispose();
    _descC.dispose();
    super.dispose();
  }

  Future<void> _pickReminder() async {
    final now = DateTime.now();

    // Pilih tanggal
    final date = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDate: _reminderAt ?? now,
    );
    if (date == null) return;

    // Pilih jam
    final time = await showTimePicker(
      context: context,
      initialTime: _reminderAt != null
          ? TimeOfDay.fromDateTime(_reminderAt!)
          : TimeOfDay.fromDateTime(now),
    );
    if (time == null) return;

    setState(() {
      _reminderAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _clearReminder() {
    setState(() {
      _reminderAt = null;
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.of(context).pop(
      TodoFormResult(
        title: _titleC.text.trim(),
        description: _descC.text.trim(),
        reminderAt: _reminderAt,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.titleText),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Nama todo
              TextFormField(
                controller: _titleC,
                decoration: const InputDecoration(labelText: 'Nama To-Do'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),

              // Deskripsi
              TextFormField(
                controller: _descC,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi (opsional)',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),

              // Reminder
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _reminderAt == null
                          ? 'Tidak ada reminder'
                          : 'Reminder: ${_reminderAt!.toLocal()}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: _pickReminder,
                    icon: const Icon(Icons.alarm),
                    label: const Text('Atur Reminder'),
                  ),
                  const SizedBox(width: 8),
                  if (_reminderAt != null)
                    TextButton(
                      onPressed: _clearReminder,
                      child: const Text('Hapus Reminder'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Simpan')),
      ],
    );
  }
}
