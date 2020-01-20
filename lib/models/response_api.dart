class ResponseApi{
  String status;
  String message;
  dynamic data;
  int code;

  ResponseApi({this.status,this.message,this.data,this.code = 200});

  factory ResponseApi.fromJson(Map<String, dynamic> json) {
    return ResponseApi(
        status: json['status'],
        message: json['message'],
        data: json['data'],
        code: json['code']
    );
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["status"] = status;
    map["message"] = message;
    map["data"] = data;
    map["code"] = code;
    return map;
  }
}