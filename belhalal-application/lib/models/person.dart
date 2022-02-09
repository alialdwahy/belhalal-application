class MyPerson {
  String? id;
  String? name;
  String? imagePath;
  String? token;
  MyPerson({this.id,this.name,this.imagePath="",this.token});

    MyPerson.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imagePath = json['imagePath'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['imagePath'] = imagePath??"image-path-null";
    data['token'] = token;
    return data;
  }
}