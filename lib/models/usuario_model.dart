import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//{} para facilitar na hora de inserir os parametros falando que eles nao sao obrigatorios
//@requeired fala que todos parametros devem ser alimentados independente da sequencia
//_ para funções internas e externas sem nada


//aqui irá armazenar o seu usuario atual e tambem tera todas funções para modificar o usuario atual

//Model é o objeto que vai guardar os estados de algo
//neste caso e o estado do loguin do seu app
class UsuarioModel extends Model{
  //usuario atual

  //isso é um sigonthon ou seja só tem uma instancia no app inteiro
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //usuário que esta logado no momento
  FirebaseUser firebaseUser;

  //tera os dados mais importantes do usuário
  Map<String, dynamic> dadosUsuario = Map();

  //quando esta sendo processado algo este recurso sera usado
  bool carregando = false;

  //static é metodo da classe e não do objeto
  //verificar se o usuário está logado para adicionar itens ao carrinho
  //isso dara acesso ao nosso user model de qualquer lugar
  //este metodo serve para verificar um objeto deste tipo dentro do projeto como o Navigator.of(context)
  static UsuarioModel of(BuildContext context){
    print("UsuarioModel função para resgatar state sem o decendant");
    //da acesso ao usermodel de qualquer lugar do app
    return ScopedModel.of<UsuarioModel>(context);
    //isso discarta o uso do scopedmodeldecendant
  }

  //VoidCallback função que iremos passar e chmar de dentro da função entrar
  //onSuccess vira uma função para ser executada

  //control + o abre algumas funções padrões
  //carregar os dados quando o nosso aplicativo abre 
  @override
  void addListener(VoidCallback listener){
    super.addListener(listener);
    print("--UsuarioModel addListener iniciado ");
    //pega o usuário na hora que entra no app
    _carregarDadosUsuarioLogado();
  }

  void entrar({@required String email,@required String senha,@required VoidCallback onSuccess,@required VoidCallback onFail}) async{
    carregando = true;
    notifyListeners();

    print("UsuarioModel funcionalidade entrar");
    //email e senha para logar na aplicação
    firebaseAuth.signInWithEmailAndPassword(email: email, password: senha).then(//then pois o login nao ocrre instantaneamente
        (usuario) async{
          //salvando os dados do usuário
          firebaseUser = usuario;

          //carregar os dados do usuário logado
          await _carregarDadosUsuarioLogado();

          onSuccess();

          carregando = false;
          notifyListeners();
        }
    ).catchError((erro){
      onFail();
      carregando = false;
      notifyListeners();
    });
  }

  void cadastrar({@required Map<String, dynamic> dadosUsuario, @required String senha, @required VoidCallback onSuccess, @required VoidCallback onFail}){
    carregando = true;
    notifyListeners();

    print("UsuarioModel função cadastrar");

    firebaseAuth.createUserWithEmailAndPassword(
      email: dadosUsuario["email"],
      password: senha
    ).then( //depois que processar ele irá chamar isso aqui recebendo um usuário do fb

        (usuario) async{ //isso é uma função
          firebaseUser = usuario;

          print("UsuarioModel usuário cadastrado na base de dados de login");
          //await porque vou esperar a função completar
          await _salvarDadosUsuario(dadosUsuario);

          onSuccess();
          carregando = false;
          notifyListeners();
        }

    ).catchError(

      (erro){//chamar função caso de erro
        onFail();
        carregando = false;
        notifyListeners();
      }

    );
  }

  void sair()async{
    print("UsuarioModel sair");
    carregando = true;
    //tem que ser ind icado que eu alterei alguma coisa em nosso modelo assim pode ser feito
    notifyListeners();
    await Future.delayed(Duration(seconds: 3,));

    //deslogar da conta
    firebaseAuth.signOut();

    //lipar os dados do usuário
    dadosUsuario = Map();

    //limpar o usuário
    firebaseUser = null;

    carregando = false;
    notifyListeners();
  }

  void recuperarSenha(String email){
    firebaseAuth.sendPasswordResetEmail(email: email);
  }

  bool estaLogado(){
    return firebaseUser != null;
  }

  //esta função salvara os dados
  Future<Null> _salvarDadosUsuario(Map<String, dynamic> dados) async{
    print("UsuarioModel _salvarDadosUsuario");
    this.dadosUsuario = dados;
    //salvando os dados do cadastro do usuário
    //await pois este salvamento não ocorre instantaneamente
    await Firestore.instance.collection("usuarios").document(firebaseUser.uid).setData(dadosUsuario);
  }

  Future<Null> _carregarDadosUsuarioLogado() async{
    print("UsuarioModel entrou em _carregarDadosUsuarioLogado");
    if(firebaseUser == null){
      //nao tem nenhum usuário logado ainda
      firebaseUser = await firebaseAuth.currentUser();
      print("UsuarioModel firebaseUser == null");
    }
    if(firebaseUser != null){
      print("UsuarioModel firebaseUser != null");
      //logou com sucesso
      //pegar os dados do usuário
      if(dadosUsuario["nome"] == null){ //usuário tem um nome
        //temos que pegar os dados do documento
        DocumentSnapshot documentSnapshot = await Firestore.instance.collection("usuarios").document(firebaseUser.uid).get();
        dadosUsuario = documentSnapshot.data;
      }
    }
    print("UsuarioModel fim _carregarDadosUsuarioLogado");
    notifyListeners();
  }
}