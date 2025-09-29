// Extension methods for common Dart types

// String extensions
extension StringExtensions on String {
  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  /// Capitalize first letter of each word
  String get titleCase {
    if (isEmpty) return this;
    return split(
      ' ',
    ).map((word) => word.isEmpty ? word : word.capitalize).join(' ');
  }

  /// Check if string is email
  bool get isEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Check if string is phone number
  bool get isPhoneNumber {
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');
    return phoneRegex.hasMatch(this);
  }

  /// Check if string is URL
  bool get isUrl {
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    return urlRegex.hasMatch(this);
  }

  /// Remove all whitespace
  String get removeWhitespace => replaceAll(RegExp(r'\s'), '');

  /// Check if string contains only letters
  bool get isAlpha => RegExp(r'^[a-zA-Z]+$').hasMatch(this);

  /// Check if string contains only numbers
  bool get isNumeric => RegExp(r'^[0-9]+$').hasMatch(this);

  /// Check if string contains only letters and numbers
  bool get isAlphaNumeric => RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);

  /// Convert to snake_case
  String get toSnakeCase {
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    ).replaceAll(RegExp(r'^_'), '');
  }

  /// Convert to camelCase
  String get toCamelCase {
    final words = split('_');
    if (words.isEmpty) return this;

    return words.first + words.skip(1).map((word) => word.capitalize).join();
  }

  /// Truncate string with ellipsis
  String truncate(int maxLength, [String suffix = '...']) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - suffix.length)}$suffix';
  }

  /// Get initials from name
  String get initials {
    final words = trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '';
    if (words.length == 1) return words.first[0].toUpperCase();
    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }

  /// Parse to double safely
  double? get toDoubleOrNull => double.tryParse(this);

  /// Parse to int safely
  int? get toIntOrNull => int.tryParse(this);

  /// Check if string is empty or only whitespace
  bool get isBlank => trim().isEmpty;

  /// Check if string is not empty and not only whitespace
  bool get isNotBlank => !isBlank;
}

// Nullable string extensions
extension NullableStringExtensions on String? {
  /// Safe null check and operation
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Safe null check and blank operation
  bool get isNullOrBlank => this == null || this!.isBlank;

  /// Get value or default
  String orEmpty() => this ?? '';

  /// Get value or custom default
  String orDefault(String defaultValue) => this ?? defaultValue;
}

// DateTime extensions
extension DateTimeExtensions on DateTime {
  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Check if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Check if date is in current week
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  /// Get time ago string
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year${difference.inDays > 730 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${difference.inDays > 60 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  /// Format date for display
  String get displayDate {
    if (isToday) return 'Today';
    if (isYesterday) return 'Yesterday';
    if (isTomorrow) return 'Tomorrow';

    return '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
  }

  /// Format time for display
  String get displayTime {
    final hour = this.hour == 0
        ? 12
        : (this.hour > 12 ? this.hour - 12 : this.hour);
    final period = this.hour < 12 ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  /// Format date and time for display
  String get displayDateTime => '$displayDate at $displayTime';

  /// Get start of day
  DateTime get startOfDay => DateTime(year, month, day);

  /// Get end of day
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Get start of week (Monday)
  DateTime get startOfWeek {
    final daysFromMonday = weekday - 1;
    return subtract(Duration(days: daysFromMonday)).startOfDay;
  }

  /// Get end of week (Sunday)
  DateTime get endOfWeek {
    final daysToSunday = 7 - weekday;
    return add(Duration(days: daysToSunday)).endOfDay;
  }
}

// List extensions
extension ListExtensions<T> on List<T> {
  /// Get element at index or null if out of bounds
  T? elementAtOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }

  /// Get first element or null if empty
  T? get firstOrNull => isEmpty ? null : first;

  /// Get last element or null if empty
  T? get lastOrNull => isEmpty ? null : last;

  /// Add element if condition is true
  void addIf(bool condition, T element) {
    if (condition) add(element);
  }

  /// Add all elements if condition is true
  void addAllIf(bool condition, Iterable<T> elements) {
    if (condition) addAll(elements);
  }

  /// Remove null elements (for nullable lists)
  List<T> get whereNotNull => where((element) => element != null).toList();

  /// Chunk list into smaller lists of specified size
  List<List<T>> chunk(int chunkSize) {
    final chunks = <List<T>>[];
    for (int i = 0; i < length; i += chunkSize) {
      chunks.add(sublist(i, (i + chunkSize > length) ? length : i + chunkSize));
    }
    return chunks;
  }
}

// Map extensions
extension MapExtensions<K, V> on Map<K, V> {
  /// Get value or null if key doesn't exist
  V? getOrNull(K key) => containsKey(key) ? this[key] : null;

  /// Get value or default if key doesn't exist
  V getOrDefault(K key, V defaultValue) => this[key] ?? defaultValue;

  /// Add entry if condition is true
  void putIf(bool condition, K key, V value) {
    if (condition) this[key] = value;
  }
}

// Double extensions
extension DoubleExtensions on double {
  /// Round to specified decimal places
  double roundToDecimals(int decimals) {
    final factor = decimals == 0 ? 1 : (10 * decimals);
    return (this * factor).round() / factor;
  }

  /// Convert to percentage string
  String toPercentage([int decimals = 1]) {
    return '${(this * 100).roundToDecimals(decimals)}%';
  }

  /// Check if number is between min and max (inclusive)
  bool isBetween(double min, double max) {
    return this >= min && this <= max;
  }

  /// Clamp value between min and max
  double clampValue(double min, double max) {
    if (this < min) return min;
    if (this > max) return max;
    return this;
  }
}

// Int extensions
extension IntExtensions on int {
  /// Convert to ordinal string (1st, 2nd, 3rd, etc.)
  String get ordinal {
    if (this >= 11 && this <= 13) return '${this}th';

    switch (this % 10) {
      case 1:
        return '${this}st';
      case 2:
        return '${this}nd';
      case 3:
        return '${this}rd';
      default:
        return '${this}th';
    }
  }

  /// Check if number is even
  bool get isEven => this % 2 == 0;

  /// Check if number is odd
  bool get isOdd => this % 2 != 0;

  /// Generate list of integers from 0 to this number
  List<int> get range => List.generate(this, (index) => index);
}
