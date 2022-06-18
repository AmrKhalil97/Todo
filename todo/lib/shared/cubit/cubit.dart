import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/archievedTasks.dart';
import 'package:todo/modules/doneTasks.dart';
import 'package:todo/modules/tasks.dart';
import 'package:todo/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  int currentIndex = 0;
  List<Widget> screen = [
    newTasksScreen(),
    doneTasksScreen(),
    archeivedTasksScreen()
  ];
  List<String> title = ['New Tasks', 'Done Tasks', 'Archived Tasks'];
  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  AppCubit() : super(AppIntialState());

  static AppCubit get(context) {
    return BlocProvider.of(context);
  }

  // ignore: non_constant_identifier_names
  void ChangeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase() {
    openDatabase(
      'TODO1Application.db',
      version: 1,
      onCreate: (database, version) async {
        print('database created');
        await database
            .execute(
                'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) => print('table created'))
            .catchError((error) {
          print('error when creating table ${error.toString()}');
        });
      },
      onOpen: (database) {
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());

      getDataFromDatabase(database);
    });
  }

  insertToDatabase({@required title, @required date, @required time}) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
              'Insert into tasks (title,date,time,status) values ("$title","$date","$time","new")')
          .then((value) {
        print('Inserted successfully');
        emit(AppInsertToDatabaseState());

        getDataFromDatabase(database);
      }).catchError((onError) {
        print('ERROR in inserting record {$onError.toString()}');
      });
    });
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    archiveTasks = [];
    doneTasks = [];
    database.rawQuery('Select * from tasks').then((value) {
      emit(AppGetDatabaseState());
      value.forEach((element) {
        if (element['status'] == 'done') {
          doneTasks.add(element);
        } else if (element['status'] == 'archive') {
          archiveTasks.add(element);
        } else {
          newTasks.add(element);
        }
      });
    }).catchError((onError) {
      print('$onError');
    });
  }

  // ignore: non_constant_identifier_names
  bool Isbottomsheetshown = false;
  IconData fabicon = Icons.edit;

  // ignore: non_constant_identifier_names
  void ChangeBottomSheet({required icon, required bool bottomsheet}) {
    fabicon = icon;
    Isbottomsheetshown = bottomsheet;
    emit(AppChangeBottomSheetState());
  }

  // ignore: non_constant_identifier_names
  void UpdateDatabase({required int id, required String status}) {
    database.rawUpdate('Update tasks set status = ? where id = ?',
        ['$status', id]).then((value) {
      emit(AppUpdateDatabaseState());

      getDataFromDatabase(database);
    });
  }

  void deleteDatabase({required int id}) {
    database.rawDelete('delete from tasks where id = ? ', [id]).then((value) {
      emit(AppDeleteDatabaseState());

      getDataFromDatabase(database);
    });
  }
}
