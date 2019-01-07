import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/produto_data.dart';
import 'package:loja_virtual/screens/produto_screen.dart';

//essa classe monta o esqueleto de cada produto com imagem titulo e preço
// se clicar em um produto vai para o produto screen passando um produto clicado
//chamada pela categorias screen
class ProdutosTile extends StatelessWidget {

  final String tipo;
  final ProdutoDados produtoDados;

  //construtor que recebe cada documento da lista de produtos
  ProdutosTile(this.tipo, this.produtoDados);

  @override
  Widget build(BuildContext context) {

    print("--ProdutoTIle inicio montagem do esqueleto de cada um dos produtos na lista de produtos. ");

    return InkWell( //inkwell serve para ativar o toque ele parece com o gestore detector


      //CLIQUE EM UM PRODUTO
      //quando clico em um produto
      onTap: (){//funcao anonima
        Navigator.of(context).push(
          //NOVA TELA
          MaterialPageRoute(builder: (context)=> ProdutoScreen(produtoDados)), //quero abrir a nossa tela com um produto especifico
        );
      },


      child: Card(//cartão com conteudo dentro
        //o filho vai variar de acordo o tipo de layout passado
        child: (
          (tipo == "grid") ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, //imagem fica esticada
            mainAxisAlignment: MainAxisAlignment.start, //começa a alinhar no inicio da pagina
            children: <Widget>[

              //especificando a imagem do produto
              //aspect ration tem tamenho definido
              AspectRatio(//imagem vai ficar com tamanho definido e não vai variar para cada tipo de dispositivo
                aspectRatio: 0.8,//largura dividido pela altura quadrado seria 1.0
                child: Image.network(
                  produtoDados.imagens[0], //pega a primeira imagem
                  fit: BoxFit.cover, //para cobrir  o espaço possivel
                ),
              ),

              //quero especificar todos os meus textos dos produtos
              Expanded( //pega all o espaço disponivel
                  child: Container( //porque será dado um espaço entre a imagem e o texto e as laterais
                    padding: EdgeInsets.all(8.0),
                    child: Column(//conteudo de textos
                      //crossAxisAlignment: CrossAxisAlignment.start, //define alinhamento do texto a esquerda
                      children: <Widget>[

                        //titulo do meu produto
                        Text(
                          produtoDados.titulo,
                          style: TextStyle(
                            fontWeight: FontWeight.w500
                          ),
                        ),

                        //valor do meu produto
                        Text(
                          "R\$ ${produtoDados.preco.toStringAsFixed(2)}", //para mostrar apenas duas casas decimais
                          style: TextStyle(
                            color: Theme.of(context).primaryColor, //busca a cor primaria do app
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold //negrito
                          ),
                        )
                      ],
                    ),
                  ),
              )

            ],
          )
          :Row(
            children: <Widget>[


              //imagem igual o tamanho do outro lado
              Flexible(
                flex: 1, //flex do mesmo tamanho para conteudo ficar igual dos dois lados
                child: Image.network(
                  produtoDados.imagens[1], //pega a primeira imagem
                  fit: BoxFit.cover, //para cobrir  o espaço possivel
                  height: 250.00, //tem que definir manualmente a altura
                ),
              ),

              //texto de descriçao da imagem
              Flexible(
                flex: 1, //flex do mesmo tamanho
                child: Container( //porque será dado um espaço entre a imagem e o texto e as laterais
                  padding: EdgeInsets.all(8.0),
                  child: Column(//conteudo de textos
                    crossAxisAlignment: CrossAxisAlignment.start, //define alinhamento do texto a esquerda
                    children: <Widget>[

                      //titulo do meu produto
                      Text(
                        produtoDados.titulo,
                        style: TextStyle(
                            fontWeight: FontWeight.w500
                        ),
                      ),

                      //valor do meu produto
                      Text(
                        "R\$ ${produtoDados.preco.toStringAsFixed(2)}", //para mostrar apenas duas casas decimais
                        style: TextStyle(
                            color: Theme.of(context).primaryColor, //busca a cor primaria do app
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold //negrito
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        )
      ),
    );
  }
}
