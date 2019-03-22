import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  searchByName(String searchField) async {
    print("valor " + searchField);
    print("valor " + searchField.substring(0, 1).toLowerCase());
    return await Firestore.instance
        .collection('usuarios')
        .where(
          'nome_app',
          isEqualTo: searchField.substring(0, 1).toLowerCase(),
        )
        .getDocuments();
  }
}
