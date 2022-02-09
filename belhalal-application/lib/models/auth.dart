class AthUser {
  String? email;
  String? password;
  AthUser({this.email, this.password});

  AthUser.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}
