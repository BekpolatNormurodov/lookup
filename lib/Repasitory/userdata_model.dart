class UserDataModel {
  int? id;
  int? telegramId;
  String? phone;
  String? firstName;
  String? lastName;
  String? username;
  String? createdAt;

  UserDataModel(
      {this.id,
      this.telegramId,
      this.phone,
      this.firstName,
      this.lastName,
      this.username,
      this.createdAt});

  UserDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    telegramId = json['telegram_id'];
    phone = json['phone'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    username = json['username'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['telegram_id'] = telegramId;
    data['phone'] = phone;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['username'] = username;
    data['created_at'] = createdAt;
    return data;
  }
}
