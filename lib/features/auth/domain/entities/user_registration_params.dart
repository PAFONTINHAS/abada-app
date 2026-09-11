class UserRegistrationParams {

  UserRegistrationParams({

    required this.fullName,
    required this.email,
    required this.phone,
    required this.belt,
    required this.nickname,
    required this.password,
    required this.professor,
    required this.confirmPassword,
  }); 

  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;
  final String nickname;
  final String belt;
  final String professor;

}