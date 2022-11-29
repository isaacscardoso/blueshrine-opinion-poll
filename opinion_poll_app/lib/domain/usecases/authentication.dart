import '../entities/entities.dart';

class AuthenticationParameters {
  final String email;
  final String password;

  AuthenticationParameters({
    required this.email,
    required this.password,
  });
}

abstract class Authentication {
  Future<AccountEntity> authenticate({
    required AuthenticationParameters parameters,
  });
}
