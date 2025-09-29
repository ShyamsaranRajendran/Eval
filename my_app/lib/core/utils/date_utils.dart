import 'package:intl/intl.dart';
import 'extensions.dart';

/// Utility class for date and time operations
class DateUtils {
  // Private constructor to prevent instantiation
  DateUtils._();

  // Date formatters
  static final DateFormat _dayMonthYear = DateFormat('dd/MM/yyyy');
  static final DateFormat _monthDayYear = DateFormat('MM/dd/yyyy');
  static final DateFormat _yearMonthDay = DateFormat('yyyy-MM-dd');
  static final DateFormat _fullDate = DateFormat('EEEE, MMMM d, yyyy');
  static final DateFormat _shortDate = DateFormat('MMM d, yyyy');
  static final DateFormat _monthYear = DateFormat('MMMM yyyy');
  static final DateFormat _time12 = DateFormat('h:mm a');
  static final DateFormat _time24 = DateFormat('HH:mm');
  static final DateFormat _dateTime = DateFormat('dd/MM/yyyy h:mm a');
  static final DateFormat _isoDateTime = DateFormat('yyyy-MM-ddTHH:mm:ss');

  /// Format date as DD/MM/YYYY
  static String formatDayMonthYear(DateTime date) {
    return _dayMonthYear.format(date);
  }

  /// Format date as MM/DD/YYYY
  static String formatMonthDayYear(DateTime date) {
    return _monthDayYear.format(date);
  }

  /// Format date as YYYY-MM-DD
  static String formatYearMonthDay(DateTime date) {
    return _yearMonthDay.format(date);
  }

  /// Format date as "Monday, January 1, 2024"
  static String formatFullDate(DateTime date) {
    return _fullDate.format(date);
  }

  /// Format date as "Jan 1, 2024"
  static String formatShortDate(DateTime date) {
    return _shortDate.format(date);
  }

  /// Format date as "January 2024"
  static String formatMonthYear(DateTime date) {
    return _monthYear.format(date);
  }

  /// Format time in 12-hour format
  static String formatTime12(DateTime date) {
    return _time12.format(date);
  }

  /// Format time in 24-hour format
  static String formatTime24(DateTime date) {
    return _time24.format(date);
  }

  /// Format date and time
  static String formatDateTime(DateTime date) {
    return _dateTime.format(date);
  }

  /// Format for API (ISO format)
  static String formatForApi(DateTime date) {
    return _isoDateTime.format(date.toUtc());
  }

  /// Parse date from string safely
  static DateTime? parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;

