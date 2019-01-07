import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/categorias_screen.dart';

//esta tela monta a linha de cada categoria da lista
//construcao da tela de cada linha da lista
//clicando em um item da lista sera direcionada para uma nova tela de categoria sceen que contem a tela onde mostra todos produtos de uma categoria.
//chamada pela tab
class CategoriasTile extends StatelessWidget {

  //dados dos documentos do banco
  final DocumentSnapshot documentSnapshot;

  //vai receber a lista de documentos do banco de dados
  //construtor com o documento da categoria
  CategoriasTile(this.documentSnapshot);

  @override
  Widget build(BuildContext context) {
    print("CategoriasTile inicio montando cada uma das linhas da lista com imagem e descrição");
    return ListTile(

      leading: CircleAvatar(//icone da esquerda
        radius: 25.0,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(documentSnapshot.data["icone"]),//imagem vinda da internet
      ),

      title: Text(documentSnapshot.data["titulo"]), //titulo da linha

      //setinha no final
      trailing: Icon(Icons.keyboard_arrow_right),

      onTap: (){
        //sempre que eu clicar na categoria vou executar algo
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CategoriasScreen(documentSnapshot)//este é o documento da base de dados
          )
        );
      },

    );
  }
}
