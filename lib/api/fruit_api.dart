import 'dart:io';
import 'package:learn_a_fruit_flutter_app/model/fruit.dart';
import 'package:learn_a_fruit_flutter_app/model/user.dart';
import 'package:learn_a_fruit_flutter_app/notifier/auth_notifier.dart';
import 'package:learn_a_fruit_flutter_app/notifier/fruit_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';


login(User user, AuthNotifier authNotifier) async {
  AuthResult authResult = await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: user.email, password: user.password)
      .catchError((error) => print(error.code));

  if (authResult != null) {
    FirebaseUser firebaseUser = authResult.user;

    if (firebaseUser != null) {
      print("Log In: $firebaseUser");
      authNotifier.setUser(firebaseUser);
    }
  }
}

signup(User user, AuthNotifier authNotifier) async {
  AuthResult authResult = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: user.email, password: user.password)
      .catchError((error) => print(error.code));

  if (authResult != null) {
    UserUpdateInfo updateInfo = UserUpdateInfo();
    updateInfo.displayName = user.displayName;

    FirebaseUser firebaseUser = authResult.user;

    if (firebaseUser != null) {
      await firebaseUser.updateProfile(updateInfo);

      await firebaseUser.reload();

      print("Sign up: $firebaseUser");

      FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
      authNotifier.setUser(currentUser);
    }
  }
}

signout(AuthNotifier authNotifier) async {
  await FirebaseAuth.instance.signOut().catchError((error) => print(error.code));

  authNotifier.setUser(null);
}

initializeCurrentUser(AuthNotifier authNotifier) async {
  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

  if (firebaseUser != null) {
    print(firebaseUser);
    authNotifier.setUser(firebaseUser);
  }
}

getFruits(FruitNotifier fruitNotifier) async {
  QuerySnapshot snapshot = await Firestore.instance
      .collection('Fruits')
      .orderBy("createdAt", descending: true)
      .getDocuments();

  List<Fruit> _fruitList = [];

  snapshot.documents.forEach((document) {
    Fruit fruit = Fruit.fromMap(document.data);
    _fruitList.add(fruit);
  });

  fruitNotifier.fruitList = _fruitList;
}

uploadFruitAndImage(Fruit fruit, bool isUpdating, File localFile, Function fruitUploaded) async {
  if (localFile != null) {
    print("uploading image");

    var fileExtension = path.extension(localFile.path);
    print(fileExtension);

    var uuid = Uuid().v4();

    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('fruits/images/$uuid$fileExtension');

    await firebaseStorageRef.putFile(localFile).onComplete.catchError((onError) {
      print(onError);
      return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();
    print("download url: $url");
    _uploadFruit(fruit, isUpdating, fruitUploaded, imageUrl: url);
  } else {
    print('...skipping image upload');
    _uploadFruit(fruit, isUpdating, fruitUploaded);
  }
}

_uploadFruit(Fruit fruit, bool isUpdating, Function fruitUploaded, {String imageUrl}) async {
  CollectionReference fruitRef = Firestore.instance.collection('Fruits');

  if (imageUrl != null) {
    fruit.image = imageUrl;
  }

  if (isUpdating) {
    fruit.updatedAt = Timestamp.now();

    await fruitRef.document(fruit.id).updateData(fruit.toMap());

    fruitUploaded(fruit);
    print('updated fruit with id: ${fruit.id}');
  } else {
    fruit.createdAt = Timestamp.now();

    DocumentReference documentRef = await fruitRef.add(fruit.toMap());

    fruit.id = documentRef.documentID;

    print('uploaded fruit successfully: ${fruit.toString()}');

    await documentRef.setData(fruit.toMap(), merge: true);

    fruitUploaded(fruit);
  }
}

deleteFruit(Fruit fruit, Function fruitDeleted) async {
  if (fruit.image != null) {
    StorageReference storageReference =
        await FirebaseStorage.instance.getReferenceFromUrl(fruit.image);

    print(storageReference.path);

    await storageReference.delete();

    print('image deleted');
  }

  await Firestore.instance.collection('Fruits').document(fruit.id).delete();
  fruitDeleted(fruit);
}


uploadUserAndImage(User user, bool isUpdating, File localFile, Function userUploaded) async {
  if (localFile != null) {
    print("uploading image");

    var fileExtension = path.extension(localFile.path);
    print(fileExtension);

    var uuid = Uuid().v4();

    final StorageReference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('users/images/$uuid$fileExtension');

    await firebaseStorageRef.putFile(localFile).onComplete.catchError((onError) {
      print(onError);
      return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();
    print("download url: $url");
    _uploadUser(user, isUpdating, userUploaded, imageUrl: url);
  } else {
    print('...skipping image upload');
    _uploadUser(user, isUpdating, userUploaded);
  }
}

_uploadUser(User user, bool isUpdating, Function userUploaded, {String imageUrl}) async {
  CollectionReference userRef = Firestore.instance.collection('Users');

  if (imageUrl != null) {
    user.image = imageUrl;
  }

  if (isUpdating) {
    user.updatedAt = Timestamp.now();

    await userRef.document(user.email).updateData(user.toMap());

    userUploaded(user);
    print('updated fruit with id: ${user.email}');
  } else {
    user.createdAt = Timestamp.now();

    DocumentReference documentRef = await userRef.add(user.toMap());

    user.email = documentRef.documentID;

    print('uploaded user successfully: ${user.toString()}');

    await documentRef.setData(user.toMap(), merge: true);

    userUploaded(user);
  }
}
