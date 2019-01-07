import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/produto_data.dart';
import 'package:loja_virtual/tiles/produtos_tile.dart';

//pode se entender como um listar de produtos
//esta classe monta a tela que contem todos produtos por categoria selecionada
//quem carrega cada um dos produtos e o produtos tile ele tem os alinhamentos para montar cada um dos produtos
//chamado pela cat tile
class CategoriasScreen extends StatelessWidget {

  //construtor para esta tela deve receber o documento da nossa categoria
  //indica qual o id e titulo da categoria, qual categoria ele é este também fica la no titulo
  final DocumentSnapshot documentSnapshot; //este é o documento da base de dados que indica a categoria
  //construtor recebe o snapshot
  CategoriasScreen(this.documentSnapshot);

  @override
  Widget build(BuildContext context) {
    print("--CategoriasScreen eu selecionei uma categoria agora consigo ver os produto que ela tem ");
    //construindo o sistema para mudar de tabs
    return DefaultTabController(//criando as tabs para demonstração do produto
      length: 2, //quantidade de tabs
      child: Scaffold(

        appBar: AppBar( //appbar com as tabs para mudar de tipo de alinhamento

          title: Text(documentSnapshot.data["titulo"]),
          centerTitle: true,//centralizar o titulo

          //mudar as formas de ordenação dos produtos
          bottom: TabBar( //barrinha abaixo da appbar para ficar com os icones de ordenação
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.grid_on),
              ),
              Tab(
                icon: Icon(Icons.list),
                //text: "Listar",
              )
            ],
          ),

        ),

        //telas de produtos
          //QuerySnapshhot é a fotografia de uma coleção assim pode acessar as fotografias de cada um dos documentos
          //DocumentSnapshot é a fotografia de apenas um documento
        body: FutureBuilder<QuerySnapshot>(//sempre deve ser especificado o tipo de builder

          //pegar todos os itens de acordo com o id da categoria clicada que fica no snapshot
          future: Firestore.instance.collection("produtos").document(documentSnapshot.documentID).collection("itens").getDocuments(), //isso tras os dados

          //isso monta os dados
          //este snapshot indica cada documento da nossa categoria/ cada produto da nossa categoria
          builder: (context, snapshot){//snapshot que obtivemos no nosso servidor
            print("CategoriaScreen iniciando montagem da tela de produtos por categoria");
            if(!snapshot.hasData){

              return Center(
                child: CircularProgressIndicator(),//processando enquanto nao carrega as imagens
              );
            }else{

              //retornar a lista de cada um dos produtos
              return TabBarView( //o que deve ser mostrado em cada uma das tabs
                //physics: NeverScrollableScrollPhysics(), //para nao permitir arrastar
                children: <Widget>[

                  //primiera grid
                  GridView.builder(//builder possibilita que nao carregue todas imagens de uma vez e sim conforme voce vai rolando a grid
                      padding: EdgeInsets.all(4.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, //horizontal pois a lista é vertical
                        mainAxisSpacing: 4.0, //vertical
                        crossAxisSpacing: 4.0, //horizontal
                        childAspectRatio: 0.65 //esta é a diferença entre a largura e a autura para melhor espandir a imagem
                      ),//quantos itens vou ter na horizontal
                      itemCount: snapshot.data.documents.length,//quantidade de itens da minha grade
                      itemBuilder: (context, index){//funcao anonima

                        ProdutoDados produtoDados = ProdutoDados.documentoParaProdutoDados(snapshot.data.documents[index]);
                        //tenho que passar a categoria do produto da lista
                        produtoDados.categoria = this.documentSnapshot.documentID;

                        print("CategoriasScreen montando tela em formato de grid");
                        return ProdutosTile("grid", produtoDados);// manda o produto para a tile
                      }
                  ),

                  //segunda visualização em lista
                  ListView.builder( //builder pois ele vai carregando a medida que faz scrool
                    padding: EdgeInsets.all(4.0),
                    itemCount: snapshot.data.documents.length,//quantidade de itens da minha grade
                    itemBuilder: (context, index){//funcao anonima

                      ProdutoDados produtoDados = ProdutoDados.documentoParaProdutoDados(snapshot.data.documents[index]);
                      //tenho que passar a categoria do produto da lista
                      produtoDados.categoria = this.documentSnapshot.documentID;

                      print("CategoriasScreen montando tela em formato de list");
                      return ProdutosTile("list", produtoDados);// manda o produto para a tile
                    }
                  )
                ],
              );
            }
          }
        )
      ),
    );
  }
}
