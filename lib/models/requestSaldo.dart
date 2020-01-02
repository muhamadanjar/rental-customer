import 'package:flutter/cupertino.dart';

class RequestSaldo{
  int saldo;
  String code;
  int userId;
  String from;
  String file;
  int status;
  DateTime date;
  String noRek;
  RequestSaldo(@required this.saldo,this.code,this.userId,this.from,this.file,this.date,this.noRek);
}