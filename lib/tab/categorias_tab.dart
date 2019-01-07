import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/tiles/categorias_tile.dart';

//primeira tela carregada quando clico no menu lateral
//esta tela chama o tile que vai montar a linha de cada categoria oferecido
//chamada pela home
class CategoriasTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("--CategoriasTab inicio montagem linha de categorias");
    return FutureBuilder<QuerySnapshot>( //porque estes dados vem do firebase e são assincronos
      future: Firestore.instance.collection("produtos").getDocuments(),//obtendo todas categorias
      builder: (context,snapshot){

        if(!snapshot.hasData){
          //fazer algo para ficar aguardando
          print("CategoriasTab processando dados para a lista");
          return Center(
            child: CircularProgressIndicator(),
          );
        }else{
          print("CategoriasTab montando lista ListTile.divideTiles e passando dentro cada um dos categoriastile");
          //colocar divisão entre os itens
          var dividedTiles = ListTile.divideTiles( //pedindo para dividir as tiles
            tiles: snapshot.data.documents.map(//pega cada documento
                (doc){//funcao anonima para pegar cada documento
                  return CategoriasTile(doc);//passa o documento para ser montado na classe de cat tile
                }
            ).toList(),//transforma em lista
            color: Colors.green[500] //cor para o divisor
          ).toList();//converte tudo para um list

          //carregar os dados de categorias em uma lista
          return ListView(
            children: dividedTiles
          );
        }
      },
    );
  }
}
