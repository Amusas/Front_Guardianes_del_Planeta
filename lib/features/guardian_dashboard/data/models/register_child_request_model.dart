class RegisterChildRequestModel {
  final String username;
  final String password;
  final String name;
  final DateTime dateOfBirth;

  const RegisterChildRequestModel({
    required this.username,
    required this.password,
    required this.name,
    required this.dateOfBirth,
  });

  Map<String, dynamic> toJson() {
    final year = dateOfBirth.year.toString().padLeft(4, '0');
    final month = dateOfBirth.month.toString().padLeft(2, '0');
    final day = dateOfBirth.day.toString().padLeft(2, '0');
    return {
      'username': username.trim(),
      'password': password,
      'name': name.trim(),
      'dateOfBirth': '$year-$month-$day',
    };
  }
}
