import 'dart:convert';

import 'package:http/http.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:opinion_poll_app/infrastructure/http/http.dart';
import 'package:opinion_poll_app/data/http/http.dart';

class ClientSpy extends Mock implements Client {
  When _mockRequestCall() => when(() => this
      .post(any(), headers: any(named: 'headers'), body: any(named: 'body')));

  void mockRequest({required String body, required int statusCode}) =>
      _mockRequestCall().thenAnswer((_) async => Response(body, statusCode));
}

void main() {
  late HttpAdapter systemUnderTest;
  late ClientSpy client;
  late String url;
  late Uri uri;
  late Map<String, String> headers;
  late Map? body;
  late String? bodyEncoded;

  setUp(() {
    client = ClientSpy();
    systemUnderTest = HttpAdapter(client);
    headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    body = {'any_key': 'any_value'};
    bodyEncoded = jsonEncode(body);
  });

  setUpAll(() {
    url = faker.internet.httpUrl();
    uri = Uri.parse(url);
    registerFallbackValue(uri);
  });

  group('shared', () {
    test('Should return Server Error if Http method is invalid.', () async {
      client.mockRequest(body: bodyEncoded!, statusCode: 200);

      final future = systemUnderTest.request(url: url, method: '?');

      expect(future, throwsA(HttpError.internalServerError));
    });
  });

  group('post', () {
    setUp(() {
      client.mockRequest(body: '{}', statusCode: 200);
    });

    test('Should call the method using the correct values.', () async {
      await systemUnderTest.request(url: url, method: 'post', body: body);

      verify(() => client.post(uri, headers: headers, body: bodyEncoded));
    });

    test('Should call the method without body', () async {
      await systemUnderTest.request(url: url, method: 'post');

      verify(() => client.post(any(), headers: any(named: 'headers')));
    });

    test('Should return data if the method returns status 200', () async {
      client.mockRequest(body: bodyEncoded!, statusCode: 200);

      final response = await systemUnderTest.request(url: url, method: 'post');

      expect(response, body);
    });

    test('Should return null if method returns 200 without data.', () async {
      client.mockRequest(body: '', statusCode: 200);

      final response = await systemUnderTest.request(url: url, method: 'post');

      expect(response, null);
    });

    test('Should return null if method returns 204 without data.', () async {
      client.mockRequest(body: '', statusCode: 204);

      final response = await systemUnderTest.request(url: url, method: 'post');

      expect(response, null);
    });

    test('Should return null if method returns status 204 with data', () async {
      client.mockRequest(body: bodyEncoded!, statusCode: 204);

      final response = await systemUnderTest.request(url: url, method: 'post');

      expect(response, null);
    });

    test('Should return BadRequest if method returns status 400', () async {
      client.mockRequest(body: bodyEncoded!, statusCode: 400);

      final future = systemUnderTest.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return Unauthorized if method returns status 401', () async {
      client.mockRequest(body: bodyEncoded!, statusCode: 401);

      final future = systemUnderTest.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should return Forbidden if method returns status 403', () async {
      client.mockRequest(body: bodyEncoded!, statusCode: 403);

      final future = systemUnderTest.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.forbidden));
    });

    test('Should return Not Found if method returns status 404', () async {
      client.mockRequest(body: bodyEncoded!, statusCode: 404);

      final future = systemUnderTest.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.notFound));
    });

    test('Should return Server Error if method returns status 500', () async {
      client.mockRequest(body: bodyEncoded!, statusCode: 500);

      final future = systemUnderTest.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.internalServerError));
    });

    test('Should return Server Error if method returns not listed', () async {
      client.mockRequest(body: bodyEncoded!, statusCode: 100);

      final future = systemUnderTest.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.internalServerError));
    });
  });
}
