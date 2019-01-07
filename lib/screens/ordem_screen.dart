import 'package:flutter/material.dart';

class OrdemScreen extends StatelessWidget {

  final String idOrdem;

  //construtor para receber a ordem na tela 
  OrdemScreen(this.idOrdem);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedido Ralizado"),
        centerTitle: true,
      ),
      
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, //todos elementos devem ficar centralizados na tela
          children: <Widget>[
            Icon(
              Icons.check,
              color: Theme.of(context).primaryColor,
              size: 80.0,
            ),

            Text(
              "Pedido Realizado com sucesso!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),

            Text(
              "Codigo do pedido ${idOrdem}",
              style: TextStyle(fontSize: 20.0),
            )

          ],
        ),
      ),
    );
  }
}
