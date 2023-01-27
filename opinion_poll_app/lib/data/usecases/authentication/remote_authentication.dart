import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

import '../../http/http.dart';
import '../../models/models.dart';

import './authentication.dart';

class RemoteAuthentication implements Authentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  @override
  Future<AccountEntity> authenticate(
      {required AuthenticationParameters parameters}) async {
    final body = RemoteAuthenticationParameters.fromDomain(parameters).toJson();
    try {
      final dynamic httpResponse = await httpClient.request(
        url: url,
        method: 'POST',
        body: body,
      );
      return RemoteAccountModel.fromJson(httpResponse).toAccountEntity();
    } on HttpError catch (error) {
      throw error == HttpError.unauthorized
          ? DomainError.invalidCredentialError
          : DomainError.unexpected;
    }
  }
}
