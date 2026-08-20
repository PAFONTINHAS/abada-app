// FUNÇÃO QUE VERIFICA SE O EMAIL ESTÁ DENTRO DOS PADRÕES DO REGEX (REGULAR EXPRESSION)
bool isValidEmail(String email) {
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  return emailRegex.hasMatch(email);
}


// FUNÇÃO QUE FAZ A VERIFICAÇÃO DE SEGURANÇA DA SENHA
bool isStrongPassword(String password) {
  // DEFINE OS CRITÉRIOS DE SENHA FORTE
  const minLength = 8;
  final hasDigits = RegExp(r'\d').hasMatch(password);
  final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
  final hasLowercase = RegExp(r'[a-z]').hasMatch(password);
  final hasSpecialCharacters = RegExp(
    r'[!@#$%^&*(),.?":{}|<>]',
  ).hasMatch(password);

  //  VERIFICA SE A SENHA CUMPRE TODOS OS CRITÉRIOS
  return password.length >= minLength &&
      hasUppercase &&
      hasLowercase &&
      hasDigits &&
      hasSpecialCharacters;
}



