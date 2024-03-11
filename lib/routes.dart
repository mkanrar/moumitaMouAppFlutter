import 'package:flutter/material.dart';
import 'package:flutter_application/screens/add_todo_list.dart';
import 'package:flutter_application/screens/todo_list.dart';

var ongenerateRoute = (settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(
          builder: (_) => const TodoList()); // Pass it to BarPage.
      break;
    case '/add':
      return MaterialPageRoute(
          builder: (_) => const AddTodoList()); // Pass it to BarPage.
      break;
    default:
  }
};
