import 'package:flutter/material.dart';
import 'package:projeto/models/teste_model.dart';
import 'package:projeto/services/task_service.dart';

class FormTasks extends StatefulWidget {
  final Task? task;
  final int? index;

  const FormTasks({super.key, this.task, this.index});

  @override
  State<FormTasks> createState() => _FormTasksState();
}

class _FormTasksState extends State<FormTasks> {
  final _formKey = GlobalKey<FormState>();
  final TaskService taskService = TaskService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _priority = 'Baixa';

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title!;
      _descriptionController.text = widget.task!.description!;
      _priority = widget.task!.priority ?? 'Baixa';
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Tarefa' : 'Criar Tarefa'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Título da Tarefa',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '*Título não preenchido!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Descrição da Tarefa',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Prioridade'),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Baixa'),
                      value: 'Baixa',
                      groupValue: _priority,
                      onChanged: (value) {
                        setState(() {
                          _priority = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Média'),
                      value: 'Média',
                      groupValue: _priority,
                      onChanged: (value) {
                        setState(() {
                          _priority = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Alta'),
                      value: 'Alta',
                      groupValue: _priority,
                      onChanged: (value) {
                        setState(() {
                          _priority = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String title = _titleController.text;
                    String description = _descriptionController.text;

                    if (isEditing && widget.index != null) {
                      await taskService.editTask(
                          widget.index!, title, description, false, _priority);
                    } else {
                      await taskService.saveTask(title, description, _priority);
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isEditing
                            ? 'Tarefa alterada com sucesso!'
                            : 'Tarefa salva com sucesso!'),
                      ),
                    );

                    Navigator.pop(context, true);
                  }
                },
                child: Text(isEditing ? 'Alterar Tarefa' : 'Salvar Tarefa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
