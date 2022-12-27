class AccountEntity {
  final String accessToken;

  AccountEntity({required this.accessToken});

  factory AccountEntity.fromJson(Map json) =>
      AccountEntity(accessToken: json['accessToken']);
}