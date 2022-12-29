import 'package:opinion_poll_app/domain/helpers/helpers.dart';
import 'package:opinion_poll_app/domain/usecases/usecases.dart';

import 'package:opinion_poll_app/data/http/http.dart';
import 'package:opinion_poll_app/data/usecases/authentication/authentication.dart';

import '../../mocks/mocks.dart';

import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

void main() {
  late HttpClientSpy httpClient;
  late String url;
  late RemoteAuthentication systemUnderTest;
  late AuthenticationParameters parameters;
  late Map<String, String> httpData;

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
      httpData = {
        'accessToken': faker.guid.guid(),
        'name': faker.person.name(),
      };

      httpClient.mockRequest(httpData);

      await systemUnderTest.authenticate(parameters: parameters);

      verify(
        () => httpClient.request(
          url: url,
          method: 'POST',
          body: {'email': parameters.email, 'password': parameters.password},
        ),
      );
    },
  );

  test(
    'This test is intended to verify that the unexpected error exception is being thrown when HttpClient returns an error 400.',
    () async {
      httpClient.mockRequestError(HttpError.badRequest);

      final future = systemUnderTest.authenticate(parameters: parameters);

      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test(
    'This test is intended to verify that the unexpected error exception is being thrown when HttpClient returns an error 404.',
    () async {
      httpClient.mockRequestError(HttpError.notFound);

      final future = systemUnderTest.authenticate(parameters: parameters);

      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test(
    'This test is intended to verify that the unexpected error exception is being thrown when HttpClient returns an error 500.',
    () async {
      httpClient.mockRequestError(HttpError.internalServerError);

      final future = systemUnderTest.authenticate(parameters: parameters);

      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test(
    'This test is intended to verify that the invalid credentials error exception is being thrown when HttpClient returns an error 401.',
    () async {
      httpClient.mockRequestError(HttpError.unauthorized);

      final future = systemUnderTest.authenticate(parameters: parameters);

      expect(future, throwsA(DomainError.invalidCredentialError));
    },
  );

  test(
    'This test is intended to verify that AccountEntity is being returned when the HttpClient returns a status 200.',
    () async {
      httpData = {
        'accessToken': faker.guid.guid(),
        'name': faker.person.name(),
      };

      httpClient.mockRequest(httpData);

      final account =
          await systemUnderTest.authenticate(parameters: parameters);
      expect(account.accessToken, httpData['accessToken']);
    },
  );

  test(
    'This test is intended to verify that the unexpected error exception is being thrown when HttpClient returns a status 200 with invalid data.',
    () async {
      httpData = {'invalid_key': 'invalid_value'};

      httpClient.mockRequest(httpData);

      final future = systemUnderTest.authenticate(parameters: parameters);
      expect(future, throwsA(DomainError.unexpected));
    },
  );
}
