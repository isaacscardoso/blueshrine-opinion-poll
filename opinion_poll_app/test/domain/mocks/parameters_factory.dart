import 'package:opinion_poll_app/domain/usecases/usecases.dart';

import 'package:faker/faker.dart';

class ParametersFactory {
  static AuthenticationParameters authentication() => AuthenticationParameters(
      email: faker.internet.email(), password: faker.internet.password());
}
