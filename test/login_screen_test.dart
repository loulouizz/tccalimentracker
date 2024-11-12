import 'package:flutter_test/flutter_test.dart';

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email é obrigatório';
  } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
    return 'Formato de e-mail inválido';
  }
  return null;
}

void main() {
  test('should accept email with "@" symbol', () {
    String? result = validateEmail('test@example.com');
    expect(result, isNull);
  });

  test('should not accept email without "@" symbol', () {
    String? result = validateEmail('invalid-email');
    expect(result, 'Formato de e-mail inválido');
  });

  test('should not accept empty email', () {
    String? result = validateEmail('');
    expect(result, 'Email é obrigatório');
  });

  test('should not accept null email', () {
    String? result = validateEmail(null);
    expect(result, 'Email é obrigatório');
  });
}
