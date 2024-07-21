// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $ApplicationDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $ApplicationDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $ApplicationDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<ApplicationDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorApplicationDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $ApplicationDatabaseBuilderContract databaseBuilder(String name) =>
      _$ApplicationDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $ApplicationDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$ApplicationDatabaseBuilder(null);
}

class _$ApplicationDatabaseBuilder
    implements $ApplicationDatabaseBuilderContract {
  _$ApplicationDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $ApplicationDatabaseBuilderContract addMigrations(
      List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $ApplicationDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<ApplicationDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$ApplicationDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$ApplicationDatabase extends ApplicationDatabase {
  _$ApplicationDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  AirplaneDao? _airplaneDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `airplanes` (`airplaneId` INTEGER, `airplaneType` TEXT NOT NULL, `numberOfPassengers` INTEGER NOT NULL, `maxSpeed` INTEGER NOT NULL, `range` INTEGER NOT NULL, PRIMARY KEY (`airplaneId`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  AirplaneDao get airplaneDao {
    return _airplaneDaoInstance ??= _$AirplaneDao(database, changeListener);
  }
}

class _$AirplaneDao extends AirplaneDao {
  _$AirplaneDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _airplaneInsertionAdapter = InsertionAdapter(
            database,
            'airplanes',
            (Airplane item) => <String, Object?>{
                  'airplaneId': item.airplaneId,
                  'airplaneType': item.airplaneType,
                  'numberOfPassengers': item.numberOfPassengers,
                  'maxSpeed': item.maxSpeed,
                  'range': item.range
                },
            changeListener),
        _airplaneUpdateAdapter = UpdateAdapter(
            database,
            'airplanes',
            ['airplaneId'],
            (Airplane item) => <String, Object?>{
                  'airplaneId': item.airplaneId,
                  'airplaneType': item.airplaneType,
                  'numberOfPassengers': item.numberOfPassengers,
                  'maxSpeed': item.maxSpeed,
                  'range': item.range
                },
            changeListener),
        _airplaneDeletionAdapter = DeletionAdapter(
            database,
            'airplanes',
            ['airplaneId'],
            (Airplane item) => <String, Object?>{
                  'airplaneId': item.airplaneId,
                  'airplaneType': item.airplaneType,
                  'numberOfPassengers': item.numberOfPassengers,
                  'maxSpeed': item.maxSpeed,
                  'range': item.range
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Airplane> _airplaneInsertionAdapter;

  final UpdateAdapter<Airplane> _airplaneUpdateAdapter;

  final DeletionAdapter<Airplane> _airplaneDeletionAdapter;

  @override
  Future<List<Airplane>> getAllAirplanes() async {
    return _queryAdapter.queryList('SELECT * FROM airplanes',
        mapper: (Map<String, Object?> row) => Airplane(
            airplaneId: row['airplaneId'] as int?,
            airplaneType: row['airplaneType'] as String,
            numberOfPassengers: row['numberOfPassengers'] as int,
            maxSpeed: row['maxSpeed'] as int,
            range: row['range'] as int));
  }

  @override
  Stream<Airplane?> getAirplaneById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM airplanes WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Airplane(
            airplaneId: row['airplaneId'] as int?,
            airplaneType: row['airplaneType'] as String,
            numberOfPassengers: row['numberOfPassengers'] as int,
            maxSpeed: row['maxSpeed'] as int,
            range: row['range'] as int),
        arguments: [id],
        queryableName: 'airplanes',
        isView: false);
  }

  @override
  Future<void> insertAirplane(Airplane airplane) async {
    await _airplaneInsertionAdapter.insert(airplane, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateAirplane(Airplane airplane) async {
    await _airplaneUpdateAdapter.update(airplane, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteAirplane(Airplane airplane) async {
    await _airplaneDeletionAdapter.delete(airplane);
  }
}
