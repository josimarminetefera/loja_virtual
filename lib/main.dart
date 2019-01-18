import 'package:flutter/material.dart';
import 'package:loja_virtual/models/carrinho_model.dart';
import 'package:loja_virtual/models/usuario_model.dart';
import 'package:loja_virtual/screens/home_screen.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("MyApp Criando primeiro ScopedModel da aplicação.");
    return ScopedModel<UsuarioModel>( //este scoped controla toda a aplicação pela class user_model

      //tem que ser especificado o modelo
      model: UsuarioModel(),// tudo que estiver dentro deste scope pode ser acessado e modificado pelo usermodel

      //quando trocar de usuário eu quero que o carrinho seja atualizado por isso o decendant
      child: ScopedModelDescendant<UsuarioModel>(
        builder: (context, child, model){
          print("--MyApp iniciando a apllicação.");
          return ScopedModel<CarrinhoModel>(// o carrinho precisa saber o usuário que ele pertence por isso ele ficou dentro do usermodel

            model: CarrinhoModel(model),

            child: MaterialApp(
              //onde é iniciando o meu app de verdade
              title: 'Flutter',
              theme: ThemeData(
                  primarySwatch: Colors.red, //cor inicial
                  primaryColor: Color.fromARGB(255, 4, 125, 141)), //Cor principal do aplicativo
              debugShowCheckedModeBanner: false, //negocio que fica no canto direito


              //tela principal que inicia todos componentes
              home: HomeScreen(),


            ),
          );
        },
      )
    );
  }
}
