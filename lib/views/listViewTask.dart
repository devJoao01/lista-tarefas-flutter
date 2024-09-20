import 'package:flutter/material.dart';
import 'package:projeto/models/teste_model.dart';
import 'package:projeto/services/task_service.dart';
import 'package:projeto/views/form_view_tasks.dart';

class ListViewTasks extends StatefulWidget {
  const ListViewTasks({super.key});

  @override
  State<ListViewTasks> createState() => _ListViewTasksState();
}

class _ListViewTasksState extends State<ListViewTasks> {
  TaskService taskService = TaskService();
  List<Task> tasks = [];

  Future<void> getAllTasks() async {
    tasks = await taskService.getTasks();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAllTasks();
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Alta':
        return Colors.red;
      case 'Média':
        return Colors.orange;
      case 'Baixa':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              getAllTasks();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          bool localIsDone = tasks[index].isDone ?? false;
          String taskPriority = tasks[index].priority ?? 'Baixa';

          return Column(
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tasks[index].title.toString(),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: localIsDone ? Colors.grey : Colors.green,
                              decoration: localIsDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          if (localIsDone)
                            Text(
                              'Tarefa Finalizada',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
                      ),
                      Checkbox(
                        value: localIsDone,
                        onChanged: (value) async {
                          if (value != null) {
                            await taskService.editTask(
                                index,
                                tasks[index].title!,
                                tasks[index].description!,
                                value,
                                taskPriority);
                            setState(() {
                              tasks[index].isDone = value;
                            });
                          }
                        },
                      ),
                      Text(
                        tasks[index].description.toString(),
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getPriorityColor(taskPriority),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              taskPriority,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Spacer(),
                          // Oculta o botão de editar se a tarefa estiver concluída
                          Visibility(
                            visible: !localIsDone,
                            child: IconButton(
                              onPressed: () async {
                                final bool? updated = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FormTasks(
                                      task: tasks[index],
                                      index: index,
                                    ),
                                  ),
                                );
                                if (updated == true) {
                                  // Verifica se a atualização foi bem-sucedida
                                  getAllTasks(); // Recarrega a lista de tarefas
                                }
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Color.fromARGB(255, 123, 168, 239),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: localIsDone
                                ? null // Desabilita o botão se a tarefa estiver concluída
                                : () async {
                                    await taskService.deleteTask(index);
                                    getAllTasks(); // Recarrega a lista de tarefas
                                  },
                            icon: Icon(Icons.delete,
                                color: localIsDone
                                    ? Colors.grey
                                    : Color.fromARGB(255, 232, 9, 9)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
