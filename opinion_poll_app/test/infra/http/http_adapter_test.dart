import 'package:http/http.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class ClientSpy extends Mock implements Client {}

class HttpAdapter {
  late Client client;

  HttpAdapter(this.client);

  Future<void> request({required String url, required String method}) async {
    await client.post(Uri.parse(url));
  }
}

void main() {
  late HttpAdapter systemUnderTest;
  late ClientSpy client;
  late String url;
  late Uri uri;

  setUp(() {
    client = ClientSpy();
    systemUnderTest = HttpAdapter(client);
  });

  setUpAll(() {
    url = faker.internet.httpUrl();
    uri = Uri.parse(url);
  });

  group('post', () {
    test('Should call the POST method using the correct values.', () async {
      when(() => client.post(uri)).thenAnswer((_) async => Response('{}', 200));

      await systemUnderTest.request(url: url, method: 'post');

      verify(() => client.post(uri));
    });
  });
}
