import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/carrinho_model.dart';

class DescontoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile( //é um componente que voce clica e expande
        title: Text(
          "Cupom de Desconto",
          textAlign: TextAlign.left,
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.green[700]),
        ),

        //icone que fica no comesso
        leading: Icon(Icons.card_giftcard),

        //icone que fica do lado direito
        trailing: Icon(Icons.add),

        //conteudo do card
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(//campo para digitar nosso cupom
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Digite seu Cupom"
              ),

              //vai abrir aplicando o codigo de cupom caso tenha caso nao tenha vai colocar vazio
              initialValue: CarrinhoModel.of(context).codigoCupom ?? "",

              //quando eu digitar o cupom e selecionar concluido vai aplicar o cupom
              onFieldSubmitted: (texto){
                //tem que ser verificado se este é um cupom valido
                Firestore.instance.collection("cupons").document(texto).get().then(//depois de verificar o cupom no firebasae vou realmente
                    (documentoEncontrado){
                      //verificar se o cupom existe ou nao
                      if(documentoEncontrado.data != null){
                        
                        //salvar o cupom no banco local
                        CarrinhoModel.of(context).setarCupom(texto, documentoEncontrado.data["percentualDesconto"]);
                        
                        //vou adicionar um aviso para o usuário
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Desconto de ${documentoEncontrado.data["percentualDesconto"]}% aplicado!"),
                            backgroundColor: Theme.of(context).primaryColor,
                          )
                        );
                      }else{

                        //salvar no banco local o valor do cupom
                        CarrinhoModel.of(context).setarCupom(null, 0);

                        //exibir mensagem para o usuário
                        Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Cupom não Existente!"),
                              backgroundColor: Colors.red,
                            )
                        );
                      }
                    }
                );

              },
            ),
          )
        ],
      ),
    );
  }
}
