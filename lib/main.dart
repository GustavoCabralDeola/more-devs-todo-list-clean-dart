import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_gabarito/modules/todos/domain/usecases/update_todo_use_case.dart';

import 'modules/todos/domain/usecases/get_todos_use_case.dart';
import 'modules/todos/external/datasources/todo_api_datasource.dart';
import 'modules/todos/infra/datasources/todo_datasource.dart';
import 'modules/todos/infra/repositories/todo_repository_impl.dart';
import 'modules/todos/presenter/todos_controller.dart';
import 'modules/todos/presenter/todos_page.dart';

/// Único lugar que sabe quais implementações usar.
void main() {
  final TodoDatasource datasource = TodoApiDatasource(
    Dio(BaseOptions(
        baseUrl: 'https://todo-api-production-62d2.up.railway.app')),
  );
  final repository = TodoRepositoryImpl(datasource);
  final controller = TodosController(
    getTodosUseCase: GetTodosUseCase(repository),
    updateTodoUseCase: UpdateTodoUseCase(repository),
  )..load();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => controller,
      )
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodosPage(controller: controller),
    ),
  ));
}
