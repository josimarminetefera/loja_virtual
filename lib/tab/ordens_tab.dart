import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/usuario_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/tiles/ordem_tile.dart';

//esta tela busca todas as ordens que o usuário logado tem
//caso usuário nao eseja logado tera que ser redirecionado para o login

class OrdensTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("--OrdensTab inicio");
    //verificar se está logado ou não
    if(UsuarioModel.of(context).estaLogado()){
      //carregar todos os pedidos do nosso usuário

      //obter o id do usuário para pegar todos os pedidos
      String idUsuario = UsuarioModel.of(context).firebaseUser.uid;

      //quando eu obtenho apenas um documento é um DocumentSnapshot
      //quando eu obtenho mais de um documento é um querysnapshot

      return FutureBuilder<QuerySnapshot>(
        //pegar todos os pedidos do usuário
        future: Firestore.instance.collection("usuarios").document(idUsuario).
        collection("ordens").getDocuments(),//isso pega todos os documentos

        builder: (context, snapshot){
          if(!snapshot.hasData){
            print("OrdensTab carregando ");
            return Center(
              child: CircularProgressIndicator(),
            );
          }else{
            //carregou todos os dados ja
            return ListView(
              children: snapshot.data.documents.map( //pego cada um dos documento do firebase e transformo em um ordertile
                (doc) => OrdemTile(doc.documentID) //cada um dos documentos eu tranformo em um order tile
              ).toList(),
            );
          }
        },
      );

    }else{
      //tela para logar
      //tenho que montar uma tela com um botão para logar
      return Container(
        padding: EdgeInsets.all(16.0),//descolar da bordas
        child: Column(//pois tera coisas encima da outra
          crossAxisAlignment: CrossAxisAlignment.stretch,//na horizontal queremos preencher  o espaço possivel
          mainAxisAlignment: MainAxisAlignment.center,//tudo fique no centro
          children: <Widget>[

            //icone do carrinho sem nada
            Icon(Icons.view_list, size: 80.0, color: Theme.of(context).primaryColor,),

            //espaço na vertical
            SizedBox(height: 16.0,),

            //texto explicativo no centro da tela
            Text("Faça o Login para Acampanhar seus Pedidos!",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            //espaço na vertical
            SizedBox(height: 16.0,),

            //botão para logar
            RaisedButton(
              child: Text("Entrar", style: TextStyle(fontSize: 18.0),),
              textColor: Colors.white, //cor do textp
              color: Theme.of(context).primaryColor,//cor do botão
              onPressed: (){
                //abrir a tela de login
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen())
                );
              },
            )

          ],
        ),
      );
    }
  }
}