    try {
      return DateTime.parse(dateString);
    } catch (e) {
      // Try different formats
      final formats = [
        DateFormat('dd/MM/yyyy'),
        DateFormat('MM/dd/yyyy'),
        DateFormat('yyyy-MM-dd'),
        DateFormat('dd-MM-yyyy'),
        DateFormat('MM-dd-yyyy'),
      ];

      for (final format in formats) {
        try {
          return format.parse(dateString);
        } catch (e) {
          continue;
        }
      }
      return null;
    }
  }

  /// Get relative time string (e.g., "2 hours ago", "in 3 days")
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.isNegative) {
      // Future date
      final futureDiff = date.difference(now);
      if (futureDiff.inDays > 0) {
        return 'in ${futureDiff.inDays} day${futureDiff.inDays > 1 ? 's' : ''}';
      } else if (futureDiff.inHours > 0) {
        return 'in ${futureDiff.inHours} hour${futureDiff.inHours > 1 ? 's' : ''}';
      } else if (futureDiff.inMinutes > 0) {
        return 'in ${futureDiff.inMinutes} minute${futureDiff.inMinutes > 1 ? 's' : ''}';
      } else {
        return 'in a moment';
      }
    } else {
      // Past date
      return date.timeAgo;
    }
  }

  /// Get smart date string (Today, Yesterday, or date)
  static String getSmartDate(DateTime date) {
    return date.displayDate;
  }

  /// Check if two dates are the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Check if date is within a range
  static bool isDateInRange(DateTime date, DateTime start, DateTime end) {
    final dateOnly = date.startOfDay;
    final startOnly = start.startOfDay;
    final endOnly = end.startOfDay;

    return (dateOnly.isAtSameMomentAs(startOnly) ||
            dateOnly.isAfter(startOnly)) &&
        (dateOnly.isAtSameMomentAs(endOnly) || dateOnly.isBefore(endOnly));
  }

  /// Get days between two dates
  static int daysBetween(DateTime start, DateTime end) {
    final startDate = start.startOfDay;
    final endDate = end.startOfDay;
    return endDate.difference(startDate).inDays;
  }

  /// Get weeks between two dates
  static int weeksBetween(DateTime start, DateTime end) {
    return (daysBetween(start, end) / 7).floor();
  }

  /// Get months between two dates
  static int monthsBetween(DateTime start, DateTime end) {
    return (end.year - start.year) * 12 + (end.month - start.month);
  }

  /// Get list of dates between two dates
  static List<DateTime> getDateRange(DateTime start, DateTime end) {
    final dates = <DateTime>[];
    DateTime current = start.startOfDay;
    final endDate = end.startOfDay;

    while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
      dates.add(current);
      current = current.add(const Duration(days: 1));
    }

    return dates;
  }

  /// Get first day of month
  static DateTime getFirstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Get last day of month
  static DateTime getLastDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  /// Get first day of week (Monday)
  static DateTime getFirstDayOfWeek(DateTime date) {
    return date.startOfWeek;
  }

  /// Get last day of week (Sunday)
  static DateTime getLastDayOfWeek(DateTime date) {
    return date.endOfWeek;
  }

  /// Add business days (excluding weekends)
  static DateTime addBusinessDays(DateTime date, int days) {
    DateTime result = date;
    int addedDays = 0;

    while (addedDays < days) {
      result = result.add(const Duration(days: 1));
      if (result.weekday <= 5) {
        // Monday = 1, Sunday = 7
        addedDays++;
      }
    }

    return result;
  }

  /// Check if date is a weekday
  static bool isWeekday(DateTime date) {
    return date.weekday <= 5;
  }

  /// Check if date is a weekend
  static bool isWeekend(DateTime date) {
    return date.weekday > 5;
  }

  /// Get age from birth date
  static int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;

    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  /// Get academic year from date
  static String getAcademicYear(DateTime date) {
    // Academic year typically starts in July/August
    if (date.month >= 7) {
      return '${date.year}-${date.year + 1}';
    } else {
      return '${date.year - 1}-${date.year}';
    }
  }

  /// Get semester from date
  static String getSemester(DateTime date) {
    // Assuming odd semester starts in July, even semester starts in January
    if (date.month >= 7) {
      return 'Odd';
    } else {
      return 'Even';
    }
  }

  /// Format duration in human readable format
  static String formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;

    final parts = <String>[];

    if (days > 0) parts.add('$days day${days > 1 ? 's' : ''}');
    if (hours > 0) parts.add('$hours hour${hours > 1 ? 's' : ''}');
    if (minutes > 0) parts.add('$minutes minute${minutes > 1 ? 's' : ''}');

    if (parts.isEmpty) return 'Less than a minute';
    if (parts.length == 1) return parts.first;
    if (parts.length == 2) return '${parts[0]} and ${parts[1]}';

    return '${parts.take(parts.length - 1).join(', ')}, and ${parts.last}';
  }

  /// Get time until deadline
  static String getTimeUntilDeadline(DateTime deadline) {
    final now = DateTime.now();
    if (deadline.isBefore(now)) {
      return 'Overdue by ${formatDuration(now.difference(deadline))}';
    } else {
      return 'Due in ${formatDuration(deadline.difference(now))}';
    }
  }

  /// Check if deadline is approaching (within 24 hours)
  static bool isDeadlineApproaching(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now);
    return difference.isNegative || difference.inHours <= 24;
  }

  /// Check if deadline is overdue
  static bool isOverdue(DateTime deadline) {
    return deadline.isBefore(DateTime.now());
  }
}
