import 'package:flutter/material.dart';
import 'package:loja_virtual/models/usuario_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/tiles/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';

//esta tela tem o drawer lateral com seu fundo e as opções alen dos itens para clicar
//clicando em um item abre o drawer tile
//chamada primeiro pela home screen
class CustomDrawer extends StatelessWidget {

  //o custronDrawer precisará acessar o _pageController do home scean para acessar paginas quando clicar em alguma
  //das opções de botões da tela do navegation
  // na verdade deverá ser chamado a ação de trocar a tela pelos botoes que ficam la dentro do drawerTile
  final PageController pageController; //para mudar de tela quando clicado em um item de menu
  //controlador para receber o page controller
  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {
    print("--CustomDrawer iciando montagem do drawer");
    //retorna um fundo com degrade
    Widget _buildDrawerBack() =>
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(100, 211, 118, 130),
                    Color.fromARGB(100, 253, 181, 168),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
              )
          ),
        );

    return Drawer( //o que monta a tela
      child: Stack( //colocar um fundo sobre o drawer
        children: <Widget>[
          _buildDrawerBack(), //fundo com degrade

          ListView( //lista de opções do menu lateral
            padding: EdgeInsets.only(left: 32.0, top: 16.0), //alinhamento para todos itens
            children: <Widget>[
              Container( //conteudo da tela superior com as opções
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 170.0,
                child: Stack( //muito bom para colocar componentes alinhados da forma que quiser
                  children: <Widget>[

                    //titulo da aplicacao
                    Positioned(
                      top: 8.0,
                      left: 0.0,
                      child: Text(
                        "Nome da \nAplicação", //com quebra de linha
                        style: TextStyle(fontSize: 34.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),

                    //itens que vão ficar na parte de baixo do titulo
                    Positioned(
                        left: 0.0,
                        bottom: 0.0,

                        child: ScopedModelDescendant<UsuarioModel>(
                          builder: (context, child, model) {
                            print("CustonDrawer ScopedModelDescendant para o texto olá e sair ou entrar.");
                            return Column( // coluna porque um texto vai ficar ensima do outro
                              crossAxisAlignment: CrossAxisAlignment.start, //alinhar no inicio
                              children: <Widget>[

                                Text(
                                  "Olá, ${model.estaLogado() ? model.dadosUsuario["nome"] : ""}",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),

                                GestureDetector( //para fazer capturar o click
                                  child: Text(
                                    model.estaLogado() ? "Sair" : "Entre ou Cadastre",
                                    style: TextStyle(
                                        color: Theme
                                            .of(context)
                                            .primaryColor, //para pegar a cor principal do app
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  onTap: () {
                                    if (model.estaLogado()) {
                                      model.sair();
                                    } else {
                                      //para abrir uma nova tela da aplicação sobre outra
                                      //para subistituir uma tela usa o recurso da tela de login cadastrar
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => LoginScreen())
                                      );
                                    }
                                  },
                                )

                              ],
                            );
                          },
                        )
                    )

                  ],
                ),
              ),

              Divider(),

              //lista de botoes de opções
              DrawerTile(Icons.home, "Inicio", pageController, 0),
              DrawerTile(Icons.list, "Podutos", pageController, 1),
              DrawerTile(Icons.location_on, "Lojas", pageController, 2),
              DrawerTile(Icons.playlist_add_check, "Pedidos", pageController, 3),
            ],
          )
        ],
      ),
    );
  }
}
