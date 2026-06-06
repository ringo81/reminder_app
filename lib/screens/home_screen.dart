import 'package:flutter/material.dart';
import '../models/memo.dart';
import '../utils/constants.dart';
import '../widgets/memo_card.dart';
import '../widgets/week_calendar.dart';
import 'add_memo_screen.dart';
import 'memo_detail_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Memo> _memos = [
    Memo(
      id: '1',
      title: '気になってるカフェに行く',
      icon: Icons.coffee,
      scheduleType: ScheduleType.thisMonth,
      tags: ['お出かけ'],
    ),
    Memo(
      id: '2',
      title: '展示会に行く',
      icon: Icons.museum,
      scheduleType: ScheduleType.later,
      tags: ['文化'],
    ),
  ];

  String _selectedFilter = 'すべて';
  String _sortMode = 'manual'; // 'manual' or 'schedule'
  List<String> _allTags = ['すべて'];

  @override
  void initState() {
    super.initState();
    _refreshTags();
  }

  void _refreshTags() {
    final tags = <String>{'すべて'};
    for (final memo in _memos) {
      tags.addAll(memo.tags);
    }
    setState(() {
      _allTags = tags.toList();
    });
  }

  List<Memo> get _filteredMemos {
    List<Memo> result = _selectedFilter == 'すべて'
        ? List.from(_memos)
        : _memos.where((m) => m.tags.contains(_selectedFilter)).toList();

    if (_sortMode == 'schedule') {
      result.sort((a, b) =>
          a.scheduleType.index.compareTo(b.scheduleType.index));
    }

    return result;
  }

  void _addMemo(Memo memo) {
    setState(() {
      _memos.add(memo);
    });
    _refreshTags();
  }

  void _updateMemo(Memo updated) {
    setState(() {
      final idx = _memos.indexWhere((m) => m.id == updated.id);
      if (idx != -1) _memos[idx] = updated;
    });
    _refreshTags();
  }

  void _deleteMemo(String id) {
    setState(() {
      _memos.removeWhere((m) => m.id == id);
    });
    _refreshTags();
  }

  void _toggleDone(String id) {
    setState(() {
      final idx = _memos.indexWhere((m) => m.id == id);
      if (idx != -1) {
        _memos[idx] = _memos[idx].copyWith(isDone: !_memos[idx].isDone);
      }
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      final filtered = _filteredMemos;
      if (newIndex > oldIndex) newIndex -= 1;

      final movedMemo = filtered[oldIndex];
      final targetMemo = filtered[newIndex];

      final globalOld = _memos.indexWhere((m) => m.id == movedMemo.id);
      final globalNew = _memos.indexWhere((m) => m.id == targetMemo.id);

      if (globalOld != -1 && globalNew != -1) {
        final item = _memos.removeAt(globalOld);
        _memos.insert(globalNew, item);
      }
    });
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '並び替え',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: naturalBlack,
              ),
            ),
            const SizedBox(height: 16),
            _sortTile('手動', 'manual'),
            _sortTile('期限順', 'schedule'),
          ],
        ),
      ),
    );
  }

  Widget _sortTile(String label, String mode) {
    final selected = _sortMode == mode;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label,
          style: TextStyle(
            color: selected ? mainLightBlue : naturalBlack,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          )),
      trailing: selected
          ? const Icon(Icons.check, color: mainLightBlue)
          : null,
      onTap: () {
        setState(() => _sortMode = mode);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredMemos;

    return Scaffold(
      backgroundColor: backgroundGry,
      appBar: AppBar(
        backgroundColor: backgroundGry,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.settings_outlined,
                  color: naturalBlack,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Week Calendar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: WeekCalendar(memos: _memos),
            ),
          ),

          // Draggable bottom sheet
          DraggableScrollableSheet(
            initialChildSize: 0.76,
            minChildSize: 0.5,
            maxChildSize: 0.96,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x10000000),
                      blurRadius: 20,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Drag handle
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 6),
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // Header row
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: Row(
                        children: [
                          Text(
                            _selectedFilter,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: naturalBlack,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: _showSortSheet,
                            child: Icon(
                              Icons.more_horiz,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Tag filter chips
                    if (_allTags.length > 1)
                      SizedBox(
                        height: 36,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _allTags.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 8),
                          itemBuilder: (_, i) {
                            final tag = _allTags[i];
                            final selected = _selectedFilter == tag;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedFilter = tag),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: 34,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14),
                                decoration: BoxDecoration(
                                  color:
                                      selected ? mainLightBlue : backgroundGry,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  tag,
                                  style: TextStyle(
                                    fontSize: 12,
                                    height: 1.0,
                                    color: selected
                                        ? Colors.white
                                        : subtleGrey,
                                    fontWeight: selected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                    const SizedBox(height: 8),

                    // Memo list
                    Expanded(
                      child: filtered.isEmpty
                          ? Center(
                              child: Text(
                                'メモはまだありません',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                              ),
                            )
                          : _sortMode == 'manual'
                              ? ReorderableListView(
                                  scrollController: scrollController,
                                  onReorder: _onReorder,
                                  proxyDecorator: (child, index, animation) =>
                                      Material(
                                    color: Colors.transparent,
                                    child: child,
                                  ),
                                  children: filtered
                                      .map((memo) => _buildDismissible(memo))
                                      .toList(),
                                )
                              : ListView(
                                  controller: scrollController,
                                  children: filtered
                                      .map((memo) => _buildDismissible(memo))
                                      .toList(),
                                ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainLightBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        onPressed: () async {
          final newMemo = await Navigator.push<Memo>(
            context,
            MaterialPageRoute(
              builder: (_) => const AddMemoScreen(),
            ),
          );
          if (newMemo != null) _addMemo(newMemo);
        },
        child: const Icon(Icons.add, color: naturalBlack, size: 28),
      ),
    );
  }

  Widget _buildDismissible(Memo memo) {
    return Dismissible(
      key: ValueKey('dismiss_${memo.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _deleteMemo(memo.id),
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFE8796A),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: MemoCard(
        key: ValueKey(memo.id),
        memo: memo,
        onToggleDone: () => _toggleDone(memo.id),
        onTap: () async {
          final updated = await Navigator.push<Memo>(
            context,
            MaterialPageRoute(
              builder: (_) => MemoDetailScreen(memo: memo),
            ),
          );
          if (updated != null) _updateMemo(updated);
        },
      ),
    );
  }
}
