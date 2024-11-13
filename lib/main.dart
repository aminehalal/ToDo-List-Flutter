import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
  
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
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

  // Declare a TextEditingController
  final _textSearchController = TextEditingController();

  // List to hold the filtered tasks for search
  List<Map<String, dynamic>> filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList = List.from(myList); // Initialize with full list
  }

  // Function to toggle the checkbox state
  void _toggleTodoState(int index, bool? value) {
    setState(() {
      filteredList[index]['state'] = value ?? false;
    });
  }

  // Function to add a new todo item
  void _addTodo(String todoText) {
    setState(() {
      myList.add({'todo': todoText, 'state': false});
      filteredList =
          List.from(myList); // Reset filtered list to full list after adding
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
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Search method to filter tasks
  void _searchTask(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredList =
            List.from(myList); // Show full list if search query is empty
      } else {
        filteredList = myList.where((task) {
          return task['todo'].toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  // Function to delete a task
  void _deleteTask(int index) {
    setState(() {
      myList.removeAt(index); // Remove the task from the list
      filteredList = List.from(myList); // Update the filtered list
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _floatingActionButton(),
      appBar: _appBar(),
      body: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(11, 12, 11, 4),
          border: Border.all(width: 2.0, color: Colors.black26),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                controller: _textSearchController,
                decoration: InputDecoration(
                  labelText: 'Search for a task',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.all(0),
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: _searchTask,
              ),
            ),
            // ListView to display tasks
            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  return _containerTask(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _containerTask(int index) {
    return Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(41, 42, 40, 41),
                    border: Border.all(
                      color: const Color.fromARGB(255, 3, 8, 77),
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: filteredList[index]['state'],
                        onChanged: (value) {
                          _toggleTodoState(index, value);
                        },
                      ),
                      Expanded(
                        child: Text(
                          filteredList[index]['todo'],
                          style: TextStyle(
                            color: const Color.fromARGB(255, 3, 8, 77),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            decoration: filteredList[index]['state']
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _deleteTask(index),
                        icon:const Icon(
                            Icons.delete,
                          ),
                        ),
                    ],
                  ),
                );
  }

  // Floating action button
  FloatingActionButton _floatingActionButton() {
    return FloatingActionButton(
      onPressed: _showAddTodoDialog,
      backgroundColor: const Color.fromARGB(41, 42, 40, 41),
      hoverColor: const Color.fromARGB(41, 42, 40, 80),
      child: const Icon(Icons.add),
    );
  }

  // AppBar widget
  AppBar _appBar() {
    return AppBar(
      title: const Text(
        'To Do List',
        style: TextStyle(
          color: Color.fromARGB(255, 3, 8, 77),
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: const Color.fromARGB(41, 42, 40, 41),
      elevation: 0,
    );
  }
}