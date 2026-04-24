class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Please enter a valid email';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Phone is required';
    if (value.length < 8) return 'Please enter a valid phone number';
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'Name is required';
    if (value.length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) return '$fieldName is required';
    return null;
  }

  static String? validateSalary(String? value) {
    if (value == null || value.isEmpty) return 'Salary is required';
    final salary = double.tryParse(value);
    if (salary == null || salary <= 0) return 'Please enter a valid salary';
    return null;
  }

  static String? validateExperience(String? value) {
    if (value == null || value.isEmpty) return 'Experience is required';
    final exp = int.tryParse(value);
    if (exp == null || exp < 0) return 'Please enter valid years';
    return null;
  }
}