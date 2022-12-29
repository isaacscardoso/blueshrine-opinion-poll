import '../../domain/entities/entities.dart';

import '../http/http.dart';

class RemoteAccountModel {
  final String accessToken;

  RemoteAccountModel({required this.accessToken});

  factory RemoteAccountModel.fromJson(Map json) {
    if (json.containsKey('accessToken')) {
      return RemoteAccountModel(accessToken: json['accessToken']);
    }
    throw HttpError.badGateway;
  }

  AccountEntity toAccountEntity() => AccountEntity(accessToken: accessToken);
}
