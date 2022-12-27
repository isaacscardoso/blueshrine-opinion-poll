import '../../domain/entities/entities.dart';

class RemoteAccountModel {
  final String accessToken;

  RemoteAccountModel({required this.accessToken});

  factory RemoteAccountModel.fromJson(Map json) =>
      RemoteAccountModel(accessToken: json['accessToken']);

  AccountEntity toAccountEntity() => AccountEntity(accessToken: accessToken);
}