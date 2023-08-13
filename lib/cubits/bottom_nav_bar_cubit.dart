import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_sqflite/cubits/bottom_nav_bar_states.dart';
import 'package:todo_sqflite/widgets/home/archived_taks.dart';
import 'package:todo_sqflite/widgets/home/done_tasks.dart';
import 'package:todo_sqflite/widgets/home/new_tasks.dart';

class BottomNavBarCubit extends Cubit<BottomNavBarStates>{
  BottomNavBarCubit():super(InitialState());

  int index = 0;
  List<Widget> pages = const [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];
  List<String> titles = [
    'New tasks',
    'Done tasks',
    'Archived tasks',
  ];

  static BottomNavBarCubit get(context) => BlocProvider.of(context);

  void updateIndex(int value){
    index = value;
    emit(ChangedState());
  }

}