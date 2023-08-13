import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_sqflite/cubits/database_states.dart';
import 'package:todo_sqflite/models/task.dart';

class DatabaseCubit extends Cubit<DatabaseStates> {
  DatabaseCubit() : super(InitialState()) {
    createDatabase();
  }

  Database? db;
  List<Task> tasks = [];
  bool isShown = false;
  bool loading = false;

  static DatabaseCubit get(context) => BlocProvider.of(context);

  void toggleShown() {
    isShown = !isShown;
    emit(ChangeShownState());
  }

  Future<void> createDatabase() async {
    db = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) {
        print('Database created');
        db
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT, status TEXT)')
            .then((_) {
          print('Table created');
        }).catchError((error) {
          print('An error occurred when creating table :\n$error');
        });
      },
      onOpen: (db) {
        print('Database opned');
      },
    );
    fetchFromDatabase(db!, 'new');
    emit(CreatedState());
  }

  Future<void> insertToDatabase(
    String title,
    String time,
    String date,
    String filter,
  ) async {
    try {
      await db!.transaction((txn) async {
        await txn.rawInsert(
          'INSERT INTO tasks(title, time ,date, status) VALUES(\'$title\', \'$time\', \'$date\', \'new\')',
        );
      });
    } catch (error) {
      print('An error occurred when inserting to database $error');
    }
    emit(InsertedState());
    fetchFromDatabase(db!, filter);
  }

  Future<void> fetchFromDatabase(Database db, String filter) async {
    loading = true;
    emit(ChangeLoadingState());
    tasks = [];
    await db
        .rawQuery('SELECT * FROM tasks WHERE status = \'$filter\'')
        .then((data) {
      for (Map element in data) {
        tasks.add(Task.fromMap(element));
      }
    }).catchError((error) {
      print('An error occurred while fetching data from database $error');
    });
    loading = false;
    emit(FetchedState());
  }

  Future<void> updateRecordDatabase(
    String status,
    int id,
    String filter,
  ) async {
    try {
      int count = await db!.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        [status, id],
      );
      await fetchFromDatabase(db!, filter);
      print('updated: $count');
    } catch (error) {
      print('An error occurred while updating record $error');
    }
    emit(UpdatedState());
  }

  Future<void> deleteRecordFromDatabase(int id) async {
    try {
      int count = await db!.rawDelete('DELETE FROM Tasks WHERE id = ?', [id]);
      print('Deleted: $count');
    } catch (error) {
      print('An error occurred while deleting the record $error');
    }
    emit(DeletedState());
  }
}
