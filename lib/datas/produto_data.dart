//classe apenas para armazenar dados

import 'package:cloud_firestore/cloud_firestore.dart';

class ProdutoDados{

  //qual caregoria ele pertense
  String categoria;
  String id;
  String titulo;
  String descricao;
  double preco;
  List imagens;
  List tamanho;

  //tem que passar o documento que armazena estes dados
  ProdutoDados.documentoParaProdutoDados(DocumentSnapshot documentSnapShot){// este é o documento da base de dados
    print("ProdutoDados documentoParaCarrinhoProduto");
    id = documentSnapShot.documentID;
    titulo = documentSnapShot.data["titulo"];
    descricao = documentSnapShot.data["descricao"];
    preco = documentSnapShot.data["preco"];
    imagens = documentSnapShot.data["imagens"];
    tamanho = documentSnapShot.data["tamanho"];
  }

  Map<String, dynamic> resumoMap(){
    print("CarrinhoProduto resumoMap");
    return {
      "titulo": titulo,
      "descricao": descricao,
      "preco":preco
    };
  }

}