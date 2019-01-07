import 'package:flutter/material.dart';
import 'package:loja_virtual/models/carrinho_model.dart';
import 'package:scoped_model/scoped_model.dart';

class PrecoCard extends StatelessWidget {

  //eu quero comprar pela tela carrinhoscreen e não aqui dentro do cardpreço
  final VoidCallback comprar;
  //construtor recebe a função de comprar da tela de carrinho screen
  PrecoCard(this.comprar);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),

      child: Container( //container pois tenho que dar um espaçamento em todo o card
        padding: EdgeInsets.all(16.0),
        child: ScopedModelDescendant<CarrinhoModel>( //scoped model pois o calor fica atualizando de acordo com que produtos entrão
          builder: (context, child, model){


            //tres valores de preço para colocar na tela
            double preco = model.calcularValorSubtotal();
            double desconto = model.calcularValorDesconto();
            double entrega = model.calcularValorEntrega();


            return Column(
              crossAxisAlignment:  CrossAxisAlignment.stretch, //tudo ocupe o maximo da largura
              children: <Widget>[

                //texto do resomo
                Text(
                  "Resumo do Pedido: ",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),

                //espaçamento
                SizedBox(height: 14.0,),

                //valor Subtotal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, //especifico que o espaço sera igual para cada item
                  children: <Widget>[ //os espaços entre os conteudos das linhas
                    Text("Subtotal"),
                    Text("R\$ ${preco.toStringAsFixed(2)}")
                  ],
                ),

                Divider(),

                //valor desconto
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, //especifico que o espaço sera igual para cada item
                  children: <Widget>[ //os espaços entre os conteudos das linhas
                    Text("Desconto"),
                    Text("R\$ ${desconto.toStringAsFixed(2)}")
                  ],
                ),

                Divider(),

                //valor Entrega
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, //especifico que o espaço sera igual para cada item
                  children: <Widget>[ //os espaços entre os conteudos das linhas
                    Text("Entrega"),
                    Text("R\$ ${entrega.toStringAsFixed(2)}")
                  ],
                ),

                Divider(),

                SizedBox(height: 14.0,),

                //valor Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, //especifico que o espaço sera igual para cada item
                  children: <Widget>[ //os espaços entre os conteudos das linhas
                    Text("Total",style: TextStyle(fontWeight: FontWeight.w500),),
                    Text("R\$ ${(preco + entrega - desconto).toStringAsFixed(2)}",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.0),)
                  ],
                ),

                //espaçamento
                SizedBox(height: 14.0,),

                RaisedButton(
                  child: Text("Finalizar Pedido"),
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,

                  //esto é para finalizar o pedido
                  onPressed: comprar,


                )

              ],
            );
          },
        ),
      ),
    );
  }
}
