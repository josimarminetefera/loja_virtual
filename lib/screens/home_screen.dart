import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/cadastrar_screen.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/tab/home_tab.dart';
import 'package:loja_virtual/tab/categorias_tab.dart';
import 'package:loja_virtual/widgets/carrinho_button.dart';
import 'package:loja_virtual/widgets/custom_drawer.dart';

//esta rela contem o conteudo de cada uma das telas da tabs
//esta tela é um pageview que contem todas telas principais da aplicação.
//segunda tela carregada no sistema
class HomeScreen extends StatelessWidget {

  //declaração de um controlador
  //controlar a navegacao pelo codigo enao pelo dedo
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    print("--HomeScreen iniciando tela principal da aplicação com cada uma das tabs e menu.");
    return PageView(
      controller: _pageController,

      //physics: NeverScrollableScrollPhysics(), //dessa forma não da scroll pelo dedo

      children: <Widget>[ //as telas serão como tabs para facilitar a navegação
        //navegacao será por tabs

        //tela principal do app
        Scaffold( // monta o menu lateral com o botão
          body: HomeTab(),//home+tab>tela principal do app
          drawer: CustomDrawer(_pageController),//menu lateral
          floatingActionButton: CarrinhoButton(),//botão no canto inferior direito
        ),

        //tela de categorias de produtos
        Scaffold( // monta o menu lateral com o botão
          appBar: AppBar(
            title: Text("Produtos"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),//menu lateral
          body: CategoriasTab(),//home+tab+tile tela de categoria pronta+screen tela onte tem os produtos+pro_tile produtos
          floatingActionButton: CarrinhoButton()//botão no canto inferior direito
        ),

        Scaffold(
          body: LoginScreen(),
        ),

        Scaffold(
          appBar: AppBar(
            title: Text("Meus Pedidos"),
          ),
          body: CadastrarScreen(),
        ),
      ],
    );
  }
}
