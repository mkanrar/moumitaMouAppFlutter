import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application/screens/add_todo_list.dart';
import 'package:flutter_application/screens/edit_todo_list.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List items = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My List Data"),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchData,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final itemss = items[index] as Map;
              final id = itemss['_id'] as String;
              return ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(itemss['title']),
                  subtitle: Text(itemss['description']),
                  trailing: PopupMenuButton(
                    onSelected: (value) => {
                      if (value == 'delete') {deleteItem(id)},
                      if (value == 'edit') {navigateToEditPage(itemss)}
                    },
                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem(value: 'edit', child: Text("Edit")),
                        const PopupMenuItem(
                            value: 'delete', child: Text("Delete"))
                      ];
                    },
                  ));
            },
          ),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateToAddPage, label: const Text("Add Data")),
    );
  }

  Future<void> navigateToAddPage() async {
    // final route = MaterialPageRoute(builder: (context) => AddTodoList());
    // Navigator.push(route);

    // await Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (context) => const AddTodoList()));

    Navigator.pushNamed(context, '/add');
  }

  void navigateToEditPage(Map item) {
    final route = MaterialPageRoute(
      builder: (context) => const EditList(),
    );
    Navigator.push(context, route);

    // Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (context) => EditList(todo: item)));
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    const url = "https://api.nstack.in/v1/todos?page=1&limit=10";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteItem(id) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure to delete?'),
        content: const Text('This action will permanently delete this data'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (result!) {
      final url = 'https://api.nstack.in/v1/todos/$id';
      final uri = Uri.parse(url);
      final response = await http.delete(uri);
      // print(response.body);
      if (response.statusCode == 200) {
        fetchData();
      }
    }
  }
}
