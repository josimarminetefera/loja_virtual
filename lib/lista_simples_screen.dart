import 'package:flutter/material.dart';

class MyApps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Myapp",
      home: new HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: new Color(0xFF26C6DA),
      ),
      body: new ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 0.0),
            child: Text(
              "Dados da conta",
              style: TextStyle(
                fontSize: 16.0,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.all(1.0),

            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 15.0,
            ),
            title: const Text('Nome no app'),
            subtitle: const Text(
              'josima_minete',
            ),
            onTap: () {},
          ),
          ListTile(
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 15.0,
            ),
            title: const Text('Nome completo'),
            subtitle: const Text(
              'Josimar Venturim Minete',
            ),
            onTap: () {},
          ),
          ListTile(
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 15.0,
            ),
            title: const Text('E-mail'),
            subtitle: const Text(
              'josimaminete@gmail.com',
            ),
            onTap: () {},
          ),
          ListTile(
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 15.0,
            ),
            title: const Text('Celular'),
            subtitle: const Text(
              '(28)99884-1876',
            ),
            onTap: () {},
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 0.0),
            child: Text(
              "Dados do prestador",
              style: TextStyle(
                fontSize: 16.0,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
          ),
          ListTile(
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 15.0,
            ),
            title: const Text('Sou prestador'),
            subtitle: const Text(
              'Sim',
            ),
            onTap: () {},
          ),
          ListTile(
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 15.0,
            ),
            title: const Text('Tipo de profissional'),
            subtitle: const Text(
              'Cabeleireiro',
            ),
            onTap: () {},
          ),
          ListTile(
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 15.0,
            ),
            title: const Text('Serviços'),
            subtitle: const Text(
              'Lista de serviços que o prestador oferece a seus clientes',
            ),
            onTap: () {},
          ),
          ListTile(
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 15.0,
            ),
            title: const Text('Tempo para agendamentos'),
            subtitle: const Text(
              'Tempo médio de agendamentos é de 30 min',
            ),
            onTap: () {},
          ),
          ListTile(
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 15.0,
            ),
            title: const Text('Tempo de disponibilidade'),
            subtitle: const Text(
              'Horário que o prestador deixa sua agenda aberta para seus clientes',
            ),
            onTap: () {},
          ),
          ListTile(
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 15.0,
            ),
            title: const Text('Endereço completo'),
            subtitle: const Text(
              'Endereço de onde o prestador oferece seus serviços',
            ),
            onTap: () {},
          ),
          ListTile(
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 15.0,
            ),
            title: const Text('Nome da empresa'),
            subtitle: const Text(
              'Nome da empresa que o prestador trabalha',
            ),
            onTap: () {},
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 0.0),
            child: Text(
              "Configurações",
              style: TextStyle(
                fontSize: 16.0,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
          ),
          ListTile(
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 15.0,
            ),
            title: const Text('Alterar senha'),
            subtitle: const Text(
              'Alterar a senha para acesso a aplicação',
            ),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Sair'),
            onTap: () {},
          ),
          SizedBox(
            height: 30.0,
          ),
        ],
      ),
    );
  }
}
