import 'package:flutter/material.dart';
import '../models/memo.dart';
import '../utils/constants.dart';

class WeekCalendar extends StatelessWidget {
  final List<Memo> memos;
  const WeekCalendar({super.key, required this.memos});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    const weekdays = ['日', '月', '火', '水', '木', '金', '土'];

    // Compute start of week (Sunday)
    final startOfWeek = now.subtract(Duration(days: now.weekday % 7));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (index) {
        final date = startOfWeek.add(Duration(days: index));
        final isToday = date.day == now.day &&
            date.month == now.month &&
            date.year == now.year;

        // Check if any memo is due today
        final hasMemo = memos.any((m) =>
            !m.isDone &&
            m.scheduleType == ScheduleType.today &&
            isToday);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              weekdays[index],
              style: TextStyle(
                fontSize: 12,
                color: isToday ? mainLightBlue : Colors.grey[500],
                fontWeight:
                    isToday ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isToday ? mainLightBlue : Colors.transparent,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '${date.day}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight:
                      isToday ? FontWeight.bold : FontWeight.normal,
                  color: isToday ? Colors.white : naturalBlack,
                ),
              ),
            ),
            const SizedBox(height: 4),
            // Dot indicator if has memo
            AnimatedOpacity(
              opacity: hasMemo ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: mainLightBlue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
