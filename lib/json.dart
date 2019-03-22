import 'dart:_http';
import 'dart:convert';
import 'package:http/http.dart' as http;

//backup de funcionalidades do json

void _entrar() async {
      //pegar o id do dispositovo
      //verificar se login tem tamanho de 16 ou não
      //montar os parametros
      //criar conexão json
      //montar json

      print("dentro");

      String url =
          'http://192.168.0.15:8080/TopcardMobileServer/TransacoesLojista/loginLojista';
      Map map = {
        'nome': "nome",
        'nomteste': "nome",
        'nomefds': "nome",
      };

      apiRequest(url, map).then((valor){
        print(valor);
        print("demonio do demonio");

        incrementCounter();
      });

    //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => PrincipalLojistaScreen()));

}

void incrementCounter() {
  String lUrl = 'http://192.168.0.15:8080/TopcardMobileServer/TransacoesLojista/loginLojista';
  Map lMap = {"Foo1": "Bar1", "Foo2": "Bar2"};
  String lData = json.encode(lMap);

  Map lHeaders = {"Content-type": "application/json", "Accept": "application/json"};

  http.post(lUrl, body: lData).then((http.Response lResp) {
    print("Response:");
    print(lResp.body);
  });
}

Future<String> apiRequest(String url, Map jsonMap) async {
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
  request.headers.set('content-type', 'application/json');
  request.add(utf8.encode(json.encode(jsonMap)));
  HttpClientResponse response = await request.close();
  String reply = await response.transform(utf8.decoder).join();
  httpClient.close();
  return reply;
}

