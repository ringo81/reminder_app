import 'package:flutter/material.dart';

enum ScheduleType {
  today,
  thisWeek,
  thisMonth,
  later,
  dateSpecified,
}

extension ScheduleTypeLabel on ScheduleType {
  String get label {
    switch (this) {
      case ScheduleType.today:
        return '今日';
      case ScheduleType.thisWeek:
        return '今週中';
      case ScheduleType.thisMonth:
        return '今月中';
      case ScheduleType.later:
        return 'あとで';
      case ScheduleType.dateSpecified:
        return '日時指定';
    }
  }

  Color get color {
    switch (this) {
      case ScheduleType.today:
        return const Color(0xFFE8A598);
      case ScheduleType.thisWeek:
        return const Color(0xFFA8C8E8);
      case ScheduleType.thisMonth:
        return const Color(0xFFABD2D6);
      case ScheduleType.later:
        return const Color(0xFFCBD5E0);
      case ScheduleType.dateSpecified:
        return const Color(0xFFD4B8E0);
    }
  }

  Color get textColor {
    switch (this) {
      case ScheduleType.today:
        return const Color(0xFF8B4A3D);
      case ScheduleType.thisWeek:
        return const Color(0xFF2D5A7A);
      case ScheduleType.thisMonth:
        return const Color(0xFF3A7A7E);
      case ScheduleType.later:
        return const Color(0xFF4A5568);
      case ScheduleType.dateSpecified:
        return const Color(0xFF5A3A7A);
    }
  }
}

class SubTask {
  String id;
  String title;
  bool isDone;

  SubTask({
    required this.id,
    required this.title,
    this.isDone = false,
  });

  SubTask copyWith({String? id, String? title, bool? isDone}) {
    return SubTask(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }
}

class Memo {
  String id;
  String title;
  String description;
  IconData icon;
  ScheduleType scheduleType;
  DateTime? specifiedDate;
  bool isDone;
  List<String> tags;
  List<SubTask> subTasks;
  DateTime createdAt;

  Memo({
    required this.id,
    required this.title,
    this.description = '',
    required this.icon,
    required this.scheduleType,
    this.specifiedDate,
    this.isDone = false,
    this.tags = const [],
    this.subTasks = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Memo copyWith({
    String? id,
    String? title,
    String? description,
    IconData? icon,
    ScheduleType? scheduleType,
    DateTime? specifiedDate,
    bool? isDone,
    List<String>? tags,
    List<SubTask>? subTasks,
  }) {
    return Memo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      scheduleType: scheduleType ?? this.scheduleType,
      specifiedDate: specifiedDate ?? this.specifiedDate,
      isDone: isDone ?? this.isDone,
      tags: tags ?? List.from(this.tags),
      subTasks: subTasks ?? List.from(this.subTasks),
      createdAt: this.createdAt,
    );
  }
}
