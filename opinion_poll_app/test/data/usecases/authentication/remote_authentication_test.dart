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

  setUp(
    () {
      httpClient = HttpClientSpy();
      url = faker.internet.httpUrl();
      systemUnderTest = RemoteAuthentication(httpClient: httpClient, url: url);
      parameters = AuthenticationParameters(
        email: faker.internet.email(),
        password: faker.internet.password(),
      );
    },
  );

  test(
    'This test is intended to verify that the query to HttpClient is being made with the correct values.',
    () async {
      when(
        () => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        ),
      ).thenAnswer(
        (_) async => {
          'accessToken': faker.guid.guid(),
          'name': faker.person.name(),
        },
      );

      await systemUnderTest.authenticate(parameters: parameters);

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

      final future = systemUnderTest.authenticate(parameters: parameters);
      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test(
    'This test is intended to verify that the unexpected error exception is being thrown when HttpClient returns an error 404.',
    () async {
      when(
        () => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        ),
      ).thenThrow(HttpError.notFound);

      final future = systemUnderTest.authenticate(parameters: parameters);
      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test(
    'This test is intended to verify that the unexpected error exception is being thrown when HttpClient returns an error 500.',
    () async {
      when(
        () => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        ),
      ).thenThrow(HttpError.internalServerError);

      final future = systemUnderTest.authenticate(parameters: parameters);
      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test(
    'This test is intended to verify that the invalid credentials error exception is being thrown when HttpClient returns an error 401.',
    () async {
      when(
        () => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        ),
      ).thenThrow(HttpError.unauthorized);

      final future = systemUnderTest.authenticate(parameters: parameters);
      expect(future, throwsA(DomainError.invalidCredentialError));
    },
  );

  test(
    'This test is intended to verify that AccountEntity is being returned when the HttpClient returns a status 200.',
    () async {
      final accessToken = faker.guid.guid();
      when(
        () => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        ),
      ).thenAnswer(
        (_) async => {
          'accessToken': accessToken,
          'name': faker.person.name(),
        },
      );

      final account =
          await systemUnderTest.authenticate(parameters: parameters);
      expect(account.accessToken, accessToken);
    },
  );

  test(
    'This test is intended to verify that the unexpected error exception is being thrown when HttpClient returns a status 200 with invalid data.',
    () async {
      when(
        () => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => {'invalid_key': 'invalid_value'});

      final future = systemUnderTest.authenticate(parameters: parameters);
      expect(future, throwsA(DomainError.unexpected));
    },
  );
}
