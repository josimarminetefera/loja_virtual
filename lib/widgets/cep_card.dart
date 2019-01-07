import 'package:flutter/material.dart';

class CepCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile( //é um componente que voce clica e expande
        title: Text(
          "Calcular Frete",
          textAlign: TextAlign.left,
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.green[700]),
        ),

        //icone que fica no comesso
        leading: Icon(Icons.location_on),

        //icone que fica do lado direito
        trailing: Icon(Icons.arrow_forward),

        //conteudo do card
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(//campo para digitar nosso cupom
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Digite seu Cep"
              ),

              //vai abrir aplicando o codigo de cupom caso tenha caso nao tenha vai colocar vazio
              initialValue: "",

              //quando eu digitar o cupom e selecionar concluido vai aplicar o cupom
              onFieldSubmitted: (texto){

              },
            ),
          )
        ],
      ),
    );
  }
}
