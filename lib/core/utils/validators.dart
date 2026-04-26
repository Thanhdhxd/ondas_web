abstract class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email không được để trống';
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value)) return 'Email không hợp lệ';
    if (value.length > 255) return 'Email tối đa 255 ký tự';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Mật khẩu không được để trống';
    if (value.length < 8) return 'Mật khẩu tối thiểu 8 ký tự';
    return null;
  }

  static String? required(String? value, {String fieldName = 'Trường này'}) {
    if (value == null || value.trim().isEmpty) return '$fieldName không được để trống';
    return null;
  }

  static String? maxLength(String? value, int max, {String fieldName = 'Trường này'}) {
    if (value != null && value.length > max) {
      return '$fieldName tối đa $max ký tự';
    }
    return null;
  }

  static String? displayName(String? value) {
    final requiredError = required(value, fieldName: 'Tên hiển thị');
    if (requiredError != null) return requiredError;
    return maxLength(value, 100, fieldName: 'Tên hiển thị');
  }
}
