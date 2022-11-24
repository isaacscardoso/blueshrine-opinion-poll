import '../entities/entities.dart';

abstract class Authentication {
  Future<AccountEntity> authenticate({
    required String email,
    required String password,
  });
}