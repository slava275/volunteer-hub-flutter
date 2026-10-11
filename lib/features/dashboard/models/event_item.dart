enum EventStatus { active, planned }

class EventItem {
  const EventItem({
    required this.title,
    required this.status,
    required this.participantsLabel,
    required this.dateLabel,
    required this.location,
  });

  final String title;
  final EventStatus status;
  final String participantsLabel;
  final String dateLabel;
  final String location;
}
