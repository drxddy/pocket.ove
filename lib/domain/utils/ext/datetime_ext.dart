extension DateTimeExt on DateTime {
  String get formattedDate {
    return "${this.day.toString().padLeft(2, '0')}/${this.month.toString().padLeft(2, '0')}/${this.year}";
  }

  String get formattedTime {
    return "${this.hour.toString().padLeft(2, '0')}:${this.minute.toString().padLeft(2, '0')}";
  }

  bool get isToday {
    final now = DateTime.now();
    return this.year == now.year && this.month == now.month && this.day == now.day;
  }

  bool isSameDay(DateTime other) {
    return this.year == other.year && this.month == other.month && this.day == other.day;
  }
}