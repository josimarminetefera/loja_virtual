import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//esta aqui é cada uma das cards de acordo com o id da ordem passado

class OrdemTile extends StatelessWidget {

  String idOrdem;

  //construtor
  OrdemTile(this.idOrdem);


  @override
  Widget build(BuildContext context) {
    print("--OrdemTile inicio");
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Padding(//para colocar as bordas no card
        padding: EdgeInsets.all(8.0),
        //documentsnapshot pois cada item desta tela representa uma ordem um pedido
        //então ele vem nesta função o mesmo numero de vezes de pedidos
        child: StreamBuilder<DocumentSnapshot>( //isso aqui vai ficar olhando o banco de dados para verificar se atualizou o valor

          //importante importante
          //para ter atualizações em tempo real usamos snapshots
          stream: Firestore.instance.collection("ordens").document(idOrdem).snapshots(),

          builder: (context, snapshot){
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            }else{
              //se tem algum dado para renderezar

              int situacao = snapshot.data["situacao"];

              print("OrdemTile situação analizada: " + situacao.toString());
              return Column( //pois temos dados encima do outro

                crossAxisAlignment: CrossAxisAlignment.start, //alinhado a esquerda

                children: <Widget>[

                  Text(
                    "Codigo do pedido ${snapshot.data.documentID}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 4.0,),

                  Text(
                    //texto com os dados do produto separado só para organizar melhor
                    _carregarTextoProduto(snapshot.data)
                  ),

                  SizedBox(height: 4.0,),

                  Text(
                    "Situação do Pedido:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  //sistema para acompanhar os pedidos
                  Row(//para colocar uma bilinha do lado da outra
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[

                      _carregarCirculo("1", "Preparação", situacao, 1),

                      Container(
                        height: 1.0,
                        width: 40.0,
                        color: Colors.green[50]
                      ),

                      _carregarCirculo("2", "Transporte", situacao, 2),

                      Container(
                          height: 1.0,
                          width: 40.0,
                          color: Colors.green[50]
                      ),
                      _carregarCirculo("3", "Entrega", situacao, 3),
                    ],
                  )


                ],
              );
            }
          },
        ),
      )
    );
  }

  String _carregarTextoProduto(DocumentSnapshot documentSnapshot){
    print("OrdemTile _carregarTextoProduto ");
    String texto = "Descrição:\n";
    //vai passar por cada um dos produtos do pedido
    //as listas geradas pelo firebase é uma linkedhaskmap
    //importante importante importante
    for(LinkedHashMap produto in documentSnapshot.data["produtos"]){ //isso acessa os produtos
      //aqui eu tenho acesso aos dados de cada um dos produtos
      texto += "${produto["quantidade"]} x ${produto["produto"]["titulo"]} (R\$ ${produto["produto"]["preco"].toStringAsFixed(2)});\n";
    }
    texto += "Total: R\$ ${documentSnapshot.data["total"].toStringAsFixed(2)}";
    return texto;
  }

  //esta função será chamada em cada uma das bolinhas então 3 vezes
  //função que vai gerar as bolinhas para acompanhar os pedidos
  Widget _carregarCirculo(String titulo, String subtitulo, int situacao, int situacaoDesenho){ //thissituação é a situação que corresponde a nossa bolinha
    //3 estados. procesado, processando, nao processado
    print("OrdemTile _carregarCirculo do pedido ");
    Color corFundo; //cor de fundo da bola
    Widget child; //icone usado para atualizr o prfifo

    if(situacao < situacaoDesenho){
      //anda não chegados na situação do pedido
      corFundo = Colors.grey[500];
      child = Text(titulo, style: TextStyle(color: Colors.white),);
    }else if (situacao == situacaoDesenho){
      corFundo = Colors.blue;
      child = Stack(//texto e o circulo girando
        alignment: Alignment.center,
        children: <Widget>[
          Text(titulo, style: TextStyle(color: Colors.white),),

          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      );
    }else{
      corFundo = Colors.green;
      child = Icon(Icons.check, color: Colors.white,);
    }

    return Column( //bolinha encima subtitulo embaixo
      children: <Widget>[

        //desenho do avatar de bola
        CircleAvatar(
          radius: 20.0,
          backgroundColor: corFundo,
          child: child,
        ),

        Text(subtitulo),

      ],
    );
  }

}
