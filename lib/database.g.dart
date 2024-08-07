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

  FlightDao? _flightDaoInstance;

  CustomerDao? _customerDaoInstance;

  ReservationDao? _reservationDaoInstance;

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
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `flights` (`flightId` INTEGER NOT NULL, `destinationCity` TEXT NOT NULL, `departureCity` TEXT NOT NULL, `departureTime` TEXT NOT NULL, `arrivalTime` TEXT NOT NULL, PRIMARY KEY (`flightId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `customers` (`customerId` INTEGER NOT NULL, `firstName` TEXT NOT NULL, `lastName` TEXT NOT NULL, `address` TEXT NOT NULL, `birthday` TEXT NOT NULL, PRIMARY KEY (`customerId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `reservations` (`id` INTEGER NOT NULL, `name` TEXT NOT NULL, `customerId` INTEGER NOT NULL, `flightId` INTEGER NOT NULL, `reservationDate` TEXT NOT NULL, `destination` TEXT NOT NULL, `departureTime` TEXT NOT NULL, `arrivalTime` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  AirplaneDao get airplaneDao {
    return _airplaneDaoInstance ??= _$AirplaneDao(database, changeListener);
  }

  @override
  FlightDao get flightDao {
    return _flightDaoInstance ??= _$FlightDao(database, changeListener);
  }

  @override
  CustomerDao get customerDao {
    return _customerDaoInstance ??= _$CustomerDao(database, changeListener);
  }

  @override
  ReservationDao get reservationDao {
    return _reservationDaoInstance ??=
        _$ReservationDao(database, changeListener);
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

class _$FlightDao extends FlightDao {
  _$FlightDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _flightInsertionAdapter = InsertionAdapter(
            database,
            'flights',
            (Flight item) => <String, Object?>{
                  'flightId': item.flightId,
                  'destinationCity': item.destinationCity,
                  'departureCity': item.departureCity,
                  'departureTime': item.departureTime,
                  'arrivalTime': item.arrivalTime
                },
            changeListener),
        _flightUpdateAdapter = UpdateAdapter(
            database,
            'flights',
            ['flightId'],
            (Flight item) => <String, Object?>{
                  'flightId': item.flightId,
                  'destinationCity': item.destinationCity,
                  'departureCity': item.departureCity,
                  'departureTime': item.departureTime,
                  'arrivalTime': item.arrivalTime
                },
            changeListener),
        _flightDeletionAdapter = DeletionAdapter(
            database,
            'flights',
            ['flightId'],
            (Flight item) => <String, Object?>{
                  'flightId': item.flightId,
                  'destinationCity': item.destinationCity,
                  'departureCity': item.departureCity,
                  'departureTime': item.departureTime,
                  'arrivalTime': item.arrivalTime
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Flight> _flightInsertionAdapter;

  final UpdateAdapter<Flight> _flightUpdateAdapter;

  final DeletionAdapter<Flight> _flightDeletionAdapter;

  @override
  Future<List<Flight>> getAllFlights() async {
    return _queryAdapter.queryList('SELECT * FROM flights',
        mapper: (Map<String, Object?> row) => Flight(
            row['flightId'] as int,
            row['destinationCity'] as String,
            row['departureCity'] as String,
            row['departureTime'] as String,
            row['arrivalTime'] as String));
  }

  @override
  Stream<Flight?> getFlightById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM flights WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Flight(
            row['flightId'] as int,
            row['destinationCity'] as String,
            row['departureCity'] as String,
            row['departureTime'] as String,
            row['arrivalTime'] as String),
        arguments: [id],
        queryableName: 'flights',
        isView: false);
  }

  @override
  Future<void> insertFlight(Flight flight) async {
    await _flightInsertionAdapter.insert(flight, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateFlight(Flight flight) {
    return _flightUpdateAdapter.updateAndReturnChangedRows(
        flight, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteFlight(Flight flight) {
    return _flightDeletionAdapter.deleteAndReturnChangedRows(flight);
  }
}

class _$CustomerDao extends CustomerDao {
  _$CustomerDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _customerInsertionAdapter = InsertionAdapter(
            database,
            'customers',
            (Customer item) => <String, Object?>{
                  'customerId': item.customerId,
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'address': item.address,
                  'birthday': item.birthday
                }),
        _customerUpdateAdapter = UpdateAdapter(
            database,
            'customers',
            ['customerId'],
            (Customer item) => <String, Object?>{
                  'customerId': item.customerId,
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'address': item.address,
                  'birthday': item.birthday
                }),
        _customerDeletionAdapter = DeletionAdapter(
            database,
            'customers',
            ['customerId'],
            (Customer item) => <String, Object?>{
                  'customerId': item.customerId,
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'address': item.address,
                  'birthday': item.birthday
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Customer> _customerInsertionAdapter;

  final UpdateAdapter<Customer> _customerUpdateAdapter;

  final DeletionAdapter<Customer> _customerDeletionAdapter;

  @override
  Future<List<Customer>> getAllCustomers() async {
    return _queryAdapter.queryList('SELECT * FROM customers',
        mapper: (Map<String, Object?> row) => Customer(
            row['customerId'] as int,
            row['firstName'] as String,
            row['lastName'] as String,
            row['address'] as String,
            row['birthday'] as String));
  }

  @override
  Future<void> insertCustomer(Customer customer) async {
    await _customerInsertionAdapter.insert(customer, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateCustomer(Customer customer) async {
    await _customerUpdateAdapter.update(customer, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteCustomer(Customer customer) async {
    await _customerDeletionAdapter.delete(customer);
  }
}

class _$ReservationDao extends ReservationDao {
  _$ReservationDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _reservationInsertionAdapter = InsertionAdapter(
            database,
            'reservations',
            (Reservation item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'customerId': item.customerId,
                  'flightId': item.flightId,
                  'reservationDate': item.reservationDate,
                  'destination': item.destination,
                  'departureTime': item.departureTime,
                  'arrivalTime': item.arrivalTime
                },
            changeListener),
        _reservationDeletionAdapter = DeletionAdapter(
            database,
            'reservations',
            ['id'],
            (Reservation item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'customerId': item.customerId,
                  'flightId': item.flightId,
                  'reservationDate': item.reservationDate,
                  'destination': item.destination,
                  'departureTime': item.departureTime,
                  'arrivalTime': item.arrivalTime
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Reservation> _reservationInsertionAdapter;

  final DeletionAdapter<Reservation> _reservationDeletionAdapter;

  @override
  Future<List<Reservation>> getAllReservations() async {
    return _queryAdapter.queryList('SELECT * FROM reservations',
        mapper: (Map<String, Object?> row) => Reservation(
            id: row['id'] as int,
            name: row['name'] as String,
            customerId: row['customerId'] as int,
            flightId: row['flightId'] as int,
            reservationDate: row['reservationDate'] as String,
            destination: row['destination'] as String,
            departureTime: row['departureTime'] as String,
            arrivalTime: row['arrivalTime'] as String));
  }

  @override
  Stream<Reservation?> getReservationById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM reservations WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Reservation(
            id: row['id'] as int,
            name: row['name'] as String,
            customerId: row['customerId'] as int,
            flightId: row['flightId'] as int,
            reservationDate: row['reservationDate'] as String,
            destination: row['destination'] as String,
            departureTime: row['departureTime'] as String,
            arrivalTime: row['arrivalTime'] as String),
        arguments: [id],
        queryableName: 'reservations',
        isView: false);
  }

  @override
  Future<void> insertReservation(Reservation reservation) async {
    await _reservationInsertionAdapter.insert(
        reservation, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteReservation(Reservation reservation) async {
    await _reservationDeletionAdapter.delete(reservation);
  }
}
