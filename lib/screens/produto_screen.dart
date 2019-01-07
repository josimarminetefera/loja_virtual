import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/carrinho_produto.dart';
import 'package:loja_virtual/datas/produto_data.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:loja_virtual/models/carrinho_model.dart';
import 'package:loja_virtual/models/usuario_model.dart';
import 'package:loja_virtual/screens/carrinho_screen.dart';
import 'package:loja_virtual/screens/login_screen.dart';


//esta tela tem os dados de cada produto clicado
//acionado quando clico em um produto no produto tilie
//vem do click do produto tile
class ProdutoScreen extends StatefulWidget {

  //ao clicar no produto da tela anterior ele tras o produto selecionado
  final ProdutoDados produtoData;
  //construtor
  ProdutoScreen(this.produtoData);

  @override
  _ProdutoScreenState createState() => _ProdutoScreenState(produtoData);
}

class _ProdutoScreenState extends State<ProdutoScreen> {

  //TENHO QUE ACESSAR O MEU PRODUTO DENTRO DO STATE
  //assim eu crio um construtor igual o de cima
  final ProdutoDados produtoDados;
  _ProdutoScreenState(this.produtoDados);

  String tamanhoSelecionado;

  @override
  Widget build(BuildContext context) {


    //vou usar esta cor varias veses então vou criar uma variavel para ela de uma vez
    final Color primaryColor = Theme.of(context).primaryColor;


    return Scaffold(//isso para ter uma barrinha la no topo do appbar

      //barra da parte superior
      appBar: AppBar(
        title: Text(produtoDados.titulo),
        centerTitle: true,
      ),


      //o usuário tera que rolar o mouse caso a tela seja grande entao tem que ser usado uma lista ou um scroll
      body: ListView(
        children: <Widget>[


          //carousel de imagens
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              images: produtoDados.imagens.map((url){//tenho que pegar minha lista de url e passar ela como uma lista de imagens para carregar no carrosel
                return NetworkImage(url);//pego cada url e transformo em uma imagem
              }).toList(),
              dotSize: 5.0,//pontinho no final do carrocel
              dotSpacing: 15.0,//espaço entre os pontos
              dotBgColor: Colors.cyanAccent,
              dotColor: primaryColor,
              autoplay: false,//para nao mudar as imagens automaticamente

              //verificar as animações e tempos aqui

            ),
          ),

          //outros campos da tela terão que ser um pouco mais recuado a esquerda e acima
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(

              //strach e a mesma coisa que o math.parent do android
              crossAxisAlignment: CrossAxisAlignment.stretch, //alinhar todos os campos todos campos vão tentar ocupar o maximo do espaço tipo o math parent
              //outros campos
              children: <Widget>[

                
                //titulo da camisa
                Text(
                  produtoDados.titulo,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500//peso do texto
                  ),
                  maxLines: 3,//quantidade maxima de linhas que o titulo vai ocupar
                ),


                //preço da camisa
                Text(
                  "R\$ ${produtoDados.preco.toStringAsFixed(2)}", //fixar aceitar somente dois numeros depois da virgula
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold, //peso do texto
                    color: primaryColor //cor do texto
                  ),
                ),


                //janela com o tamanho de cada produto
                //TEM QUE COLOCAR UM ESPAÇO ENTRE OS DOIS COMPONENTES
                SizedBox(
                  height: 16.0,
                ),

                //texto que vai conter o tamanho de cada peça de roupa
                Text(
                  "Tamanhos",
                  style: TextStyle(
                    fontSize: 16.0, // tamanho de letra
                    fontWeight: FontWeight.w500 // peso do negrito
                  ),
                ),


                //janela onde poderemos selecionar o tamnaho
                //quero especificar uma altura fixa para esta janela entao uso tambem o sizedbox
                SizedBox(
                  height: 35.0, //altura fixa
                  child: GridView(//muito paraecida com a listview  com grid os quadradinhos ficam um pouco mais separado um do outro
                    padding: EdgeInsets.symmetric(vertical: 4.0),//simetrico porquesomente na vertical
                    scrollDirection: Axis.horizontal, //se voce nao colocar nada ele vai achar que voce esta colocando na vertical
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, //pois tem apenas uma linha para mostrar o produto
                      mainAxisSpacing: 8.0, //só tem espaçamento na horizontal pois a lista é na horizontal
                      childAspectRatio: 0.5 //largura duas vezes maior que a altura
                    ),


                    //valor principal da grid
                    children: produtoDados.tamanho.map( //quero mapear todos os produtos
                      (tamanhoClicado){
                        return GestureDetector( //pois queremos detectar quando for clicado


                          //quando o usuário clicar na caixinha
                          onTap: (){
                            setState(() { //tem que fazer uma alteração durante a execução
                              tamanhoSelecionado = tamanhoClicado;
                            });
                          },

                          //desenho de cada uma das opções de tamanho
                          child: Container(
                            decoration: BoxDecoration( //decoração no container com a borda arredondada
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              border: Border.all(

                                //caso seja clicado em um dos itens ele coloca a cor primaria
                                color: tamanhoClicado == tamanhoSelecionado ? primaryColor : Colors.green[500],

                                width: 3.0 //largura da borda
                              )
                            ),
                            width: 50.0, //largura do container
                            alignment: Alignment.center ,//alinhamento do texto dentro do container

                            //texto do tamanho
                            child: Text(tamanhoClicado),

                          ),
                        );
                      }
                    ).toList(),


                  ),
                ),


                //colocar um espaçamento na vertical
                SizedBox(
                  height: 16.0,
                ),


                //botão para adicionar ao carrinho
                SizedBox(//para ficar com um tamanho especifico
                  height: 45.0, //altura do botão é fixa
                  child: RaisedButton(
                    color: primaryColor, //cor de fundo do botão
                    textColor: Colors.white, //cor de texto do botão

                    onPressed:
                    //se eu só entrar na tela o botão estara desabilitado e se eu selecionar um tamanho ele vai habilitar
                    tamanhoSelecionado != null? () {
                      //tem um tamanho selecionado
                      if(UsuarioModel.of(context).estaLogado()){
                        print("ProdutoScreen montando os dados para adicionarProdutoCarrinho");
                        //adicionar ao carrinho
                        CarrinhoProduto carrinhoProduto = CarrinhoProduto();
                        carrinhoProduto.tamanho = tamanhoSelecionado;
                        carrinhoProduto.quantidade = 1;
                        carrinhoProduto.idProduto = produtoDados.id;
                        carrinhoProduto.categoria = produtoDados.categoria;

                        print("ProdutoScreen Dados da categoria " + carrinhoProduto.categoria.toString());

                        //para adicionar ao carrinho temos que ter acesso ao carrinhomodel
                        CarrinhoModel.of(context).adicionarProdutoCarrinho(carrinhoProduto);

                        //apos adicionar o produto abrir a tela do carrinho
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => CarrinhoScreen())
                        );
                      }else{
                        //abrir a tela para o usuário logar
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => LoginScreen())
                        );
                      }
                    }: null,

                    //texto do botao
                    child: Text(
                      //o certo aqui era usar o scoped model
                      UsuarioModel.of(context).estaLogado()?
                      "Adicionar ao Carrinho": "Entre Para Comprar",
                      style: TextStyle(
                        fontSize: 18.0
                      ),
                    ),


                  ),
                ),

                //espaçamento
                SizedBox(
                  height: 16.0,
                ),

                //descrição
                Text(
                  "Descrição",
                  style: TextStyle(
                      fontSize: 16.0, // tamanho de letra
                      fontWeight: FontWeight.w500 // peso do negrito
                  ),
                ),

                //texto da discrição
                Text(
                  produtoDados.descricao,
                  style: TextStyle(
                    fontSize: 16.0
                  ),
                ),

              ],

            ),
          )
        ],
      ),
    );
  }
}

