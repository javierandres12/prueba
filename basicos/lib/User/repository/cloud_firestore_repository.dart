import 'package:basicos/Place/model/place.dart';
import 'package:basicos/Place/ui/widgets/card_image.dart';
import 'package:basicos/User/model/user.dart';
import 'package:basicos/User/repository/cloud_firestore_api.dart';
import 'package:basicos/User/ui/widgets/profile_place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFirestoreRepository {

  final _cloudFirestoreAPI = CloudFirestoreAPI();

  void updateUserDataRepository(User user) =>
      _cloudFirestoreAPI.updateUserData(user);

  Future<void> updatePlaceData(Place place) =>
      _cloudFirestoreAPI.updatePlaceData(place);

  Future likePlace(Place place, String uid) =>
      _cloudFirestoreAPI.likePlace(place,uid);

  List<ProfilePlace> buildMyPlaces(List<DocumentSnapshot> placesListSnapshot) =>
      _cloudFirestoreAPI.buildMyPlaces(placesListSnapshot);

  List<Place> buildPlaces(List<DocumentSnapshot> placesListSnapshot, User user) =>
      _cloudFirestoreAPI.buildPlaces(placesListSnapshot, user);
}