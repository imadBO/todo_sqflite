import 'package:flutter/material.dart';
import 'package:todo_sqflite/shared/custom_form_field.dart';
import 'package:intl/intl.dart';

class CustomForm extends StatelessWidget {
  const CustomForm({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.timeController,
    required this.dateController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController timeController;
  final TextEditingController dateController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        color: Colors.grey[200],
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomFormField(
                label: 'Title',
                titleController: titleController,
                type: TextInputType.text,
                validator: (String? value) {
                  if (titleController.text.isEmpty) {
                    return 'Title must not be empty';
                  } else {
                    return null;
                  }
                },
                prefixIcon: Icons.title,
              ),
              const SizedBox(height: 10),
              CustomFormField(
                label: 'Time',
                titleController: timeController,
                readOnly: true,
                type: TextInputType.datetime,
                prefixIcon: Icons.watch_later_outlined,
                validator: (String? value) {
                  if (timeController.text.isEmpty) {
                    return 'Time must not be empty';
                  } else {
                    return null;
                  }
                },
                onTap: () async {
                  var time = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());
                  if (context.mounted) {
                    timeController.text = time!.format(context);
                  }
                },
              ),
              const SizedBox(height: 10),
              CustomFormField(
                label: 'Date',
                titleController: dateController,
                readOnly: true,
                type: TextInputType.datetime,
                prefixIcon: Icons.calendar_month_outlined,
                validator: (String? value) {
                  if (dateController.text.isEmpty) {
                    return 'Date must not be empty';
                  } else {
                    return null;
                  }
                },
                onTap: () async {
                  var date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 15)),
                  );
                  dateController.text = DateFormat.yMMMd().format(date!);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
