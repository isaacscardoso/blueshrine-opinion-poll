import '../entities/entities.dart';
import './usecases.dart';

abstract class Authentication {
  Future<AccountEntity> authenticate({
    required AuthenticationParameters parameters,
  });
}
