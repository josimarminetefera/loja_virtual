import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/tiles/lojas_tile.dart';

class LojasTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("--LojasTab inicio");
    //query snapshot pois tem mais de uma loja
    return FutureBuilder<QuerySnapshot>(
      //pego todas lojas
      future: Firestore.instance.collection("lojas").getDocuments(),

      builder: (context, snapshot){
        if(!snapshot.hasData){
          //carregando
          Center(
            child: CircularProgressIndicator(),
          );
        }else{
          //ja tem dados

          return ListView(
            children:snapshot.data.documents.map(
              (doc) => LojasTile(doc)
            ).toList(),
          );
        }
      },
    );
  }
}
