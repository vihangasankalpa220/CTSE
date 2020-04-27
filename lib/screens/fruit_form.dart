import 'dart:io';


import 'package:finalproject/api/fruit_api.dart';
import 'package:finalproject/model/fruit.dart';
import 'package:finalproject/notifier/fruit_notifier.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FruitForm extends StatefulWidget {
  final bool isUpdating;

  FruitForm({@required this.isUpdating});

  @override
  _FruitFormState createState() => _FruitFormState();
}

class _FruitFormState extends State<FruitForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List _countries = [];
  Fruit _currentFruit;
  String _imageUrl;
  File _imageFile;
  TextEditingController countriesController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    FruitNotifier fruitNotifier = Provider.of<FruitNotifier>(context, listen: false);

    if (fruitNotifier.currentFruit != null) {
      _currentFruit = fruitNotifier.currentFruit;
    } else {
      _currentFruit = Fruit();
    }

    _countries.addAll(_currentFruit.countries);
    _imageUrl = _currentFruit.image;
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
            _imageUrl,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,
            height: 200,
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
        await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 100, maxWidth: 400);

    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  _openCamera() async {
    File imageFile =
    await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 100, maxWidth: 400);

    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }


  Widget _buildNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Fruit Name'),
      initialValue: _currentFruit.name,
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
        _currentFruit.name = value;
      },
    );
  }

  Widget _buildCategoryField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Fruit Category'),
      initialValue: _currentFruit.category,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Category is required';
        }

        if (value.length < 3 || value.length > 20) {
          return 'Category must be more than 3 and less than 20';
        }

        return null;
      },
      onSaved: (String value) {
        _currentFruit.category = value;
      },
    );
  }

  _buildCountryField() {
    return SizedBox(
      width: 200,
      child: TextField(
        controller: countriesController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(labelText: 'Available Countries'),
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  _onFruitUploaded(Fruit fruit) {
    FruitNotifier fruitNotifier = Provider.of<FruitNotifier>(context, listen: false);
    fruitNotifier.addFruit(fruit);
    Navigator.pop(context);
  }

  _addCountry(String text) {
    if (text.isNotEmpty) {
      setState(() {
        _countries.add(text);
      });
      countriesController.clear();
    }
  }

  _saveFruit() {
    print('saveFruit Called');
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    print('form saved');

    _currentFruit.countries = _countries;

    uploadFruitAndImage(_currentFruit, widget.isUpdating, _imageFile, _onFruitUploaded);

    print("name: ${_currentFruit.name}");
    print("category: ${_currentFruit.category}");
    print("Countries: ${_currentFruit.countries.toString()}");
    print("_imageFile ${_imageFile.toString()}");
    print("_imageUrl $_imageUrl");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Fruit Form')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Column(children: <Widget>[
            _showImage(),
            SizedBox(height: 16),
            Text(
              widget.isUpdating ? "Edit Fruit" : "Create Fruit",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 16),
            _imageFile == null && _imageUrl == null
                ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Column(children: <Widget>[
                      Align(alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: Icon(
                            Icons.photo_camera,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            _openCamera();
                          },),
                      ),
                    ],),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    child: IconButton(
                      icon: Icon(
                        Icons.photo_library,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        _getLocalImage();
                      },),
                  ),
                )
              ],
            )
                : SizedBox(height: 0),
            _buildNameField(),
            _buildCategoryField(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildCountryField(),
                ButtonTheme(
                  child: RaisedButton(
                    child: Text('Add', style: TextStyle(color: Colors.white)),
                    onPressed: () => _addCountry(countriesController.text),
                  ),
                )
              ],
            ),
            SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(8),
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              children: _countries
                  .map(
                    (ingredient) => Card(
                  color: Colors.black54,
                  child: Center(
                    child: Text(
                      ingredient,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              )
                  .toList(),
            )
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _saveFruit();
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),



    );
  }
}
