import 'package:faker/faker.dart';

class ApiFactory {
  static Map correctBody() =>
      {'accessToken': faker.guid.guid(), 'name': faker.person.name()};

  static Map incorrectBody() => {'invalid_key': 'invalid_value'};
}
