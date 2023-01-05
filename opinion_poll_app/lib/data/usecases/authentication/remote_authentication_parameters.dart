import '../../../domain/usecases/usecases.dart';

class RemoteAuthenticationParameters {
  final String email;
  final String password;

  RemoteAuthenticationParameters({
    required this.email,
    required this.password,
  });

  factory RemoteAuthenticationParameters.fromDomain(
      AuthenticationParameters parameters) =>
      RemoteAuthenticationParameters(
        email: parameters.email,
        password: parameters.password,
      );

  Map<String, String> toJson() => {'email': email, 'password': password};
}
