import 'package:encrypt/encrypt.dart' as encrypt;

class UserDataModel {
  int? id;
  int? telegramId;
  String? phoneEncrypted;
  String? firstName;
  String? lastName;
  String? username;
  String? createdAt;

  UserDataModel({
    this.id,
    this.telegramId,
    this.phoneEncrypted,
    this.firstName,
    this.lastName,
    this.username,
    this.createdAt,
  });

  // FERNET kalit (python tarafdagi FERNET_KEY)
  static final String fernetKey = 'YpS0G0c8QJ8xXxXf0qEN2e_YWa2KukxZ9fWrl7QoUgY=';

  // Decrypt qilingan telefon raqami
  String get phone {
    try {
      final key = encrypt.Key.fromBase64(fernetKey);
      final encrypter = encrypt.Encrypter(encrypt.Fernet(key));
      final decrypted = encrypter.decrypt64(phoneEncrypted!);
      return decrypted;
    } catch (e) {
      return '[Xatolik decryptda]';
    }
  }

  UserDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    telegramId = json['telegram_id'];
    phoneEncrypted = json['phone']; // Shifrlangan holda keladi
    firstName = json['first_name'];
    lastName = json['last_name'];
    username = json['username'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['telegram_id'] = telegramId;
    data['phone'] = phoneEncrypted;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['username'] = username;
    data['created_at'] = createdAt;
    return data;
  }
}
