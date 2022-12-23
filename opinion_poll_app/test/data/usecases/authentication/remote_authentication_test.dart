import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:opinion_poll_app/data/http/http.dart';
import 'package:opinion_poll_app/data/usecases/authentication/authentication.dart';

import 'package:opinion_poll_app/domain/helpers/helpers.dart';
import 'package:opinion_poll_app/domain/usecases/usecases.dart';

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

      verify(
        () => httpClient.request(
          url: url,
          method: 'POST',
          body: {
            'email': parameters.email,
            'password': parameters.password,
          },
        ),
      );
    },
  );

  test(
    'This test is intended to verify that the unexpected error exception is being thrown when HttpClient returns an error 400.',
    () async {
      when(
        () => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        ),
      ).thenThrow(HttpError.badRequest);

      final future = systemUnderTest.authentication(parameters);
      expect(future, throwsA(DomainError.unexpected));
    },
  );
}
