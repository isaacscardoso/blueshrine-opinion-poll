import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  Future<void> authentication() async {
    await httpClient.request(url: url, method: 'POST');
  }
}

abstract class HttpClient {
  Future<void>? request({
    required String url,
    required String method,
  });
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late HttpClientSpy httpClient;
  late String url;
  late RemoteAuthentication systemUnderTest;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    systemUnderTest = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test(
    'This test is intended to verify that the query to HttpClient is being made with the correct URL and correct METHOD.',
    () async {
      await systemUnderTest.authentication();
      verify(httpClient.request(url: url, method: 'POST'));
    },
  );
}
