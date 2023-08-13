import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_sqflite/cubits/bottom_nav_bar_cubit.dart';
import 'package:todo_sqflite/cubits/bottom_nav_bar_states.dart';
import 'package:todo_sqflite/cubits/database_cubit.dart';
import 'package:todo_sqflite/cubits/database_states.dart';
import 'package:todo_sqflite/widgets/home/custom_form.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final TextEditingController titleController = TextEditingController();

  final TextEditingController timeController = TextEditingController();

  final TextEditingController dateController = TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => BottomNavBarCubit(),
      child: BlocConsumer<BottomNavBarCubit, BottomNavBarStates>(
        listener: (context, state) {},
        builder: (context, state) {
          BottomNavBarCubit navCubit = BottomNavBarCubit.get(context);
          return BlocProvider(
            create: (BuildContext context) => DatabaseCubit(),
            child: BlocConsumer<DatabaseCubit, DatabaseStates>(
              listener: (BuildContext context, state) {},
              builder: (BuildContext context, DatabaseStates state) {
                return Scaffold(
                  key: scaffoldKey,
                  appBar: AppBar(
                    title: Text(navCubit.titles[navCubit.index]),
                  ),
                  body: navCubit.pages[navCubit.index],
                  floatingActionButton: Visibility(
                    visible: navCubit.index == 0,
                    child: FloatingActionButton(
                      mini: true,
                      onPressed: () async {
                        if (DatabaseCubit.get(context).isShown) {
                          if (formKey.currentState!.validate()) {
                            Navigator.pop(context);
                            await DatabaseCubit.get(context).insertToDatabase(
                              titleController.text,
                              timeController.text,
                              dateController.text,
                              'new',
                            );
                            formKey.currentState!.reset();
                          }
                        } else {
                            DatabaseCubit.get(context).toggleShown();
                          scaffoldKey.currentState!
                              .showBottomSheet(
                                (context) {
                                  return CustomForm(
                                    formKey: formKey,
                                    titleController: titleController,
                                    timeController: timeController,
                                    dateController: dateController,
                                  );
                                },
                              )
                              .closed
                              .then((value) {
                                  DatabaseCubit.get(context).toggleShown();
                              });
                        }
                      },
                      child: DatabaseCubit.get(context).isShown == false
                          ? const Icon(Icons.edit)
                          : const Icon(Icons.add),
                    ),
                  ),
                  bottomNavigationBar: BottomNavigationBar(
                    currentIndex: navCubit.index,
                    onTap: (value) {
                      navCubit.updateIndex(value);
                      switch (value) {
                        case 0:
                          DatabaseCubit.get(context).fetchFromDatabase(
                            DatabaseCubit.get(context).db!,
                            'new',
                          );
                          break;
                        case 1:
                          DatabaseCubit.get(context).fetchFromDatabase(
                            DatabaseCubit.get(context).db!,
                            'done',
                          );
                          break;
                        case 2:
                          DatabaseCubit.get(context).fetchFromDatabase(
                            DatabaseCubit.get(context).db!,
                            'archived',
                          );
                          break;
                      }
                    },
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.menu),
                        label: 'New Tasks',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.check_circle_outline),
                        label: 'Done Tasks',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.archive_outlined),
                        label: 'Archived Tasks',
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
