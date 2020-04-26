import 'dart:io';

import 'package:finalproject/model/user.dart';
import 'package:finalproject/notifier/auth_notifier.dart';
import 'package:finalproject/notifier/fruit_notifier.dart';
import 'package:finalproject/providers/app_provider.dart';
import 'package:finalproject/util/const.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

import 'main_screen.dart';
class Profile extends StatefulWidget {
  final bool isUpdating;

  Profile({@required this.isUpdating});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  User _currentUser;
  String displayName;
  File _imageFile;
  String _imageUrl;

  @override
  void initState() {
    super.initState();
    FruitNotifier fruitNotifier = Provider.of<FruitNotifier>(context, listen: false);

    if (fruitNotifier.currentUser != null) {
      _currentUser = fruitNotifier.currentUser;
    } else {
      _currentUser = User();
    }


    _imageUrl = _currentUser.image;
  }

  _showImage() {
    if (_imageFile == null && _imageUrl == null) {
      return Text("image placeholder");
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
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    return TextFormField(
      decoration: InputDecoration(labelText: 'User Name'),
      initialValue:  authNotifier.user != null ?  authNotifier.user.displayName : "Feed",
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is required';
        }

        if (value.length < 3 || value.length > 20) {
          return 'Name must be more than 3 and less than 20';
        }

        return null;
      },
      onSaved: (String value) {
        _currentUser.displayName = value;
      },
    );
  }

  Widget _buildCategoryField() {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
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





  _onUserUploaded(User user) {
    FruitNotifier fruitNotifier = Provider.of<FruitNotifier>(context, listen: false);
    fruitNotifier.addUser(user);
    Navigator.pop(context);
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
              return MainScreen();
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
                value: Provider.of<AppProvider>(context).theme == Constants.lightTheme
                    ? false
                    : true,
                onChanged: (v) async{
                  if (v) {
                    Provider.of<AppProvider>(context, listen: false)
                        .setTheme(Constants.darkTheme, "dark");
                  } else {
                    Provider.of<AppProvider>(context, listen: false)
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
          //   _saveUser();
        },
        child: Icon(Icons.save),
        foregroundColor: Colors.white,
      ),



    );

  }
}

