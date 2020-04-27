import 'package:cloud_firestore/cloud_firestore.dart';

class FruitCrudModel {
  String id;
  String name;
  String category;
  String image;
  List countries = [];
  Timestamp createdAt;
  Timestamp updatedAt;


  FruitCrudModel();

  FruitCrudModel.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    category = data['category'];
    image = data['image'];
    countries = data['countries'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'image': image,
      'countries': countries,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }


}
