import 'package:moor_flutter/moor_flutter.dart';

part 'developers_database.g.dart';

class Developers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 60)();
  IntColumn get age => integer()();
  TextColumn get heading => text()();
}

@UseMoor(tables: [Developers], daos: [DevelopersDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'db.sql', logStatements: true));

  @override
  int get schemaVersion => 1;
}

@UseDao(tables: [Developers])
class DevelopersDao extends DatabaseAccessor<AppDatabase>
    with _$DevelopersDaoMixin {
  final AppDatabase appDatabase;

  DevelopersDao(this.appDatabase) : super(appDatabase);

  Future<List<Developer>> getAllDevelopers() => select(developers).get();

  Stream<List<Developer>> watchAllDevelopers() => select(developers).watch();

  Stream<List<Developer>> watchAllFiltersDevelopers(
      {String name, String heading}) {
    return (select(developers)
          ..where((tbl) {

            if(name != null && name.isNotEmpty) {
              return tbl.name.like("$name%");
            }

            if(heading != null && heading.isNotEmpty) {
             return tbl.heading.equals(heading);
            }

            if(heading != null && heading.isNotEmpty && name != null && name.isNotEmpty) {
              return tbl.name.like("$name%");
            }

            return null;
          }
          ))
        .watch();
  }

  Future insertDevelopers(Insertable<Developer> developer) =>
      into(developers).insert(developer);

  Future updateDevelopers(Insertable<Developer> developer) =>
      update(developers).replace(developer);

  Future deleteDevelopers(Insertable<Developer> developer) =>
      delete(developers).delete(developer);
}
