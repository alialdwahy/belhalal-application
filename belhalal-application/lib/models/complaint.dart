class Complaint {
  String? userId;
  int? count;
  bool? isClosed;
  Complaint({this.userId="",this.count=0, this.isClosed=false});

  Complaint.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    count = json['count'];
    isClosed = json['isClosed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['userId'] = userId;
    data['count'] = count;
    data['isClosed'] = isClosed;
    return data;
  }
}
