import 'package:flutter/material.dart';
import 'package:semifinalcalapiz/db/database.dart';
import 'package:semifinalcalapiz/pages/addpage.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {

  List<Map<String, dynamic>> todolist = [];

  void _getData() async {
    final todo = await Database.getTodos();
    setState(() {
      todolist = todo;
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
            Icons.task,
            color: Colors.black,
            size: 35
        ),
        title: const Text('To Do'),
      ),
      body: ListView.builder(
          itemCount: todolist.length,
          itemBuilder: (context, index) {
            return Dismissible(
                key: UniqueKey(), //stores every widget state as unique.
                background: slideDelete(),
                onDismissed: (direction) async {
                  setState ((){
                    deleteTodo(todolist[index]['id']);
                  });
                },
                child: Card(
                    color: Colors.blueGrey[300],
                    margin: const EdgeInsets.all(7),

                    child: ListTile(
                      leading: const Icon(
                          Icons.check_box_outlined ,
                          color: Colors.red,
                          size: 30
                      ),
                      title: Text(todolist[index]['title'],
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                          )
                      ),
                      subtitle: Text(todolist[index]['description'],
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black
                          )
                      ),
                      trailing: IconButton(
                          color: Colors.green[700],
                          icon: const Icon(Icons.edit, size: 30),
                          onPressed: () {
                            updatePage(todolist[index]['id']);
                          }
                      ),

                    )
                )
            );
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: goToAdd,

        label: const Text('add todo'),
      ),
    );
  }

  void goToAdd() {
    final route = MaterialPageRoute(builder: (context) => const AddPage());
    Navigator.push(context, route);
  }

  void deleteTodo(int id) {
    Database.deleteTodo(id);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully deleted!'),
            backgroundColor: Colors.green));
    _getData();
  }

  Widget slideDelete() {
    return Container(
      color: Colors.red,
      child: Align(alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const <Widget>[
            Text(
              " Delete Todo List",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(width: 20),
          ],
        ),
      ),
    );
  }

  final formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void updatePage(int? id) async {

    if (id != null) {
      final editData = todolist.firstWhere((element) => element['id'] == id);
      _titleController.text = editData['title'];
      _descriptionController.text = editData['description'];
    }
    else {
      _titleController.text = "";
      _descriptionController.text = "";
    }

    showModalBottomSheet(
        context: context,
        elevation: 15,
        isScrollControlled: true,
        builder: (_) =>
            Scaffold(
                appBar: AppBar(
                  title: const Text('Update To Do'),
                ),
                body: ListView(
                    padding: const EdgeInsets.only(top: 35),
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
                            const SizedBox(height: 20),

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
                                      if (id != null) {
                                        updateTodo(id);
                                      }

                                      setState(() {
                                        _titleController.text = '';
                                        _descriptionController.text = '';
                                      });

                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const Text('Update'),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ]
                )
            )
    );
  }

  Future<void> updateTodo(int id) async {
    await Database.updateTodo(
        id, _titleController.text, _descriptionController.text);

  }

}