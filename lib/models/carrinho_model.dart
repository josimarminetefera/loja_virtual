
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/datas/carrinho_produto.dart';
import 'package:loja_virtual/models/usuario_model.dart';
import 'package:scoped_model/scoped_model.dart';

//esta classe tem o conjunto de produtos que faz parte de um carrinho

class CarrinhoModel extends Model{

  //esta é a lista onde vai ficar toda a lista de produtos do meu carrinho
  List<CarrinhoProduto> listaProdutosDoCarrinho = [];

  //trabalhando com cupons de desconto
  String codigoCupom;
  int percentualDesconto = 0;

  //quando esta sendo processado algo este recurso sera usado
  bool carregando = false;

  //é importante saber o usuário atual
  UsuarioModel usuarioModel;

  //construtor que recebe o usuário do carrinho para carregar os itens do carrinho
  CarrinhoModel(this.usuarioModel){
    print("CarrinhoModel construtor CarrinhoModel verificando se tem carrinho");
    if(usuarioModel.estaLogado()){
      _carregarCarrinhoProdutos();
    }
  }

  //para fazer alterações em widghts dentro do aplicativo inteiro
  static CarrinhoModel of(BuildContext context){
    print("CarrinhoModel função para resgatar state sem o decendant");
    return ScopedModel.of<CarrinhoModel>(context);
  }

  void adicionarProdutoCarrinho(CarrinhoProduto carrinhoProduto){
    print("CarrinhoModel Entrei no adicionarProdutoCarrinho");
    //para adicionar um produto no carrinho
    listaProdutosDoCarrinho.add(carrinhoProduto);

    //tem que adicionar o produto no banco de dados também
    //dentro da coleção do usuário
    //dentro da coleção carrinho
    Firestore.instance.collection("usuarios").document(usuarioModel.firebaseUser.uid).collection("carrinho").add(
      carrinhoProduto.paraMap()
    ).then(//depois que eu adicionar tenho que pegar o id do carrinho que ainda não tem
        (documento){
          //depois que criei o produto no carrinho eu criei o carrinho e adicionei nos dados do produto
          carrinhoProduto.id = documento.documentID;
        }
    );
    notifyListeners();
  }

  void removerProdutoCarrinho(CarrinhoProduto carrinhoProduto){
    print("CarrinhoModel Entrei no removerProduto Carrinho idCarrinho: " + carrinhoProduto.id);
    Firestore.instance.collection("usuarios").document(usuarioModel.firebaseUser.uid).
    collection("carrinho").document(carrinhoProduto.id).delete();

    //remover o produto do carrinho
    listaProdutosDoCarrinho.remove(carrinhoProduto);

    notifyListeners();
  }

  void adicionarQuantidadeProduto(CarrinhoProduto carrinhoProduto){
    print("CarrinhoModel adicionarQuantidadeProduto idCarrinho: " + carrinhoProduto.id);
    carrinhoProduto.quantidade ++;

    Firestore.instance.collection("usuarios").
    document(usuarioModel.firebaseUser.uid).collection("carrinho").
    document(carrinhoProduto.id).updateData(carrinhoProduto.paraMap());
    notifyListeners();
  }

  void removerQuantidadeProduto(CarrinhoProduto carrinhoProduto){
    print("CarrinhoModel removerQuantidadeProduto idCarrinho: " + carrinhoProduto.id);
    //decrementar local
    carrinhoProduto.quantidade --;

    //decrementar no banco de dados
    Firestore.instance.collection("usuarios").
    document(usuarioModel.firebaseUser.uid).collection("carrinho").
    document(carrinhoProduto.id).updateData(carrinhoProduto.paraMap());
    notifyListeners();
  }


