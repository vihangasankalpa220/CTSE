import 'package:learn_a_fruit_flutter_app/api/fruit_api.dart';
import 'package:learn_a_fruit_flutter_app/model/fruit.dart';
import 'package:learn_a_fruit_flutter_app/notifier/fruit_notifier.dart';
import 'package:flutter/material.dart';
import 'package:learn_a_fruit_flutter_app/screens/favourite_form.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'fruit_form.dart';

class FruitDetail extends StatelessWidget {
  final bool isUpdating;
  FruitDetail({@required this.isUpdating});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List _subingredients = [];
  Fruit _currentFruit;
  String _imageUrl;
  File _imageFile;
  TextEditingController subingredientController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    FruitNotifier fruitNotifier = Provider.of<FruitNotifier>(context);

    _onFruitDeleted(Fruit fruit) {
      Navigator.pop(context);
      fruitNotifier.deleteFruit(fruit);
    }

    _onFruitUploaded(Fruit fruit) {
      FruitNotifier fruitNotifier = Provider.of<FruitNotifier>(context, listen: false);
      fruitNotifier.addFruit(fruit);
      Navigator.pop(context);
    }

    _onFavouriteFruitUploaded(Fruit fruit) {
      FruitNotifier fruitNotifier = Provider.of<FruitNotifier>(context, listen: false);
      fruitNotifier.addFruit(fruit);
      Navigator.pop(context);
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

    _buildSubingredientField() {
      return SizedBox(
        width: 200,
        child: TextField(
          controller: subingredientController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(labelText: 'Features'),
          style: TextStyle(fontSize: 20),
        ),
      );
    }





    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(fruitNotifier.currentFruit.name),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                Image.network(
                  fruitNotifier.currentFruit.image != null
                      ? fruitNotifier.currentFruit.image
                      : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(height: 24),
                Text(
                  fruitNotifier.currentFruit.name,
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
                Text(
                  'Category: ${fruitNotifier.currentFruit.category}',
                  style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 20),
                Text(
                  "Tags",
                  style: TextStyle(fontSize: 18, decoration: TextDecoration.underline),
                ),
                SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.all(8),
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  children: fruitNotifier.currentFruit.subIngredients
                      .map(
                        (ingredient) => Card(
                          color: Colors.black54,
                          child: Center(
                            child: Text(
                              ingredient,
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'button0',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return FavouriteForm(
                    isUpdating: true,
                  );
                }),
              );
            },
            child: Icon(Icons.favorite),
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
          SizedBox(height: 20),
          FloatingActionButton(
            heroTag: 'button1',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return FruitForm(
                    isUpdating: true,
                  );
                }),
              );
            },
            child: Icon(Icons.edit),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          SizedBox(height: 20),
          FloatingActionButton(
            heroTag: 'button2',
            onPressed: () => deleteFruit(fruitNotifier.currentFruit, _onFruitDeleted),
            child: Icon(Icons.delete),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
