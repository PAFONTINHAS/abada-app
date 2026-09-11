/// Generic form validation helpers, reusable across any edit screen.
class InfoProfileValidator {
  InfoProfileValidator._();

  static bool isValidEmail(String value) {
    return value.contains('@') && value.contains('.');
  }

  static bool isValidFullName(String value) {
    return value.trim().length >= 3;
  }

  static bool isValidPhoneNumber(String value) {
    return value.trim().length >= 8;
  }
}