import 'dart:async';
import 'package:flutter/material.dart';
import '../models/todo.dart';
import 'package:luar_sekolah_lms/features/todo_module/services/todo_api_service.dart';

class TodoCrudScreen extends StatefulWidget {
  const TodoCrudScreen({super.key});
  @override
  State<TodoCrudScreen> createState() => _TodoCrudScreenState();
}

class _TodoCrudScreenState extends State<TodoCrudScreen> {
  final _api = TodoApiServiceHttp();
  final _scroll = ScrollController();

  bool _loading = false;
  String? _error;
  final List<Todo> _items = [];
  int _offset = 0;
  final int _limit = 20;
  bool _hasMore = true;

  bool? _filterCompleted;
  String _query = '';
  Timer? _deb;

  @override
  void initState() {
    super.initState();
    _load(reset: true);
    _scroll.addListener(() {
      if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 200)
        _load();
    });
  }

  @override
  void dispose() {
    _deb?.cancel();
    _scroll.dispose();
    super.dispose();
  }

  String _msg(dynamic e) => 'Terjadi kesalahan: ${e.toString()}';

  Future<void> _load({bool reset = false}) async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _error = null;
      if (reset) {
        _items.clear();
        _offset = 0;
        _hasMore = true;
      }
    });
    try {
      if (!_hasMore) return;
      final page = await _api.fetchTodos(
        limit: _limit,
        offset: _offset,
        completed: _filterCompleted,
      );
      setState(() {
        _items.addAll(page);
        _offset += page.length;
        _hasMore = page.length == _limit;
      });
    } catch (e) {
      setState(() => _error = _msg(e));
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _create() async {
    final r = await showDialog<_Draft>(
      context: context,
      builder: (_) => const _TodoDialog(title: 'Create Todo'),
    );
    if (r == null) return;

    setState(() => _loading = true);
    try {
      final created = await _api.createTodo(
        text: r.text,
        completed: r.completed,
      );
      setState(() => _items.insert(0, created));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_msg(e))));
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _edit(Todo t) async {
    final r = await showDialog<_Draft>(
      context: context,
      builder: (_) => _TodoDialog(title: 'Edit Todo', initial: t),
    );
    if (r == null) return;

    // optimistic
    final i = _items.indexWhere((e) => e.id == t.id);
    if (i == -1) return;
    final before = _items[i];
    setState(
      () => _items[i] = before.copyWith(
        text: r.text,
        completed: r.completed,
        updatedAt: DateTime.now(),
      ),
    );
    try {
      final updated = await _api.updateTodo(
        t.id,
        text: r.text,
        completed: r.completed,
      );
      setState(() => _items[i] = updated);
    } catch (e) {
      setState(() => _items[i] = before);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal update: ${_msg(e)}')));
    }
  }

  Future<void> _toggle(Todo t) async {
    final i = _items.indexWhere((e) => e.id == t.id);
    if (i == -1) return;
    final before = _items[i];
    setState(
      () => _items[i] = before.copyWith(
        completed: !before.completed,
        updatedAt: DateTime.now(),
      ),
    );
    try {
      final updated = await _api.toggleTodo(t.id);
      setState(() => _items[i] = updated);
    } catch (e) {
      setState(() => _items[i] = before);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal toggle: ${_msg(e)}')));
    }
  }

  Future<void> _delete(Todo t) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Todo'),
        content: Text('Hapus todo "${t.text}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    final before = List<Todo>.from(_items);
    setState(() => _items.removeWhere((e) => e.id == t.id));
    try {
      await _api.deleteTodo(t.id);
    } catch (e) {
      setState(() {
        _items
          ..clear()
          ..addAll(before);
      });
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menghapus: ${_msg(e)}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _query.isEmpty
        ? _items
        : _items
              .where((e) => e.text.toLowerCase().contains(_query.toLowerCase()))
              .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos (HTTP) — CRUD'),
        actions: [
          IconButton(
            onPressed: () => _load(reset: true),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _create,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          if (_loading) const LinearProgressIndicator(minHeight: 2),
          if (_error != null)
            Container(
              width: double.infinity,
              color: Colors.red.withOpacity(.08),
              padding: const EdgeInsets.all(12),
              child: Text(
                'Error: $_error',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          _FilterBar(
            selected: _filterCompleted,
            onSelected: (v) {
              setState(() => _filterCompleted = v);
              _load(reset: true);
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Cari judul…',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) {
                _deb?.cancel();
                _deb = Timer(
                  const Duration(milliseconds: 250),
                  () => setState(() => _query = v),
                );
              },
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _load(reset: true),
              child: ListView.separated(
                controller: _scroll,
                itemCount: filtered.length + (_hasMore ? 1 : 0),
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  if (index == filtered.length) {
                    return const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final t = filtered[index];
                  return ListTile(
                    leading: IconButton(
                      icon: Icon(
                        t.completed
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                      ),
                      onPressed: () => _toggle(t),
                      tooltip: 'Toggle Completed',
                    ),
                    title: Text(
                      t.text,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: t.completed
                          ? const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                    // subtitle: Text('ID: ${t.id}'),
                    onTap: () => _edit(t),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _delete(t),
                      tooltip: 'Delete',
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final bool? selected; // null/true/false
  final ValueChanged<bool?> onSelected;
  const _FilterBar({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Wrap(
        spacing: 8,
        children: [
          ChoiceChip(
            label: const Text('All'),
            selected: selected == null,
            onSelected: (_) => onSelected(null),
          ),
          ChoiceChip(
            label: const Text('Completed'),
            selected: selected == true,
            onSelected: (_) => onSelected(true),
          ),
          ChoiceChip(
            label: const Text('Pending'),
            selected: selected == false,
            onSelected: (_) => onSelected(false),
          ),
        ],
      ),
    );
  }
}

class _TodoDialog extends StatefulWidget {
  final String title;
  final Todo? initial;
  const _TodoDialog({required this.title, this.initial});
  @override
  State<_TodoDialog> createState() => _TodoDialogState();
}

class _TodoDialogState extends State<_TodoDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _textC = TextEditingController(
    text: widget.initial?.text ?? '',
  );
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _completed = widget.initial?.completed ?? false;
  }

  @override
  void dispose() {
    _textC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _textC,
              decoration: const InputDecoration(labelText: 'Text'),
              maxLength: 500,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              value: _completed,
              onChanged: (v) => setState(() => _completed = v),
              title: const Text('Completed'),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState?.validate() != true) return;
            Navigator.pop(
              context,
              _Draft(text: _textC.text.trim(), completed: _completed),
            );
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}

class _Draft {
  final String text;
  final bool completed;
  _Draft({required this.text, required this.completed});
}
