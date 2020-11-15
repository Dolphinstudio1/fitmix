//import '../models/event_detail.dart';
import 'favorite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future addFavorite(String mixId, String uid) {
    Favorite fav = Favorite(null, mixId, uid);
    var result = db
        .collection('favorites')
        .add(fav.toMap())
        .then((value) => print(value))
        .catchError((error) => print(error));
    return result;
  }

  static Future<List<Favorite>> getUserFavorites(String uid) async {
    List<Favorite> favs;
    QuerySnapshot docs = await db.collection('favorites')
        .where('userId', isEqualTo: uid).get();
    if (docs != null) {
      favs = docs.docs.map((data)=> Favorite.map(data)).toList();
    }
    return favs;
  }

  static Future deleteFavorite(String favId) async {
    await db.collection('favorites').doc(favId).delete();
  }
}
