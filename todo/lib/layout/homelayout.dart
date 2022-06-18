import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/shared/components.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

// ignore: camel_case_types

// ignore: camel_case_types
class home extends StatelessWidget {
  final taskTimeController = TextEditingController();
  final dateController = TextEditingController();
  final titleController = TextEditingController();
  bool press = true;
  GlobalKey<ScaffoldState> _ScaffoldKey = new GlobalKey<ScaffoldState>();
  var formkey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (BuildContext context, AppStates state) {
        if (state is AppInsertToDatabaseState) {
          Navigator.pop(context);
        }
      }, builder: (BuildContext context, AppStates state) {
        AppCubit c = AppCubit.get(context);
        return Scaffold(
          key: _ScaffoldKey,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(c.title[c.currentIndex]),
          ),
          body: c.screen[c.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: c.currentIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (value) {
              c.ChangeIndex(value);
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
              BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Done'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.archive), label: 'Archived'),
            ],
          ),
          floatingActionButton: Container(
            height: 50,
            width: 50,
            child: FloatingActionButton(
              onPressed: () {
                if (c.Isbottomsheetshown) {
                  if (formkey.currentState!.validate()) {
                    c.insertToDatabase(
                        title: titleController.text,
                        date: dateController.text,
                        time: taskTimeController.text);
                  }
                } else {
                  _ScaffoldKey.currentState!
                      .showBottomSheet((context) => Container(
                            width: double.infinity,
                            color: Colors.grey[200],
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Form(
                                key: formkey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    defaultTextField(
                                        controller: titleController,
                                        labelText: 'Task title',
                                        prefix: Icons.title,
                                        textValidator: ((value) {
                                          if (value!.isEmpty) {
                                            return 'please enter value';
                                          }
                                          return null;
                                        })),
                                    SizedBox(
                                      height: 17,
                                    ),
                                    defaultTextField(
                                        controller: taskTimeController,
                                        labelText: 'Task time',
                                        ontap: () {
                                          showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now())
                                              .then((value) {
                                            taskTimeController.text = value!
                                                .format(context)
                                                .toString();
                                            print(value.toString());
                                          }).catchError((onError) {
                                            print(' error is $onError');
                                          });
                                        },
                                        prefix: Icons.watch_later_rounded,
                                        textValidator: ((value) {
                                          if (value!.isEmpty) {
                                            return 'please enter value';
                                          }
                                          return null;
                                        })),
                                    SizedBox(
                                      height: 17,
                                    ),
                                    defaultTextField(
                                        controller: dateController,
                                        labelText: 'Date time',
                                        ontap: () {
                                          showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime.parse(
                                                      '2024-01-01'))
                                              .then((value) {
                                            dateController.text =
                                                DateFormat.MMMEd()
                                                    .format(value!);
                                          }).catchError((onError) {
                                            print(' error is $onError');
                                          });
                                        },
                                        prefix: Icons.date_range_outlined,
                                        textValidator: ((value) {
                                          if (value!.isEmpty) {
                                            return 'please enter value';
                                          }
                                          return null;
                                        }))
                                  ],
                                ),
                              ),
                            ),
                          ))
                      .closed
                      .then((value) => {
                            c.ChangeBottomSheet(
                                icon: Icons.edit, bottomsheet: false)
                          });
                  c.ChangeBottomSheet(icon: Icons.add, bottomsheet: true);
                }
              },
              child: Icon(
                c.fabicon,
              ),
            ),
          ),
        );
      }),
    );
  }
}
