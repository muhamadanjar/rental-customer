import 'package:customer/scope/main_model.dart';
import 'package:customer/ui/widgets/ui_elements/custom_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';

class RequestSaldoPage extends StatelessWidget {
  static String tag = 'payment';
  @override
  Widget build(BuildContext context) {
    return PaymentView();
  }
}

class PaymentView extends StatefulWidget {
  @override
  _PaymentViewState createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {


  String selectedBank = '003';
  static const menuItems = ['Pilih'];
  final nominalCtrl = TextEditingController();
  final noRekCtrl = TextEditingController();
  final formKey = new GlobalKey<FormState>();

  String page = 'konfirmasi';
  Future<File> _imageFile;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';
  bool _isUploading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text("Konfirmasi Top Up"),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: ListView(
            padding: EdgeInsets.only(left: 20),
            children: <Widget>[
              SizedBox(height: 20,),
              new Text("No Rekening: ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800),),
              TextField(
                controller: noRekCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: 'No Rekening & Atas Nama Transfer',
                    contentPadding: EdgeInsets.all(10.0)
                ),
              ),
              SizedBox(height: 20),
              new Text("Jumlah Transfer: ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800),),
              TextField(
                controller: nominalCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: 'Nominal ',
                    contentPadding: EdgeInsets.all(10.0)
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0, left: 10.0, right: 10.0),
                child: OutlineButton(
                  onPressed: () => _openImagePickerModal(context),
                  borderSide:
                  BorderSide(color: Theme.of(context).accentColor, width: 1.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.camera_alt),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text('Add Image'),
                    ],
                  ),
                ),
              ),
              tmpFile == null
                  ? Text('Please pick an image')
                  : Container(
                    child: Image.file(
                    tmpFile,
                fit: BoxFit.fill,
                height: 300.0,
                alignment: Alignment.topCenter,
                width: MediaQuery.of(context).size.width,
              ),
                  ),

              _buildUploadBtn()


            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

  }

  void _openImagePickerModal(BuildContext context) {
    final flatButtonColor = Theme.of(context).primaryColor;
    print('Image Picker Modal Called');
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Pick an image',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                FlatButton(
                  textColor: flatButtonColor,
                  child: Text('Use Camera'),
                  onPressed: () {
                    _getImage(context, ImageSource.camera);
                  },
                ),
                FlatButton(
                  textColor: flatButtonColor,
                  child: Text('Use Gallery'),
                  onPressed: () {
                    _getImage(context, ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        });
  }

  void _getImage(BuildContext context, ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source);
    setState(() {
     tmpFile = image;
    });
    // Closes the bottom sheet
    Navigator.pop(context);
  }

  Widget _buildUploadBtn() {
    Widget btnWidget = Container();
    if (_isUploading) {
      // File is being uploaded then show a progress indicator
      btnWidget = Container(
          margin: EdgeInsets.only(top: 10.0),
          child: CircularProgressIndicator());
    } else if (!_isUploading && tmpFile != null) {
      // If image is picked by the user then show a upload btn
      btnWidget = Container(
        margin: EdgeInsets.only(top: 10.0),
        child: ScopedModelDescendant<MainModel>(
          builder: (BuildContext context,Widget child,MainModel model)=>
          RaisedButton(
            child: Text('Konfirmasi Pembayaran'),
            onPressed: () {
              _uploadImage(model);
            },
            color: Colors.pinkAccent,
            textColor: Colors.white,
          ),
        ),
      );
    }
    return btnWidget;
  }

  void _uploadImage(MainModel model) async {
    FormData formdata = new FormData();
    formdata.fields.add(MapEntry("req_saldo", nominalCtrl.text));
    formdata.fields.add(MapEntry("req_norek", noRekCtrl.text));
    formdata.fields.add(MapEntry("req_bank", selectedBank));
    formdata.files.add(MapEntry("images", MultipartFile.fromFileSync(tmpFile.path,filename:'test.jpg')));
    var response = await model.uploadBukti(formdata);
    if(response['success']){
      showDialog(
        context: context,
        builder: (BuildContext context) => CustomDialog(
          title: "Success",
          description:
          "Text",
          buttonText: "Okay",
        ),
      );
    }


  }



  setStatus(String message) {
    setState(() {
      status = message;
    });
  }



  Widget showImage() {
    return FutureBuilder<File>(
      future: _imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done && null != snapshot.data) {
          tmpFile = snapshot.data;
          print(tmpFile);
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Container(
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }









}


