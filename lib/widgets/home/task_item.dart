import 'package:flutter/material.dart';
import 'package:todo_sqflite/cubits/database_cubit.dart';
import 'package:todo_sqflite/models/task.dart';

class TasksItem extends StatelessWidget {
  const TasksItem({
    super.key,
    required this.task,
    required this.dbCubit,
    required this.filter,
  });

  final Task task;
  final DatabaseCubit dbCubit;
  final String filter;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id.toString()),
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        dbCubit.deleteRecordFromDatabase(task.id);
        dbCubit.tasks.remove(task);
      },
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          child: FittedBox(
            child: Text(
              task.time,
            ),
          ),
        ),
        title: Text(
          task.title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        ),
        subtitle: Text(
          task.date,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: filter == 'new',
              child: IconButton(
                onPressed: () {
                  dbCubit.updateRecordDatabase(
                    'done',
                    task.id,
                    filter,
                  );
                },
                icon: const Icon(Icons.check_box_outline_blank),
              ),
            ),
            Visibility(
              visible: filter != 'archived',
              child: IconButton(
                onPressed: () {
                  dbCubit.updateRecordDatabase(
                    'archived',
                    task.id,
                    filter,
                  );
                },
                icon: const Icon(Icons.archive_outlined),
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Colors.grey[300]!,
            width: 2,
          ),
        ),
      ),
    );
  }
}
