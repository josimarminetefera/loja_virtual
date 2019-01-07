import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/carrinho_produto.dart';
import 'package:loja_virtual/datas/produto_data.dart';
import 'package:loja_virtual/models/carrinho_model.dart';

//esta tela é chamado pela carrinho screen
//nala tem o esqueleto para montar cada um dos produtos do carrinho
class CarrinhoTile extends StatelessWidget {

  //nesta tela temos que recuperar as informações do produto que está no carrinho
  final CarrinhoProduto carrinhoProduto;

  //construtor vai receber um carrinho produro
  CarrinhoTile(this.carrinhoProduto);

  @override
  Widget build(BuildContext context) {
    print("--CarrinhoTile produto: " + carrinhoProduto.idProduto);


    //quando carregar o preço do produto ele vai atualizar o valor final
    //isso aqui fica fazendo requisições infinitas
    //CarrinhoModel.of(context).atualizarPrecos();

    //montar os dados de cada uma das linhas dos produtos
    Widget _mostrarOsDados(){
      print("Inicio _mostrarOsDados de cada um dos produtos");

      return Row(
        mainAxisAlignment: MainAxisAlignment.start, //alinhar tudo no inicio
        children: <Widget>[

          //imagem do produto fica a esquerda
          Container( // imagem com uma largura fixa por isso ela fica dentro dde um container
            padding: EdgeInsets.all(8.0),
            width: 120.0,
            child: Image.network(
              carrinhoProduto.produtoDados.imagens[0], //para buscar a primeira imagem
              fit: BoxFit.cover, //para cobrir o espaço com a imagem
            ),
          ),


          //todos dados do produto
          Expanded( //expanded pois quero que cubra o resto de container que a imagem não cubriu
            child: Container(//container pois quero dar mais um espaçamento em toda a lateral
              padding: EdgeInsets.all(8.0),
              child: Column(//pois tem varios textos um embaixo do outro
                crossAxisAlignment: CrossAxisAlignment.start, //alinhar tudo a esquerda
                mainAxisAlignment: MainAxisAlignment.spaceBetween, //de um espaçamento igual na vertical
                children: <Widget>[

                  Text(
                    carrinhoProduto.produtoDados.titulo,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17.0),
                  ),

                  Text(
                    "Tamanho: ${carrinhoProduto.tamanho}",
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),

                  Text(
                    "R\$ ${carrinhoProduto.produtoDados.preco.toStringAsFixed(2)}",//dois digitos apos a virgula
                    style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),

                  //linha que contem varios botoes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly, //alinhamento de espaçamento fica igual
                    children: <Widget>[

                      //icone de menos produtos
                      IconButton(
                        icon: Icon(Icons.remove),
                        color: Theme.of(context).primaryColor,
                        //quando tem um item o sistema não permite remover o item somente se clicar no botao remover
                        onPressed: carrinhoProduto.quantidade > 1?(){
                          CarrinhoModel.of(context).removerQuantidadeProduto(carrinhoProduto);
                        }:null,
                      ),

                      //texto com a quantiodade de produto
                      Text(
                        carrinhoProduto.quantidade.toString()
                      ),

                      //icone de mais produtos
                      IconButton(
                        icon: Icon(Icons.add),
                        color: Theme.of(context).primaryColor,
                        onPressed: (){
                          CarrinhoModel.of(context).adicionarQuantidadeProduto(carrinhoProduto);
                        },
                      ),

                      //botao para remover um produto no carrinho
                      FlatButton(
                        child: Text("Remover"),
                        textColor: Colors.green[500],
                        onPressed: (){
                          CarrinhoModel.of(context).removerProdutoCarrinho(carrinhoProduto);
                        },
                      )

                    ],
                  )

                ],
              ),
            ),
          )
        ],
      );
    }


    //montando a tela inicio
    return Card(//aqui que vai conter as informações do produto
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),//margin da distancia para fora do widget e padding da distancia para dentro odo widget

      //validação
      child: carrinhoProduto.produtoDados == null ? //caso ainda não tenha cache dos dados do produto

      //caso nao tenhamos o produto dados
      FutureBuilder<DocumentSnapshot>(

        future: Firestore.instance.collection("produtos").document(carrinhoProduto.categoria).collection("itens").document(carrinhoProduto.idProduto).get(),
        builder: (context, snapshot){ // o snapshot é o dado que acabamos de receber la do banco de dados
          print("CarrinhoTile ainda não tinha o produto salvo no cache");
          if(snapshot.hasData){ //caso o snapshot contenha dado vamos armazenas
            //isso na segunda vez não precisará ser feito pois já estará guardado no produtosDados
            carrinhoProduto.produtoDados = ProdutoDados.documentoParaProdutoDados(snapshot.data);//convertendo documento para um produtodata e armazenando no carrinhoproduto
            return _mostrarOsDados();
          }else{
            //caso ainda esteja carregando
            print("CarrinhoTile dados dos produtos ainda está carregando.");
            return Container(//container pois este aqui vai ser um processando por linha de produto entao tem que especificar o tamanho
              height: 70.0,
              child: CircularProgressIndicator(),
              alignment: Alignment.center,
            );
          }
        },

      ):
      //caso tenha cahe dos produtos pois ja gerou a tela de produtos antes de jerar a tela de carrinho
      //calso ja tenha o produtos dados
      _mostrarOsDados(),
    );
  }
}
