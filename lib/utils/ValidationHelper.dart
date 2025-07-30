// lib/utils/validation_helper.dart
class ValidationHelper {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // Regex pattern for validating email addresses
    const String emailPattern =
        r"^(?!.*\.\.)[a-zA-Z0-9]+(?:[._-][a-zA-Z0-9]+)*@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$";
    final RegExp regex = RegExp(emailPattern);

    if (!regex.hasMatch(value.trim())) {
      return 'Please enter valid email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  static String? confirmValidatePassword(
    String password,
    String? confirmPassword,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    if (confirmPassword != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validateName(String? value) {
    // Check for null or only spaces
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }

    // Check for minimum length requirement
    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters long';
    }

    return null;
  }

  static String? validateGeneral(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter some text';
    }

    return null;
  }

  static String? validateage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter age text';
    }

    return null;
  }

  static String? validateStorage(String? value) {
    if (value == null || value.trim().isEmpty) {
      blank(value);
      return 'Please enter Storage(GB)';
    }

    return null;
  }

  static String? blank(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '';
    }

    return null;
  }

  static String? validateDOB(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your date of birth';
    }
    // Add more validation for the date format if needed
    return null;
  }

  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your address';
    }
    // Add more validation for address format if needed
    return null;
  }

  static String? validatePhoneindian(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter your phone number';
    }

    // Remove spaces and dashes
    final cleaned = value.replaceAll(RegExp(r'\s|-'), '');

    // Regular expression for Indian mobile numbers (starts with 6-9, 10 digits)
    final regex = RegExp(r'^[6-9]\d{9}$');

    if (!regex.hasMatch(cleaned)) {
      return 'Enter a valid 10-digit phone number';
    }

    return null; // Valid
  }


static String? validatePhoneInternational(String? value){
  if (value == null || value.trim().isEmpty) {
    return 'Enter your phone number';
  }

  // Allows +, digits, spaces, and dashes
  final regex = RegExp(r'^\+?[\d\s\-]{10,15}$');

  if (!regex.hasMatch(value.trim())) {
    return 'Enter a valid phone number';
  }

  return null;
}

}
