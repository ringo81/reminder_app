import 'package:flutter/material.dart';
import '../models/memo.dart';
import '../utils/constants.dart';
import '../widgets/icon_picker.dart';

class AddMemoScreen extends StatefulWidget {
  const AddMemoScreen({super.key});

  @override
  State<AddMemoScreen> createState() => _AddMemoScreenState();
}

class _AddMemoScreenState extends State<AddMemoScreen> {
  final _titleController = TextEditingController();
  IconData _selectedIcon = Icons.star;
  ScheduleType _selectedSchedule = ScheduleType.later;
  DateTime? _specifiedDate;
  final _tagController = TextEditingController();
  final List<String> _tags = [];

  @override
  void dispose() {
    _titleController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('タイトルを入力してください')),
      );
      return;
    }
    final memo = Memo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      icon: _selectedIcon,
      scheduleType: _selectedSchedule,
      specifiedDate: _specifiedDate,
      tags: List.from(_tags),
    );
    Navigator.pop(context, memo);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: mainLightBlue),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _specifiedDate = picked;
        _selectedSchedule = ScheduleType.dateSpecified;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGry,
      appBar: AppBar(
        backgroundColor: backgroundGry,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: naturalBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'やること追加',
          style: TextStyle(
            color: naturalBlack,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _submit,
            child: const Text(
              '追加',
              style: TextStyle(
                color: mainLightBlue,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title input
            _sectionLabel('タイトル'),
            const SizedBox(height: 8),
            Container(
              decoration: _cardDecoration(),
              child: TextField(
                controller: _titleController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'やることを入力...',
                  hintStyle: TextStyle(color: Color(0xFFBEC8CE)),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Schedule
            _sectionLabel('スケジュール'),
            const SizedBox(height: 12),
            _scheduleSelector(),

            const SizedBox(height: 24),

            // Icon picker
            _sectionLabel('アイコン'),
            const SizedBox(height: 12),
            IconPickerWidget(
              selected: _selectedIcon,
              onSelected: (icon) => setState(() => _selectedIcon = icon),
            ),

            const SizedBox(height: 24),

            // Tags
            _sectionLabel('タグ'),
            const SizedBox(height: 8),
            _tagInput(),
            if (_tags.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: _tags
                    .map((tag) => _tagChip(tag))
                    .toList(),
              ),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      );

  Widget _sectionLabel(String label) => Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          color: Color(0xFF8A9BA8),
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      );

  Widget _scheduleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ScheduleType.values
              .where((s) => s != ScheduleType.dateSpecified)
              .map((s) {
            final selected = _selectedSchedule == s;
            return GestureDetector(
              onTap: () => setState(() {
                _selectedSchedule = s;
                if (s != ScheduleType.dateSpecified) _specifiedDate = null;
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 9),
                decoration: BoxDecoration(
                  color: selected ? mainLightBlue : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Text(
                  s.label,
                  style: TextStyle(
                    fontSize: 13,
                    color: selected ? Colors.white : const Color(0xFF5A7C88),
                    fontWeight:
                        selected ? FontWeight.w700 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: _pickDate,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              color: _selectedSchedule == ScheduleType.dateSpecified
                  ? const Color(0xFFD4B8E0)
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: _selectedSchedule == ScheduleType.dateSpecified
                      ? const Color(0xFF5A3A7A)
                      : const Color(0xFF5A7C88),
                ),
                const SizedBox(width: 6),
                Text(
                  _specifiedDate != null
                      ? '${_specifiedDate!.year}/${_specifiedDate!.month}/${_specifiedDate!.day}'
                      : '日時指定',
                  style: TextStyle(
                    fontSize: 13,
                    color: _selectedSchedule == ScheduleType.dateSpecified
                        ? const Color(0xFF5A3A7A)
                        : const Color(0xFF5A7C88),
                    fontWeight: _selectedSchedule == ScheduleType.dateSpecified
                        ? FontWeight.w700
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _tagInput() {
    return Container(
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _tagController,
              decoration: const InputDecoration(
                hintText: 'タグを入力...',
                hintStyle: TextStyle(color: Color(0xFFBEC8CE)),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onSubmitted: (_) => _addTag(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline,
                color: mainLightBlue),
            onPressed: _addTag,
          ),
        ],
      ),
    );
  }

  Widget _tagChip(String tag) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: tagBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(tag,
              style: const TextStyle(fontSize: 12, color: tagText)),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => setState(() => _tags.remove(tag)),
            child: const Icon(Icons.close, size: 13, color: tagText),
          ),
        ],
      ),
    );
  }
}
