class ChangePasswordRequest {
  final String currentPassword;
  final String password;
  final String rePassword;

  ChangePasswordRequest({
    required this.currentPassword,
    required this.password,
    required this.rePassword,
  });
}
