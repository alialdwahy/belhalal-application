enum Subtype {
  bronzeSubscription,
  silverSubscription,
  goldSubscription,
  nonSubscription
}

class MyUser {
  String? id;
  int? idOrder;
  String? name;
  String? email;
  int? age;
  String? password;
  String? gendervalue;
  String? socialStatusValue;
  String? country;
  String? marriedTypeValue;
  String? skinColor;
  String? annualIncomeValue;
  String? job;
  String? weight;
  String? long;
  String? imageUrl;
  Subtype? subtype;
  bool? acceptPolicy;
  String? token;

  MyUser({
    this.id = "",
    this.idOrder = 0,
    this.name = "",
    this.email = "",
    this.age = 0,
    this.password = "",
    this.acceptPolicy = false,
    this.gendervalue,
    this.socialStatusValue,
    this.country,
    this.marriedTypeValue,
    this.skinColor,
    this.annualIncomeValue,
    this.job,
    this.weight,
    this.long,
    this.imageUrl = "",
    this.subtype = Subtype.nonSubscription,
    this.token = "",
  });

  MyUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idOrder = json['idOrder'];
    name = json['name'];
    email = json['email'];
    age = json['age'];
    password = json['password'];
    acceptPolicy = json['acceptPolicy'];
    gendervalue = json['gendervalue'];
    socialStatusValue = json['socialStatusValue'];
    country = json['country'];
    marriedTypeValue = json['marriedTypeValue'];
    skinColor = json['skinColor'];
    annualIncomeValue = json['annualIncomeValue'];
    job = json['job'];
    weight = json['weight'];
    long = json['long'];
    imageUrl = json['imageUrl'];
    subtype = json['subtype'] == Subtype.goldSubscription.toString()
        ? Subtype.goldSubscription
        : json['subtype'] == Subtype.silverSubscription.toString()
            ? Subtype.silverSubscription
            : json['subtype'] == Subtype.bronzeSubscription.toString()
                ? Subtype.bronzeSubscription
                : Subtype.nonSubscription;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['idOrder'] = idOrder;
    data['name'] = name;
    data['email'] = email;
    data['age'] = age;
    data['acceptPolicy'] = acceptPolicy;
    data['gendervalue'] = gendervalue;
    data['socialStatusValue'] = socialStatusValue;
    data['country'] = country;
    data['marriedTypeValue'] = marriedTypeValue;
    data['skinColor'] = skinColor;
    data['annualIncomeValue'] = annualIncomeValue;
    data['job'] = job;
    data['weight'] = weight;
    data['long'] = long;
    data['imageUrl'] = imageUrl;
    data['subtype'] = subtype.toString();
    data['token'] = token;
    return data;
  }
}
