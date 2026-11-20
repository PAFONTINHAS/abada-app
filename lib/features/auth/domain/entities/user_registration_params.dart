class UserRegistrationParams {

  UserRegistrationParams({

    required this.fullName,
    required this.email,
    required this.phone,
    required this.belt,
    required this.nickname,
    required this.classId,
    required this.className,
    required this.password,
    required this.professorId,
    required this.confirmPassword,
  }); 

  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;
  final String nickname;
  final String belt;
  final String professorId;
  final String classId;
  final String className;

}