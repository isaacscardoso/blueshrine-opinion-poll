import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:opinion_poll_app/domain/usecases/usecases.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  Future<void> authentication(AuthenticationParameters parameters) async {
    final body = {'email': parameters.email, 'password': parameters.password};
    await httpClient.request(url: url, method: 'POST', body: body);
  }
}

abstract class HttpClient {
  Future<void>? request({
    required String url,
    required String method,
    Map<String, String> body,
  });
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late HttpClientSpy httpClient;
  late String url;
  late RemoteAuthentication systemUnderTest;
  late AuthenticationParameters parameters;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    systemUnderTest = RemoteAuthentication(httpClient: httpClient, url: url);
    parameters = AuthenticationParameters(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );
  });

  test(
    'This test is intended to verify that the query to HttpClient is being made with the correct values.',
    () async {
      await systemUnderTest.authentication(parameters);

      verify(httpClient.request(
        url: url,
        method: 'POST',
        body: {
          'email': parameters.email,
          'password': parameters.password,
        },
      ));
    },
  );
}
