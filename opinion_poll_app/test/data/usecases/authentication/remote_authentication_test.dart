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
    await httpClient.request(url: url);
  }
}

abstract class HttpClient {
  Future<void>? request({required String url});
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  test(
    'This test is intended to verify that the query to HttpClient is being made with the correct URL.',
    () async {
      final httpClient = HttpClientSpy();
      final url = faker.internet.httpUrl();
      final systemUnderTest =
          RemoteAuthentication(httpClient: httpClient, url: url);

      await systemUnderTest.authentication();

      verify(httpClient.request(url: url));
    },
  );
}
