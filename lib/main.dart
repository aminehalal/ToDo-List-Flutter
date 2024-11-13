import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'To Do List',
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({super.key});
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  // List to hold todo items with their state (completed or not)
  List<Map<String, dynamic>> myList = [
    {'todo': 'Learning Flutter', 'state': true},
    {'todo': 'Create a To Do List in Flutter', 'state': false},
  ];

  // Function to toggle the checkbox state
  void _toggleTodoState(int index, bool? value) {
    setState(() {
      myList[index]['state'] = value ?? false;
    });
  }

  // Function to add a new todo item
  void _addTodo(String todoText) {
    setState(() {
      myList.add({'todo': todoText, 'state': false}); // Add a new todo with default state as false
    });
  }

  // Function to show the Add Todo dialog
  void _showAddTodoDialog() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add a Task'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter your task here'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String todoText = controller.text.trim();
                if (todoText.isNotEmpty) {
                  _addTodo(todoText); // Add the todo to the list
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog, // Show the dialog when pressed
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text(
          'To Do List',
          style: TextStyle(
            color: Color.fromARGB(255, 3, 8, 77),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(41, 42, 40, 41),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(11, 12, 11, 4),
          border: Border.all(width: 2.0, color: Colors.black26),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: myList.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(41, 42, 40, 41),
                border: Border.all(color: const Color.fromARGB(255, 3, 8, 77)),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: myList[index]['state'],
                    onChanged: (value) {
                      _toggleTodoState(index, value);
                    },
                  ),
                  Expanded( // To prevent overflow if the text is long
                    child: Text(
                      myList[index]['todo'],
                      style: TextStyle(
                        color: const Color.fromARGB(255, 3, 8, 77),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        decoration: myList[index]['state']
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
