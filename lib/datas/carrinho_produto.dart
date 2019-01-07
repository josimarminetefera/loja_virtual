import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/datas/produto_data.dart';

//esta class representa cada um dos produtos do carrinho

class CarrinhoProduto{
  String id;
  String idProduto;

  //preciso saber qual a categoria que esta este item
  String categoria;

  int quantidade;
  String tamanho;

  //dados dos produtos do carrinho
  ProdutoDados produtoDados;

  //construtor vazio
  CarrinhoProduto();

  //construtor para pegar um documento e transformar em um CarrinhoProduto
  CarrinhoProduto.documentoParaCarrinhoProduto(DocumentSnapshot documentSnapshot){
    print("CarrinhoProduto documentoParaCarrinhoProduto");
    //documentSnapshot representa um dos produtos que faz parte do carrinho
    //ele vai receber todos e transformar cada um deles em um carrinhoProduto
    id  = documentSnapshot.documentID;
    categoria = documentSnapshot.data["categoria"];
    idProduto = documentSnapshot.data["idProduto"];
    quantidade = documentSnapshot.data["quantidade"];
    tamanho = documentSnapshot.data["tamanho"];
  }

  //para adicionar um carrinho no banco de dados
  Map<String, dynamic> paraMap(){
    print("CarrinhoProduto paraMap");
    return {
      "categoria": categoria,
      "idProduto":idProduto,
      "id":id,
      "tamanho":tamanho,
      "quantidade":quantidade,
//      "produto": produtosDados.resumoMap()
    };
  }

}