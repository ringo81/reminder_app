import 'package:flutter/material.dart';
import '../models/memo.dart';
import '../utils/constants.dart';
import '../widgets/icon_picker.dart';

class MemoDetailScreen extends StatefulWidget {
  final Memo memo;
  const MemoDetailScreen({super.key, required this.memo});

  @override
  State<MemoDetailScreen> createState() => _MemoDetailScreenState();
}

class _MemoDetailScreenState extends State<MemoDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late IconData _icon;
  late ScheduleType _schedule;
  late DateTime? _specifiedDate;
  late List<SubTask> _subTasks;
  late List<String> _tags;
  late bool _isDone;

  bool _showSubTaskInput = false; // ← 入力欄の表示フラグ
  final _subTaskController = TextEditingController();
  final _tagController = TextEditingController();
  final _subTaskFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final m = widget.memo;
    _titleController = TextEditingController(text: m.title);
    _descController = TextEditingController(text: m.description);
    _icon = m.icon;
    _schedule = m.scheduleType;
    _specifiedDate = m.specifiedDate;
    _subTasks = List.from(m.subTasks.map((s) => SubTask(
          id: s.id,
          title: s.title,
          isDone: s.isDone,
        )));
    _tags = List.from(m.tags);
    _isDone = m.isDone;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _subTaskController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _addSubTask() {
    final title = _subTaskController.text.trim();
    if (title.isEmpty) return;
    setState(() {
      _subTasks.add(SubTask(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
      ));
      _subTaskController.clear();
    });
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

  Memo _buildUpdated() => widget.memo.copyWith(
        title: _titleController.text.trim(),
        description: _descController.text,
        icon: _icon,
        scheduleType: _schedule,
        specifiedDate: _specifiedDate,
        isDone: _isDone,
        tags: List.from(_tags),
        subTasks: List.from(_subTasks),
      );

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _specifiedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
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
        _schedule = ScheduleType.dateSpecified;
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
          icon: const Icon(Icons.arrow_back_ios_new,
              color: naturalBlack, size: 18),
          onPressed: () => Navigator.pop(context, _buildUpdated()),
        ),
        title: const Text(
          '詳細',
          style: TextStyle(
            color: naturalBlack,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with icon and done checkbox
            _section(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (ctx) => FractionallySizedBox(
                          widthFactor: 1,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                            ),
                            padding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 16,
                              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'アイコン',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: naturalBlack,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                IconPickerWidget(
                                  selected: _icon,
                                  onSelected: (icon) {
                                    setState(() => _icon = icon);
                                    Navigator.of(ctx).pop();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: _isDone ? const Color(0xFFEEF2F4) : backgroundBlue,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          _icon,
                          size: 20,
                          color: _isDone ? Colors.grey[400] : naturalBlack,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _titleController,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: naturalBlack,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'タイトル',
                          hintStyle: TextStyle(color: Color(0xFFBEC8CE)),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 8),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                      child: Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                          shape: const CircleBorder(),
                          value: _isDone,
                          activeColor: mainLightBlue,
                          side: const BorderSide(color: mainLightBlue, width: 1.5),
                          onChanged: (v) => setState(() => _isDone = v ?? false),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            //── メモ詳細 + サブタスク（同一ボックス） ──
            _cardBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 詳細テキスト
                  TextField(
                    controller: _descController,
                    minLines: 3,
                    maxLines: null,
                    style: const TextStyle(fontSize: 14, color: naturalBlack),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'メモや詳細を追加...',
                      hintStyle: TextStyle(color: Color(0xFFBEC8CE)),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),

                  // サブタスク一覧（1件以上あるとき）
                  if (_subTasks.isNotEmpty) ...[
                    Divider(
                        height: 1,
                        color: Colors.grey[150] ?? const Color(0xFFF0F0F0),
                        indent: 16,
                        endIndent: 16),
                    const SizedBox(height: 4),
                    ..._subTasks.asMap().entries.map((entry) {
                      final i = entry.key;
                      final st = entry.value;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 32,
                              height: 32,
                              child: Transform.scale(
                                scale: 0.78,
                                child: Checkbox(
                                  shape: const CircleBorder(),
                                  value: st.isDone,
                                  activeColor: mainLightBlue,
                                  side: const BorderSide(
                                      color: mainLightBlue, width: 1.5),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  onChanged: (_) => setState(() {
                                    _subTasks[i] =
                                        st.copyWith(isDone: !st.isDone);
                                  }),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                st.title,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: st.isDone
                                      ? Colors.grey[400]
                                      : naturalBlack,
                                  decoration: st.isDone
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  decorationColor: Colors.grey[400],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  setState(() => _subTasks.removeAt(i)),
                              child: Padding(
                                padding: const EdgeInsets.all(6),
                                child: Icon(Icons.close,
                                    size: 14, color: Colors.grey[350]),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 4),
                  ],

                  // サブタスク入力欄（_showSubTaskInput == true のときだけ表示）
                  if (_showSubTaskInput) ...[
                    if (_subTasks.isEmpty)
                      Divider(
                          height: 1,
                          color:
                              Colors.grey[150] ?? const Color(0xFFF0F0F0),
                          indent: 16,
                          endIndent: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          const Icon(Icons.add,
                              size: 16, color: mainLightBlue),
                          const SizedBox(width: 4),
                          Expanded(
                            child: TextField(
                              controller: _subTaskController,
                              focusNode: _subTaskFocusNode,
                              style: const TextStyle(
                                  fontSize: 14, color: naturalBlack),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'サブタスクを入力...',
                                hintStyle:
                                    TextStyle(color: Color(0xFFBEC8CE)),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 10),
                              ),
                              onSubmitted: (_) => _addSubTask(),
                            ),
                          ),
                          TextButton(
                            onPressed: _addSubTask,
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                            ),
                            child: const Text('追加',
                                style: TextStyle(
                                    color: mainLightBlue,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, bottom: 8),
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _showSubTaskInput = false;
                          _subTaskController.clear();
                        }),
                        child: Text('キャンセル',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[400])),
                      ),
                    ),
                  ],

                  // 「+ サブタスクを追加」ボタン（入力欄が閉じているとき）
                  if (!_showSubTaskInput)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 12, bottom: 10, top: 2),
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _showSubTaskInput = true);
                          Future.delayed(const Duration(milliseconds: 50),
                              () => _subTaskFocusNode.requestFocus());
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_circle_outline,
                                size: 15, color: Colors.grey[400]),
                            const SizedBox(width: 5),
                            Text('サブタスクを追加',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[400])),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Schedule
            _sectionLabel('スケジュール'),
            const SizedBox(height: 10),
            _scheduleSelector(),

            const SizedBox(height: 20),

            // Tags
            _sectionLabel('タグ'),
            const SizedBox(height: 8),
            _section(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _tagController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'タグを追加...',
                        hintStyle: TextStyle(color: Color(0xFFBEC8CE)),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
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
            ),
            if (_tags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: _tags.map((t) => _tagChip(t)).toList(),
              ),
            ],

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _section({required Widget child}) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: child,
        ),
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
            final selected = _schedule == s;
            return GestureDetector(
              onTap: () => setState(() {
                _schedule = s;
                if (s != ScheduleType.dateSpecified) _specifiedDate = null;
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
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
                    color: selected
                        ? Colors.white
                        : const Color(0xFF5A7C88),
                    fontWeight:
                        selected ? FontWeight.w700 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickDate,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: _schedule == ScheduleType.dateSpecified
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
                  color: _schedule == ScheduleType.dateSpecified
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
                    color: _schedule == ScheduleType.dateSpecified
                        ? const Color(0xFF5A3A7A)
                        : const Color(0xFF5A7C88),
                    fontWeight: _schedule == ScheduleType.dateSpecified
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

  Widget _cardBox({required Widget child}) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: child,
        ),
      );

  Widget _tagChip(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
