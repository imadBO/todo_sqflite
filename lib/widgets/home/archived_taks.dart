import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_sqflite/cubits/database_cubit.dart';
import 'package:todo_sqflite/cubits/database_states.dart';
import 'package:todo_sqflite/models/task.dart';
import 'package:todo_sqflite/widgets/home/task_item.dart';

class ArchivedTasks extends StatelessWidget {
  const ArchivedTasks({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DatabaseCubit, DatabaseStates>(
      listener: (BuildContext context, DatabaseStates state) {},
      builder: (BuildContext context, DatabaseStates state) {
        return DatabaseCubit.get(context).loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : DatabaseCubit.get(context).tasks.isEmpty
                ? const Center(
                    child: Text(
                      'No tasks yet !',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemBuilder: (context, index) {
                      var dbCubit = DatabaseCubit.get(context);
                      Task task = dbCubit.tasks[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 2.5,
                        ),
                        child: TasksItem(
                          task: task,
                          dbCubit: dbCubit,
                          filter: 'archived',
                        ),
                      );
                    },
                    itemCount: DatabaseCubit.get(context).tasks.length,
                  );
      },
    );
  }
}
