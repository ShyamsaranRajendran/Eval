import '../constants/strings.dart';

// Form validators
class Validators {
  // Email validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.required;
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return AppStrings.invalidEmail;
    }

    return null;
  }

  // Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.required;
    }

    if (value.length < 6) {
      return AppStrings.invalidPassword;
    }

    return null;
  }

  // Confirm password validation
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return AppStrings.required;
    }

    if (value != password) {
      return AppStrings.passwordMismatch;
    }

    return null;
  }

  // Required field validation
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null ? '$fieldName is required' : AppStrings.required;
    }
    return null;
  }

  // Name validation
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.required;
    }

    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }

    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegex.hasMatch(value.trim())) {
      return 'Name can only contain letters and spaces';
    }

    return null;
  }

  // Number validation
  static String? number(String? value, {double? min, double? max}) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.required;
    }

    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }

    if (min != null && number < min) {
      return 'Value must be at least $min';
    }

    if (max != null && number > max) {
      return 'Value must not exceed $max';
    }

    return null;
  }

  // Score validation
  static String? score(String? value, double maxScore) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.required;
    }

    final score = double.tryParse(value);
    if (score == null) {
      return AppStrings.invalidScore;
    }

    if (score < 0 || score > maxScore) {
      return '${AppStrings.scoreOutOfRange} (0-$maxScore)';
    }

    return null;
  }

  // Phone number validation
  static String? phoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.required;
    }

    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  // URL validation
  static String? url(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.required;
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  // Student ID validation
  static String? studentId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.required;
    }

    // Assuming student ID format: Letters followed by numbers
    final studentIdRegex = RegExp(r'^[A-Z]{2,4}\d{4,8}$');
    if (!studentIdRegex.hasMatch(value.trim().toUpperCase())) {
      return 'Please enter a valid student ID format (e.g., CS2021001)';
    }

    return null;
  }

  // Date validation
  static String? date(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.required;
    }

    try {
      DateTime.parse(value);
      return null;
    } catch (e) {
      return 'Please enter a valid date';
    }
  }

  // Date range validation
  static String? dateRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) {
      return 'Please select both dates';
    }

    if (startDate.isAfter(endDate)) {
      return 'Start date must be before end date';
    }

    return null;
  }

  // File validation
  static String? file(String? filePath, List<String> allowedExtensions) {
    if (filePath == null || filePath.isEmpty) {
      return AppStrings.required;
    }

    final extension = filePath.toLowerCase().split('.').last;
    if (!allowedExtensions.contains('.$extension')) {
      return 'File type not allowed. Allowed types: ${allowedExtensions.join(', ')}';
    }

    return null;
  }

  // Multi-field validation
  static String? multipleFields(List<String?> values, String fieldName) {
    if (values.every((value) => value == null || value.trim().isEmpty)) {
      return 'At least one $fieldName is required';
    }
    return null;
  }
}

// Custom validator class for complex validation scenarios
class CustomValidator {
  final String? Function(String?) validator;
  final String? errorMessage;

  const CustomValidator({required this.validator, this.errorMessage});

  String? call(String? value) {
    final result = validator(value);
    return result ?? errorMessage;
  }
}

// Validator composition utilities
class ValidatorUtils {
  // Compose multiple validators
  static String? Function(String?) compose(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }

  // Conditional validator
  static String? Function(String?) conditional({
    required bool condition,
    required String? Function(String?) validator,
  }) {
    return (String? value) {
      if (condition) {
        return validator(value);
      }
      return null;
    };
  }

  // Optional validator (only validates if value is not empty)
  static String? Function(String?) optional(
    String? Function(String?) validator,
  ) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return null;
      }
      return validator(value);
    };
  }
}
