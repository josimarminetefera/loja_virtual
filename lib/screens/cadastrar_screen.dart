import 'package:flutter/material.dart';
import 'package:loja_virtual/models/usuario_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CadastrarScreen extends StatefulWidget {
  @override
  _CadastrarScreenState createState() => _CadastrarScreenState();
}

class _CadastrarScreenState extends State<CadastrarScreen> {
  //tem que definir os controladores para pegar os valores dos campos
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _enderecoController = TextEditingController();


  //globalkey para acionar a validação dos campos dos formularios
  final _formKey = GlobalKey<FormState>();

  //scafold para gerar mensagem no final da pagina
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        key: _scaffoldKey,// scafold para uso geral da aplicação

        appBar: AppBar(
          title: Text("Cadastrar"),
          centerTitle: true,
        ),

        //tela principal
        body: ScopedModelDescendant<UsuarioModel>(
          builder: (context, child, model){
            print("--CadastrarScreen iniciando ScopedModelDescendant para montar  formulario");
            if(model.carregando){
              return Center(child: CircularProgressIndicator(),);
            }else{
              return Form( //faz validação dos seus campos

                key: _formKey,//esta chave controla a validação de campos

                child: ListView( //para deslocar o campo na hora que aparecer a barra de digitação

                  padding: EdgeInsets.all(16.0),

                  children: <Widget>[

                    TextFormField(
                      controller: _nomeController,
                      decoration: InputDecoration(
                          hintText: "Nome Completo"
                      ),

                      //validação dos campos
                      validator: (texto){
                        if(texto.isEmpty){
                          return "Nome Completo Inválido";
                        }
                      },

                    ),

                    SizedBox(
                      height: 16.0,
                    ),

                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          hintText: "E-mail"
                      ),
                      keyboardType: TextInputType.emailAddress,

                      //validação dos campos
                      validator: (texto){
                        if(texto.isEmpty || !texto.contains("@")){
                          return "E-mail Inválido";
                        }
                      },

                    ),

                    SizedBox(
                      height: 16.0,
                    ),

                    TextFormField(
                      controller: _senhaController,
                      decoration: InputDecoration(
                          hintText: "Senha"
                      ),
                      obscureText: true,

                      //validação dos campos
                      validator: (texto){
                        if(texto.isEmpty || texto.length < 6){
                          return "Senha Inválido";
                        }
                      },

                    ),

                    //botao entrar
                    SizedBox(
                      height: 16.0,
                    ),

                    TextFormField(
                      controller: _enderecoController,
                      decoration: InputDecoration(
                          hintText: "Endereço"
                      ),

                      //validação dos campos
                      validator: (texto){
                        if(texto.isEmpty){
                          return "Endereço Inválido";
                        }
                      },

                    ),

                    //botao entrar
                    SizedBox(
                      height: 16.0,
                    ),

                    //deixar o botão um pouco mais alto
                    SizedBox(
                      height: 45.0, //para deixar o botão um pouco mais auto
                      child: RaisedButton(
                        child: Text(
                          "Salvar",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        textColor: Colors.white,
                        color: Theme.of(context).primaryColor,

                        onPressed: (){
                          //temos que acessar o nosso formulario para fazer a validação
                          //para isso tem que ser definido uma variavel global
                          if(_formKey.currentState.validate()){

                            //criar um mapa com todos os campos
                            Map<String, dynamic> dadosUsuario = {
                              "nome": _nomeController.text,
                              "email": _emailController.text,
                              "endereco": _enderecoController.text
                            };
                            print("CadastrarScreen montando map dadosUsuario nome: "+dadosUsuario["nome"]);
                            model.cadastrar(
                                dadosUsuario: dadosUsuario,
                                senha: _senhaController.text,
                                onSuccess: _onSuccess,
                                onFail: _onFail
                            );
                          }
                        },

                      ),
                    )

                  ],

                ),
              );
            }
          },
        )
    );
  }

  void _onSuccess(){
    //barra na parte inferior tem que ter acesso ao scafold por isso deve ser criado la em cima
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Usuário Criado"),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 2),
      ),
    );
    //depois de dois segundos ele vai chamar a função que esta dentro do then
    Future.delayed(Duration(seconds: 2)).then((_){
      Navigator.of(context).pop();
    });
  }

  void _onFail(){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Falha ao Criar Usuário!"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }

}