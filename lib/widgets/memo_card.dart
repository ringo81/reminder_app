import 'package:flutter/material.dart';
import '../models/memo.dart';
import '../utils/constants.dart';

class MemoCard extends StatelessWidget {
  final Memo memo;
  final VoidCallback onToggleDone;
  final VoidCallback onTap;

  const MemoCard({
    super.key,
    required this.memo,
    required this.onToggleDone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheduleColor = memo.scheduleType.color;
    final scheduleTextColor = memo.scheduleType.textColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: memo.isDone ? const Color(0xFFF8FAFB) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: memo.isDone
                    ? const Color(0xFFEEF2F4)
                    : backgroundBlue,
                shape: BoxShape.circle,
              ),
              child: Icon(
                memo.icon,
                color: memo.isDone ? Colors.grey[400] : naturalBlack,
                size: 20,
              ),
            ),

            const SizedBox(width: 12),

            // Title + tag
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    memo.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: memo.isDone
                          ? Colors.grey[400]
                          : naturalBlack,
                      decoration: memo.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      decorationColor: Colors.grey[400],
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      // Schedule tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: memo.isDone
                              ? const Color(0xFFEEF0F2)
                              : scheduleColor.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          memo.scheduleType.label,
                          style: TextStyle(
                            fontSize: 11,
                            color: memo.isDone
                                ? Colors.grey[400]
                                : scheduleTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      // Custom tags
                      ...memo.tags.map((tag) => Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: tagBg,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                tag,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: tagText,
                                ),
                              ),
                            ),
                          )),

                      // Subtask count
                      if (memo.subTasks.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Row(
                            children: [
                              Icon(Icons.checklist_rounded,
                                  size: 12, color: Colors.grey[400]),
                              const SizedBox(width: 2),
                              Text(
                                '${memo.subTasks.where((s) => s.isDone).length}/${memo.subTasks.length}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Checkbox
            SizedBox(
              width: 32,
              height: 32,
              child: Transform.scale(
                scale: 1.2, // ← ここを変えるとサイズが変わる
                child: Checkbox(
                  shape: const CircleBorder(),
                  value: memo.isDone,
                  onChanged: (_) => onToggleDone(),
                  activeColor: mainLightBlue,
                  side: const BorderSide(color: mainLightBlue, width: 1.5),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
