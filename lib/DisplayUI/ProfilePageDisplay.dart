import 'dart:io';

import 'package:finalproject/LearnAFruit_Api/Fruit_Api_Handler.dart';
import 'package:finalproject/Crudmodel/UserCrudModel.dart';
import 'package:finalproject/CrudControllers/authentication_Controller.dart';
import 'package:finalproject/CrudControllers/Fruit_Controller.dart';
import 'package:finalproject/LearnAFruitproviders/LearnAFruit_provider.dart';
import 'package:finalproject/LearnAFruitUtilities/constColourAttributer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

import 'UICollectionHandler.dart';
class ProfileUI extends StatefulWidget {
  final bool isUpdating;

  ProfileUI({@required this.isUpdating});

  @override
  _ProfileUIState createState() => _ProfileUIState();
}

class _ProfileUIState extends State<ProfileUI> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  UserCrudModel _currentUser;
  String displayName;
  File _imageFile;
  String _imageUrl;

  @override
  void initState() {
    super.initState();
    FruitController fruitNotifier = Provider.of<FruitController>(context, listen: false);

    if (fruitNotifier.currentUser != null) {
      _currentUser = fruitNotifier.currentUser;
    } else {
      _currentUser = UserCrudModel();
    }


    _imageUrl = _currentUser.image;
  }

  _showImage() {
    if (_imageFile == null && _imageUrl == null) {
      return Text(" ");
    } else if (_imageFile != null) {
      print('showing image from local file');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.file(
            _imageFile,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );
    } else if (_imageUrl != null) {
      print('showing image from url');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.network(
            "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );
    }
  }

  _getLocalImage() async {
    File imageFile =
    await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50, maxWidth: 400);

    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  Widget _buildNameField() {
    AuthenticationController authNotifier = Provider.of<AuthenticationController>(context);
    return TextFormField(
      decoration: InputDecoration(labelText: 'User Name'),
      initialValue:  authNotifier.user != null ?  authNotifier.user.displayName : "Feed",
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is required';
        }

        return null;
      },
      onSaved: (String value) {
        _currentUser.displayName = value;
      },
    );
  }

  Widget _buildCategoryField() {
    AuthenticationController authNotifier = Provider.of<AuthenticationController>(context);
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email'),
      initialValue: authNotifier.user != null ?  authNotifier.user.email : "Null",
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email is required';
        }

        if (value.length < 3 || value.length > 20) {
          return 'Email must be more than 3 and less than 20';
        }

        return null;
      },
      onSaved: (String value) {
        _currentUser.email = value;
      },
    );
  }

  _onUserUploaded(UserCrudModel user) {
    FruitController fruitNotifier = Provider.of<FruitController>(context, listen: false);
    fruitNotifier.addUser(user);
    Navigator.pop(context);
  }

  _saveUser() {
    print('saveUser Called');
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    print('form saved');

    uploadUserAndImage(_currentUser, widget.isUpdating, _imageFile, _onUserUploaded);

    print("displayName: ${_currentUser.displayName}");
    print("email: ${_currentUser.email}");
    print("_imageFile ${_imageFile.toString()}");
    print("_imageUrl $_imageUrl");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_backspace,
            ),
            onPressed: ()=>  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
              return UICollectionHandler();
            })),
          ),
          title: Text('Profile')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Column(children: <Widget>[
            _showImage(),
            SizedBox(height: 16),
            Text(
              widget.isUpdating ? "Edit User" : "Create User Photo",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 16),
            _imageFile == null && _imageUrl == null
                ? ButtonTheme(
              child: RaisedButton(
                onPressed: () => _getLocalImage(),
                child: Text(
                  'Add Image',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
                : SizedBox(height: 0),
            _buildNameField(),
            _buildCategoryField(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

              ],
            ),
            SizedBox(height: 16),

            ListTile(
              title: Text(
                "Dark Mode",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),

              trailing: Switch(
                value: Provider.of<LearnAFruitProvider>(context).theme == Constants.lightTheme
                    ? false
                    : true,
                onChanged: (v) async{
                  if (v) {
                    Provider.of<LearnAFruitProvider>(context, listen: false)
                        .setTheme(Constants.darkTheme, "dark");
                  } else {
                    Provider.of<LearnAFruitProvider>(context, listen: false)
                        .setTheme(Constants.lightTheme, "light");
                  }
                },
                activeColor: Theme.of(context).accentColor,
              ),
            ),
          ]),
        ),
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _saveUser();
        },
        child: Icon(Icons.save),
        foregroundColor: Colors.white,
      ),
    );

  }
}



