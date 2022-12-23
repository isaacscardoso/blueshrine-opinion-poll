import '../../../domain/usecases/usecases.dart';
import '../../../domain/helpers/helpers.dart';

import '../../http/http.dart';

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

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  Future<void> authentication(AuthenticationParameters parameters) async {
    final body = RemoteAuthenticationParameters.fromDomain(parameters).toJson();
    try {
      await httpClient.request(url: url, method: 'POST', body: body);
    } on HttpError {
      throw DomainError.unexpected;
    }
  }
}
