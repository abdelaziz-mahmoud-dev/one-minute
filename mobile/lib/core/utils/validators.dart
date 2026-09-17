import '../constants/app_constants.dart';

class Validators {
  Validators._();

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required.';
    }

    return null;
  }

  static String? name(String? value) {
    final requiredError = required(value);

    if (requiredError != null) {
      return requiredError;
    }

    if (value!.trim().length < AppConstants.minimumNameLength) {
      return 'Name is too short.';
    }

    return null;
  }

  static String? email(String? value) {
    final requiredError = required(value);

    if (requiredError != null) {
      return requiredError;
    }

    final email = value!.trim();

    final emailRegex = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address.';
    }

    return null;
  }

  static String? password(String? value) {
    final requiredError = required(value);

    if (requiredError != null) {
      return requiredError;
    }

    if (value!.length < AppConstants.minimumPasswordLength) {
      return 'Password must be at least '
          '${AppConstants.minimumPasswordLength} characters.';
    }

    return null;
  }

  static String? confirmPassword(
    String? value,
    String? password,
  ) {
    final requiredError = required(value);

    if (requiredError != null) {
      return requiredError;
    }

    if (value != password) {
      return 'Passwords do not match.';
    }

    return null;
  }
}