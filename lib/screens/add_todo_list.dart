import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoList extends StatefulWidget {
  const AddTodoList({super.key});

  @override
  State<AddTodoList> createState() => _AddTodoListState();
}

class _AddTodoListState extends State<AddTodoList> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Data")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // TextField(decoration: InputDecoration(hintText: "First Name")),
          // SizedBox(height: 20),
          // TextField(decoration: InputDecoration(hintText: "Last Name")),
          // SizedBox(height: 20),
          TextField(
              decoration: const InputDecoration(hintText: "Title"),
              controller: titleController),
          const SizedBox(height: 20),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: "Description"),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          ElevatedButton(onPressed: submitClick, child: const Text('Submit'))
        ],
      ),
    );
  }

  Future<void> submitClick() async {
    final title = titleController.text;
    final desc = descriptionController.text;
    final swaggerReqBody = {
      "title": title,
      "description": desc,
      "is_completed": false
    };
    const url = "https://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(swaggerReqBody),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 201) {
      showSuccesMessage("Added successfully");
    } else {
      showErrMessage("Error while adding");
    }
  }

  void showSuccesMessage(String message) {
    final snackbar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void showErrMessage(String message) {
    final snackbar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
