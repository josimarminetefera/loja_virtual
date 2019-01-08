import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

//esta ira receber cada uma das lojas para poder montar o conteudo do card

class LojasTile extends StatelessWidget {

  final DocumentSnapshot documentSnapshot;

  LojasTile(this.documentSnapshot);


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column( //pois uma coisa esta encima da outra
        crossAxisAlignment: CrossAxisAlignment.stretch, //imagem esticada totalmente na horizontal
        children: <Widget>[

          //imagem
          SizedBox(
            height: 100.0,
            child: Image.network(
              documentSnapshot.data["imagem"],
              fit: BoxFit.cover, //para ocupar o espaço possivel
            ),
          ),

          Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, //alinhar a coluna a esquerda
              children: <Widget>[

                Text(
                  documentSnapshot.data["titulo"],
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                Text(
                  documentSnapshot.data["endereco"],
                  textAlign: TextAlign.start,
                ),

              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,//tudo alinhado a direita
            children: <Widget>[

              FlatButton(
                child: Text("Ver no Map"),
                textColor: Colors.blue,
                padding: EdgeInsets.zero,
                onPressed: (){
                  launch("https://www.google.com/maps/search/?api=1&query=${documentSnapshot.data["lat"]},${documentSnapshot.data["long"]}");
                },
              ),

              FlatButton(
                child: Text("Ligar"),
                textColor: Colors.blue,
                padding: EdgeInsets.zero,
                onPressed: (){
                  launch("tel:${documentSnapshot.data["telefone"]}");
                },
              )

            ],
          )

        ],
      ),
    );
  }
}
