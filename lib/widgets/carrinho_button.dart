import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/carrinho_screen.dart';

class CarrinhoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("--CarrinhoButton Montando classe de carrinho");
    return FloatingActionButton(
      child: Icon(Icons.shopping_cart, color: Colors.white),
      onPressed: (){
        //abrir uma nova tela de carrinho
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => CarrinhoScreen())
        );
      },
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
