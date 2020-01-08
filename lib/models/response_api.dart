class ResponseApi{
  String status;
  String message;
  Map data;

  ResponseApi({this.status,this.message,this.data});

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["status"] = status;
    map["message"] = message;
    map["data"] = data;
    return map;
  }
}