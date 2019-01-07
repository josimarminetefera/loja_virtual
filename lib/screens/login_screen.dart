import 'package:flutter/material.dart';
import 'package:loja_virtual/models/usuario_model.dart';
import 'package:loja_virtual/screens/cadastrar_screen.dart';
import 'package:scoped_model/scoped_model.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //controlaldores para os campos
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  //globalkey para acionar a validação dos campos dos formularios
  final _formKey = GlobalKey<FormState>();

  //scafold para gerar mensagem no final da pagina
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    print("--LoginScreen Montando a tela de _LoginScreenState");
    return Scaffold(

      key: _scaffoldKey,// scafold para uso geral da aplicação

      appBar: AppBar(
        title: Text("Entrar"),
        centerTitle: true,

        //botão do lado direito
        actions: <Widget>[
          FlatButton( //pode ser um icon aqui também
            child: Text(
              "Criar Conta",
              style: TextStyle(fontSize: 15.0),
            ),
            textColor: Colors.white,

            onPressed: (){
              //subistitui a tela de entrar pela tela de criar conta
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => CadastrarScreen())
              );
            },
          )
        ],
      ),

      //tela principal
      body: ScopedModelDescendant<UsuarioModel>(//tudo que esta aqui a baixo sera reconstruido caso seja feito alguma alteração no model
        builder: (context, child, model){//funcao anonima
          print("LoginScreen carregando tela de login ScopedModelDescendant para saber se está processando e efetuando o login do nominio ");
          if(model.carregando){//caso ainda esteja carregando ele retorna um circulo de carregamento
            return Center(
              child: CircularProgressIndicator(),
            );
          }else{
            print("LoginScreen carregando formulario de login");
            //abre o formulario caso ja tenha terminado de processar
            return Form( //faz validação dos seus campos

              key: _formKey,//esta chave controla a validação de campos

              child: ListView( //para deslocar o campo na hora que aparecer a barra de digitação

                padding: EdgeInsets.all(16.0),

                children: <Widget>[

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
                      if(texto.isEmpty || texto.length > 6){
                        return "Senha Inválido";
                      }
                    },

                  ),

                  //botao a direita
                  Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      onPressed: (){
                        if(_emailController.text.isEmpty){
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(//barra de aviso fica na parte inferior
                              content: Text("Informe o campo E-mail!"),
                              backgroundColor: Colors.redAccent,
                              duration: Duration(seconds: 2),
                            )
                          );
                        }else{
                          model.recuperarSenha(_emailController.text);
                          _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text("Confira seu E-mail!"),
                                backgroundColor: Theme.of(context).primaryColor,
                                duration: Duration(seconds: 2),
                              )
                          );
                        }
                      },
                      child: Text(
                        "Esqueci minha Senha",
                        textAlign: TextAlign.center,
                      ),
                      padding: EdgeInsets.zero,
                    ),
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
                        "Entrar",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,

                      onPressed: (){
                        //temos que acessar o nosso formulario para fazer a validação
                        //para isso tem que ser definido uma variavel global
                        if(_formKey.currentState.validate()){

                        }

                        //iniciar o login
                        model.entrar(email: _emailController.text, senha: _senhaController.text, onSuccess: _onSuccess, onFail: _onFail);

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
    Navigator.of(context).pop();
  }

  void _onFail(){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Falha ao Entrar!"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }
}

