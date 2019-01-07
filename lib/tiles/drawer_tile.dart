import 'package:flutter/material.dart';

//ela cria cada um dos icones do menu para disparar cada tela
//está classe ira cria o efeito de mostrar qual tela esta selecionada quando o usuário clicar
//chamado pelo custon drawer
class DrawerTile extends StatelessWidget {

  //construtor vai receber um icone e um texto
  final IconData iconData; //icone da opção
  final String text; //texto da opção
  //esse controler vem do conston drawer
  PageController pageController; //serve para mudar de tela quando clicado na tela quando clicado em um item de menu
  //qual pagina corresponde cada item do menu
  final int page;

  //construtor com o pageController que consegui na tela home_screen
  //a responsabilidade de mudar de tela ficará por conta de cada um dos itens clicados neste menu
  DrawerTile(this.iconData, this.text, this.pageController, this.page);

  @override
  Widget build(BuildContext context) {
    return Material( //usado para dar um efeito visual quando for clicado por isso material
      color: Colors.transparent,//cor de fundo de cada icone do menu

      //inkwell cria um efeito quando clicado sobre a opção
      child: InkWell( //vai representar a linha com as duas opções



        //CARREGA A TAB CLICADA
        //carrega a tela clicada ou mais certo a tab clicada
        onTap: (){
          Navigator.of(context).pop();//fechar o menu ao clicar
          pageController.jumpToPage(page);//carregar a pagina do item de menu clicado
        },


        //itens da lista do drawer.
        child: Container(
          height: 60.0,//altura de cada item
          child: Row( //vai ficar iconne e texto na horizontal
            children: <Widget>[

              Icon(
                iconData,
                size: 32.0,
                //o color depende a pagina atual que ele está
                //se o page controler for igual a page coloco a primarecolor
                color: pageController.page.round() == page ?
                  Theme.of(context).primaryColor: Colors.grey[700], //isso aqui é disparado quando eu clico em um item no menu
              ),

              SizedBox( //espaço entre as opções do botão e do texto
                width: 32.0,
              ),

              Text( //será o texto da opção
                text,
                style: TextStyle(
                  fontSize: 16.0,
                  //o color depende a pagina atual que ele está
                  //se o page controler for igual a page coloco a primarecolor
                  color: pageController.page.round() == page ?
                    Theme.of(context).primaryColor: Colors.grey[700], //isso aqui é disparado quando eu clico em um item no menu
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
