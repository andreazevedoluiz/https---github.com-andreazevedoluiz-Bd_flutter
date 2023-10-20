import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseHelper {
  static final _databaseName = "Exemplo.db";
  static final _databaseVersion = 1;
  static final table = 'contato';
  static final columnId = '_id';
  static final columNome = 'nome';
  static final columIdade = 'idade';

  //torna a classe singleton
  DataBaseHelper._privateConstructor();
  static final DataBaseHelper instance = DataBaseHelper._privateConstructor();

  //ten somente uma referencia ao banco de dados
  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  //abre o banco de dados e o cria se ele não existir
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  //codigo SQL para criar o banco de dados e a tabela
  Future _onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE $table(
  $columnId INTERGER PRIMARY KEY,
  $columNome TEXT NO NULL,
  $columIdade INTEGER NOT NULL
  )
  ''');
  }

  //Metodo Helper
  //--------------------------------------
  //Insere uma linha no banco de dados onde cada chave
  // no Map é um nome de coluna e o valor é o valor da coluna.
  // O valor de retorno é o Id da linha inserida.

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  //todas as linhas são retornadas como uma lista de mapas, onde cada mapa é uma
  //lista de valores-chave de colunas

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  //todos os métodos: insrir, consultar, atualizar e excluir, também podem ser
  //feitos usando comandos SQL brutos.
  //Esse método usa uma consulta bruta para fornecer a contagem de linha

  Future<int?> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  //Assumidos aqui aque a coluna id no mapa está definida. Os outros valores
  //das colunas serão usados para atualizar a linha.

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  //Exclui a linha especificada pelo id. O número de linhas afetadas é retornada.
  // Isso deve ser igual a 1, contato que a linha exista.

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
