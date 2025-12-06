import 'package:drift/drift.dart';
import 'package:flash_mastery/data/local/app_database_connection.dart';

part 'app_database.g.dart';

class Folders extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get color => text().nullable()();
  IntColumn get deckCount => integer().withDefault(const Constant(0))();
  TextColumn get parentId => text().nullable().references(Folders, #id, onDelete: KeyAction.cascade)();
  IntColumn get subFolderCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

class Decks extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get folderId => text().nullable().references(Folders, #id, onDelete: KeyAction.setNull)();
  IntColumn get cardCount => integer().withDefault(const Constant(0))();
  TextColumn get type => text().withDefault(const Constant('VOCABULARY'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

class Flashcards extends Table {
  TextColumn get id => text()();
  TextColumn get deckId => text().references(Decks, #id, onDelete: KeyAction.cascade)();
  TextColumn get question => text()();
  TextColumn get answer => text()();
  TextColumn get hint => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

@DriftDatabase(tables: [Folders, Decks, Flashcards])
class AppDatabase extends _$AppDatabase {
  AppDatabase._(super.executor);

  /// Singleton instance to avoid multiple DB openings (especially on web).
  static final AppDatabase instance = AppDatabase._(openConnection());

  factory AppDatabase() => instance;

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(folders, folders.parentId);
            await m.addColumn(folders, folders.subFolderCount);
          }
          if (from < 3) {
            await m.addColumn(decks, decks.type);
          }
          if (from < 4) {
            // Fix any existing null type values from previous migrations
            await customStatement(
              "UPDATE decks SET type = 'VOCABULARY' WHERE type IS NULL OR type = ''",
            );
          }
        },
      );
}