  //quando abrir o nosso aplicativo ele tem que carregar todos os produtos do carrinho no app
  void _carregarCarrinhoProdutos() async{
    print("CarrinhoModel iniciando _carregarCarrinhoProdutos");
    //pegar todos documento da coleção carrinho
    //tudo que tem dentro da coleção carrinho são os itens do carrinho
    QuerySnapshot consulta = await Firestore.instance.collection("usuarios").
    document(usuarioModel.firebaseUser.uid).collection("carrinho").getDocuments();//getdocument todos documentos

    //cada documento corresponde a um item do carrinho cada item corresponde a um produto
    listaProdutosDoCarrinho = consulta.documents.map(
      //cada documento do firebase ele esta convertendo para um carrinho produto
      (documento) => CarrinhoProduto.documentoParaCarrinhoProduto(documento)
    ).toList();//retorno a lista de carrinho produto para dentro do lista produtos carrinho

    notifyListeners();
  }

  //esta função é util para você calcular o presso semente apos eu ter todos os
  //dados alimentados pois senão pode ocorrer de carregar a tela calcular os preços e ainda não ter trago os produtos
  void atualizarPrecos(){
    print("CarrinhoModel atualizarPrecos quando carrega o produto atualiza o preço.");
    notifyListeners();
  }

  void setarCupom(String codigoCupom, int percentualDesconto){
    this.codigoCupom = codigoCupom;
    this.percentualDesconto = percentualDesconto;
  }

  double calcularValorSubtotal(){
    double preco = 0.0;
    //navega entre cada um dos produtos e incrementa o preço
    for(CarrinhoProduto carrinhoProduto in listaProdutosDoCarrinho){

      //caso ele já tenha carregado os dados dos produtos
      if(carrinhoProduto.produtoDados != null){
        preco += carrinhoProduto.quantidade * carrinhoProduto.produtoDados.preco;
      }
    }
    return preco;
  }

  double calcularValorDesconto(){
    return calcularValorSubtotal() * percentualDesconto / 100;
  }

  double calcularValorEntrega(){
    return 9.99;
  }

  Future<String> finalizarOrdem() async{
    //verificar se a lista esta vasia
    print("CarrinhoModel finalizarOrdem");
    if(listaProdutosDoCarrinho == null){
      return null;
    }

    carregando = true;
    notifyListeners();

    //pego todos os valores
    double preco = calcularValorSubtotal();
    double desconto = calcularValorDesconto();
    double entrega = calcularValorEntrega();

    //criar o pedido la no firebase
    //depois que adicionei tenho que recuperar o id deste pedido atravez da referencia quando ele tem este id ja foi adicionado no banco a parada toda
    DocumentReference documentReference = await  Firestore.instance.collection("ordens").add(
      {
        "idUsuario":usuarioModel.firebaseUser.uid, //usuário que esta fazendo o pedido
        //pegar cada um dos carrinhosproduto em uma lista de produtos mapeada
        //IMPORTANTE IMPORTANTE
        "produtos": listaProdutosDoCarrinho.map((carrinhoProduto) => carrinhoProduto.paraMap()).toList(),
        "entrega": entrega,
        "preco": preco,
        "desconto": desconto,
        "total": (preco - desconto + entrega),
        "situacao":1
      }
    );

    //salvar la dentro do meu usuário
    //as ordens do usuário tem o mesmo id que fica la na ordem
    await Firestore.instance.collection("usuarios").document(usuarioModel.firebaseUser.uid).
    collection("ordens").document(documentReference.documentID).setData(
      {
        "idOrdem":documentReference.documentID
      }
    );

    //remover todos produtos do nosso carrinho só que tem que tirar também do firebase
    QuerySnapshot consulta = await Firestore.instance.collection("usuarios").document(usuarioModel.firebaseUser.uid).
    collection("carrinho").getDocuments(); //isso pega todos documento que temos no carrinho

    //vou pegar cada um dos documentos do meu carrinho
    for(DocumentSnapshot doc in consulta.documents){
      doc.reference.delete();
    }

    //limpar minha lista local
    listaProdutosDoCarrinho.clear();

    //limpar os valores
    percentualDesconto = 0;
    codigoCupom = null;

    carregando = false;
    notifyListeners();

    //retorna o codigo do pedidose deu tudo certo
    return documentReference.documentID;

  }

}