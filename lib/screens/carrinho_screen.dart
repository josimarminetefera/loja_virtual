import 'package:flutter/material.dart';
import 'package:loja_virtual/models/carrinho_model.dart';
import 'package:loja_virtual/models/usuario_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/screens/ordem_screen.dart';
import 'package:loja_virtual/tiles/carrinho_tile.dart';
import 'package:loja_virtual/widgets/cep_card.dart';
import 'package:loja_virtual/widgets/desconto_card.dart';
import 'package:loja_virtual/widgets/preco_card.dart';
import 'package:scoped_model/scoped_model.dart';

//?? é usado para verificar se algo é null retona 0 senão o valor da comparação tipo
//quantidadeDeProdutos??0 se for null retorna 0 senão retorna o valor


//esta tela conterá todos produtos e o total cada prtoduto da lista corresponde a um carrinhotile
//esta tela irá conter a lista de produtos que faz parte do nosso carrinho bem como um resumo dos valores
class CarrinhoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("--CarrinhoScreen montando tela de pedidos");
    return Scaffold( //para construir a barrinha na parte superior da tela

      appBar: AppBar(
        title: Text("Meu Carrinho"),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 8.0),

            //alinhamento para acertar o posicionamento de campos
            alignment: Alignment.center,

            child: ScopedModelDescendant<CarrinhoModel>(
              builder: (context, child, model){

                print("CarrinhoScreen  montando dados da tela de carrinho ScopedModelDescendant para o total de produtos");

                int quantidadeDeProdutos = model.listaProdutosDoCarrinho.length;

                return Text(
                  "${quantidadeDeProdutos??0} ${quantidadeDeProdutos == 1?"Item":"Itens"}",
                  style: TextStyle(fontSize: 17.0),
                );

              },
            ),
          )
        ],
      ),

      //toda nossa tela está dependendo do carrinho modelo quando por adicionado ou removido esta tela deve atualizar.
      body: ScopedModelDescendant<CarrinhoModel>(
        builder: (context, child, model){
          //4 casos possiveis
          //1 esta carregando algo processando algo
          //usuário nao esta logado tem que logar
          //carrinho vazio tem que mostrar carrinho vasio
          // usuário tem varios produtos no carrinho para comprar

          if(model.carregando && UsuarioModel.of(context).estaLogado()){
            //1 carrinho esta carregando
            print("CarrinhoScreen Carrinho esta carregando ....");
            return Center(
              child: CircularProgressIndicator(),
            );
          }else if(!UsuarioModel.of(context).estaLogado()){
            //2 usuário não esta logado
            print("CarrinhoScreen Usuário não esta logado montando tela para logar");

            //tenho que montar uma tela com um botão para logar
            return Container(
              padding: EdgeInsets.all(16.0),//descolar da bordas
              child: Column(//pois tera coisas encima da outra
                crossAxisAlignment: CrossAxisAlignment.stretch,//na horizontal queremos preencher  o espaço possivel
                mainAxisAlignment: MainAxisAlignment.center,//tudo fique no centro
                children: <Widget>[

                  //icone do carrinho sem nada
                  Icon(Icons.remove_shopping_cart, size: 80.0, color: Theme.of(context).primaryColor,),

                  //espaço na vertical
                  SizedBox(height: 16.0,),

                  //texto explicativo no centro da tela
                  Text("Faça o Login para Adicionar os Produtos!",
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


          //carrinho está vazio
          else if(model.listaProdutosDoCarrinho == null || model.listaProdutosDoCarrinho.length == 0 ){
            print("CarrinhoScreen Nenhum produto no carrinho");
            return Center(
              child: Text(
                "Nenhum produto no carrinho.",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            );
          }



          //IMPORTANTE IMPORTANTE IMPORTANTE IMPORTANTE
          //tenho produtos no carrinho e estou logado
          else{
            print("CarrinhoScreen Carrinho está lotado analisar os produtos.");
            return ListView( //list pois tem que ter uma barra de tolagem na tela
              children: <Widget>[


                //coluna com todos os nossos produtos
                Column(
                  //os filhos não serão colocados manualmente e sim pela função map
                  children: model.listaProdutosDoCarrinho.map( //mapeando os produtos da minha lista
                    (produtoAnalisado){
                      //estou pegando cada um dos produtos da minha lista de produtos e transformado cada um deles em um carrinhotile
                      //que é uma linha que conterá todos os dados do produto que foi adicionado no carrinho
                      return CarrinhoTile(produtoAnalisado);
                    }
                  ).toList(),
                ),


                //cartão de desconto
                DescontoCard(),


                //calcular cep
                CepCard(),


                //resumo do pedido
                PrecoCard(()async{//função para calcular o preço
                  print("CarrinhoScreen clicando em finalizar pedido.");
                  String idOrdem = await model.finalizarOrdem();
                  if(idOrdem != null){
                    //vamos para uma tela falando que tudo deu certo
                    Navigator.of(context).pushReplacement( //vai subistituir a tela de carrinho pela de confirmação da ordem
                      MaterialPageRoute(builder: (context) => OrdemScreen(idOrdem))
                    );
                  }
                }),

              ],
            );
          }



        },
      ),

    );
  }
}
