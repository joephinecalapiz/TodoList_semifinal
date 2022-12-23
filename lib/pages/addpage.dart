import 'package:flutter/material.dart';
import 'package:semifinalcalapiz/db/database.dart';


class AddPage extends StatefulWidget {
  final Map? todo;

  const AddPage({super.key, this.todo});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  List<Map<String, dynamic>> todolist = [];

  final formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  get id => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Todo"),
      ),
      body: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormField(
                    controller: _titleController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Title',
                      labelText: 'Title',
                    ),
                    validator: (value) {
                      return (value == '') ? 'Fill in the blanks' : null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Description',
                        labelText: 'Description'
                    ),
                    keyboardType: TextInputType.multiline,
                    minLines: 5,
                    maxLines: 6,

                    validator: (value) {
                      return (value == '') ? 'Fill in the blanks' : null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: ()  {
                          if (formKey.currentState!.validate()) {
                            if (id == null) {
                              addTodo();
                            }
                            setState(() {
                              _titleController.text = '';
                              _descriptionController.text = '';
                            });
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Create'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ]
      ),
    );
  }

// Insert a new data to the database
  Future<void> addTodo() async {
    await Database.createTodo( //post
        _titleController.text, _descriptionController.text);

  }



}