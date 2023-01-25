import 'dart:convert';

import 'package:http/http.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class ClientSpy extends Mock implements Client {
  When _mockRequestCall() => when(() => this
      .post(any(), headers: any(named: 'headers'), body: any(named: 'body')));

  void mockRequest(Response data) =>
      _mockRequestCall().thenAnswer((_) async => data);
}

class HttpAdapter {
  late Client client;

  HttpAdapter(this.client);

  Future<void> request({
    required String url,
    required String method,
    Map? body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };

    final bodyEncoded = jsonEncode(jsonEncode(body));

    await client.post(Uri.parse(url), headers: headers, body: bodyEncoded);
  }
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
    bodyEncoded = jsonEncode(jsonEncode(body));
  });

  setUpAll(() {
    url = faker.internet.httpUrl();
    uri = Uri.parse(url);
    registerFallbackValue(uri);
  });

  group('post', () {
    test('Should call the POST method using the correct values.', () async {
      client.mockRequest(Response('{}', 200));

      await systemUnderTest.request(url: url, method: 'post', body: body);

      verify(() => client.post(uri, headers: headers, body: bodyEncoded));
    });
  });
}
