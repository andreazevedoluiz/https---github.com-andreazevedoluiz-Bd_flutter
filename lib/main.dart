import 'package:cadastro_sqflite/dataBase_helper.dart';
import 'package:flutter/material.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQFlite Demo',
      theme: ThemeData(
        primaryColor: Colors.teal,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  //referencia nossa classe single para gerenciar o banco de dados
  final dbhelper = DataBaseHelper.instance;
  // layout da homepage
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exemplo de CRUD básico'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            child: Text(
              'Inserir Dados',
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () {
              _inserir();
            },
          ),
          ElevatedButton(
            child: Text(
              'Consultar Dados',
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () {
              _consultar();
            },
          ),
          ElevatedButton(
            child: Text(
              'Atualizar Dados',
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () {
              _atualizar();
            },
          ),
          ElevatedButton(
            child: Text(
              'Deletar Dados',
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () {
              _deletar();
            },
          ),
        ],
      )),
    );
  }

  //Métodos dos Buttons
  void _inserir() async {
    //linha para incluir
    Map<String, dynamic> row = {
      DataBaseHelper.columNome: 'Jão inserir',
      DataBaseHelper.columIdade: 40
    };
    final id = await dbhelper.insert(row);
    print('linha inserida id: $id');
  }

  void _consultar() async {
    final todasLinhas = await dbhelper.queryAllRows();
    print('Consultar to das as linhas');
    todasLinhas.forEach((row) => print(row));
  }

  void _atualizar() async {
    //linha para atualizar
    Map<String, dynamic> row = {
      DataBaseHelper.columnId: 1,
      DataBaseHelper.columNome: 'Maria atualizar',
      DataBaseHelper.columIdade: 32
    };
    final linhasAfetadas = dbhelper.update(row);
    print('Atualizadas $linhasAfetadas linha(s)');
  }

  void _deletar() async {
    //assumindo que o numero de linhas é o id paa a ultuma linha
    final id = await dbhelper.queryRowCount();
    final linhaDeletada = await dbhelper.delete(id!);
    print('Deletada(s) $linhaDeletada linha(s): linha $id');
  }
}

