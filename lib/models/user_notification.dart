class UserNotification {
  String message;
  int status;
  Map<String,dynamic> data;
  String jenis;
  int userId;

  UserNotification({this.message,this.status,this.data,this.jenis,this.userId});

  factory UserNotification.fromMap(Map json){
    return new UserNotification(message: json['message'],status: json['status'],data: json['data'],jenis: json['jenis'],userId: json['user_id']);
  }

}