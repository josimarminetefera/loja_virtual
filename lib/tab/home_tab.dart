import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

//primeira tela principal do sistema monta o funda da tela principal bem como carrega cada uma das imagens
//chado pela home
class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //montando a arvore de widgets

    //retorna um fundo com degrade
    print("--HomeTab montando fundo HomeTab");
    Widget _buildBodyBack() => Container(
      decoration: BoxDecoration( //caixa xcom decoração
        gradient: LinearGradient(
          colors: [ //lista de cores
            Color.fromARGB(255, 211, 118, 130),
            Color.fromARGB(255, 253, 181, 168),
          ],
          begin: Alignment.topLeft, //direcionamento de cores inicio
          end: Alignment.bottomRight //direcionamento de cores fim
        )
      ),
    );

    //Stack coloca o conteudo acima do fundo
    return Stack(
      children: <Widget>[
        _buildBodyBack(), //carrego o degrade com a cor de degrade que fiz
        //criar a barra que fica por cima do fundo
        CustomScrollView( //barra diferente por cima de tudo
          slivers: <Widget>[

            //barra que ficará sobre a tela
            SliverAppBar(// barra principal
              floating: true, //flutua sobre o conteudo
              snap: true, //arrastar para baixo some para cima aparece
              backgroundColor: Colors.green, // cor de fundo da appbar
              elevation: 0.0, //mesmo plano do conteudo sem sombra
              flexibleSpace: FlexibleSpaceBar(
                title: const Text("Novidades"),
                centerTitle: true,
              ),
            ),

            //tem que mostrar algo na tela enquanto é carregado as imagens
            FutureBuilder<QuerySnapshot>(//nao obtem os dados rapdamente assim ele obtem assincronamente
              //buscar as imagens no firebase
              future: Firestore.instance.collection("home").orderBy("posicao").getDocuments(),// acessando todos documents e ordenando
              //builder cria as coisas na tela
              builder: (context, snapshot){

                if(!snapshot.hasData){ //ainda não carregou as imagens
                  print("HomeTab carregando imagens...");
                  //carregando os dados adaptar o box adapter a uma caixinha
                  return SliverToBoxAdapter( //adaptar um sliver em uma caixa
                    child: Container(
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  );

                }else{
                  //pegar cada imagem e exibir na tela
                  //.count pois já sabemos a quantidade exata de itens que temos que carregar
                  return SliverStaggeredGrid.count(// ja sei a quantidade
                    crossAxisCount: 2, // quantidades de blocos horizontatais todos itens carregados ao mesmo tempo
                    mainAxisSpacing: 1.0, //vertical espaçamento
                    crossAxisSpacing: 1.0, //horizontal espaçamento

                    //tem que passar a lista de dimenssoes para cada uma das imagens
                    staggeredTiles: snapshot.data.documents.map(//pego uma lista de documentos
                      //pega cada um dos documento, mapia com .map e criando uma funcao anonima que receque o documento
                      (doc){//funcao anonima
                        //cada elemento da lista é chamada e retorna um StaggrededTile
                        return StaggeredTile.count(doc.data["x"], doc.data["y"]);
                      }
                    ).toList(),// converte o mapa para uma lista novamente

                    children: snapshot.data.documents.map( //carregar as imagens dentro dos staggred criados
                      (doc){//funcao anonima
                        print("HomeTab pegando imagem: " + doc.data["image"]);
                        return FadeInImage.memoryNetwork( //imagem vai aparecer suavimente
                          placeholder: kTransparentImage,// e o que cria o efeito
                          image: doc.data["image"], //pegar a imagem
                          fit: BoxFit.cover, //cubra o espaço da grade
                        );
                      }
                    ).toList(),

                  );
                }
              },
            )
          ],
        )
      ],
    );
  }
}
