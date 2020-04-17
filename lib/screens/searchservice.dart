import 'package:cloud_firestore/cloud_firestore.dart';



class SearchService {
  searchByName(String searchField) {
return Firestore.instance.collection('Fruits').where('id',isEqualTo: searchField.substring(0,1).toLowerCase()).getDocuments();
  }

}