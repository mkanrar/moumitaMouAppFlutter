import 'package:flutter/material.dart';

class EditList extends StatefulWidget {
  const EditList({super.key});
  // final Map? todo;
  @override
  State<EditList> createState() => _EditListState();
}

class _EditListState extends State<EditList> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Data")),
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
          ElevatedButton(onPressed: () {}, child: const Text('Update'))
        ],
      ),
    );
  }
}
