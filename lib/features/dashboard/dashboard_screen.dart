import 'package:flutter/material.dart';

import '../../core/routes/route_names.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/widgets.dart';
import 'models/event_item.dart';
import 'models/task_item.dart';
import 'widgets/event_card.dart';
import 'widgets/section_title.dart';
import 'widgets/task_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const List<TaskItem> _tasks = [
    TaskItem(
      project: 'Гуманітарний конвой Харків',
      title: 'Координація видачі гуманітарних наборів',
      priority: TaskPriority.high,
      status: TaskStatus.inProgress,
      dueLabel: 'Сьогодні, 18:00',
      isUrgent: true,
    ),
    TaskItem(
      project: 'Евакуація прифронтових зон',
      title: 'Складання списків волонтерів-водіїв',
      priority: TaskPriority.medium,
      status: TaskStatus.todo,
      dueLabel: 'Завтра, 12:00',
    ),
    TaskItem(
      project: 'Медичний хаб Центр',
      title: 'Перевірка складських залишків медпрепаратів',
      priority: TaskPriority.low,
      status: TaskStatus.done,
      dueLabel: 'Вчора , 16:00',
    ),
  ];

  static const List<EventItem> _events = [
    EventItem(
      title: 'Логістика гуманітарної допомоги «Схід»',
      status: EventStatus.active,
      participantsLabel: '24 учасники',
      dateLabel: '14 листоп., 10:00 - 18:00',
      location: 'м. Київ, вул. Волонтерська, 12',
    ),
    EventItem(
      title: 'Фасування продуктових наборів',
      status: EventStatus.planned,
      participantsLabel: '12 учасників',
      dateLabel: '16 листоп., 09:00 - 15:00',
      location: 'м. Львів, Центр підтримки',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: RouteNames.dashboard,
      showHqStatus: true,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          'Створити захід',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 96),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final twoColumns = constraints.maxWidth >= 800;

            final tasks = _buildTasks();
            final events = _buildEvents();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                if (twoColumns)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 10, child: tasks),
                      const SizedBox(width: 24),
                      Expanded(flex: 7, child: events),
                    ],
                  )
                else ...[
                  tasks,
                  const SizedBox(height: 24),
                  events,
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ШТАБ ОПЕРАТИВНОГО РЕАГУВАННЯ',
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 0.8,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Головна панель',
                style: TextStyle(fontSize: 36, color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        TonalButton(label: 'Фільтр', icon: Icons.tune, onPressed: () {}),
      ],
    );
  }

  Widget _buildTasks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: 'Мої призначені завдання',
          count: _tasks.length,
          actionLabel: 'Усі завдання',
          actionIcon: Icons.arrow_forward,
          onAction: () {},
        ),
        const SizedBox(height: 16),
        for (final task in _tasks)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: TaskCard(task: task),
          ),
      ],
    );
  }

  Widget _buildEvents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: 'Найближчі заходи',
          count: _events.length,
          actionLabel: 'Календар',
          actionIcon: Icons.calendar_month_outlined,
          onAction: () {},
        ),
        const SizedBox(height: 16),
        for (final event in _events)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: EventCard(event: event, onDetails: () {}),
          ),
      ],
    );
  }
}
