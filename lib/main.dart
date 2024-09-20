import 'package:flutter/material.dart';
import 'package:projeto/views/form_view_tasks.dart';
import 'package:projeto/views/listViewTask.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarefas flutter',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 15, 145, 43)),
        useMaterial3: false,
      ),
      home: MyWidget(),
      routes: {
        '/listarTarefas': (context) => ListViewTasks(),
        '/formulariosTarefas': (context) => FormTasks()
      },
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Minha Lista de Tarefas')),
        drawer: Drawer(
            child: Column(
          children: [
            UserAccountsDrawerHeader(
                accountName: Text('teste', style: TextStyle(fontSize: 24)),
                accountEmail: Text('teste@mail.com'),
                currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white, child: Icon(Icons.person))),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Lista de Tarefas'),
              onTap: () {
                Navigator.pushNamed(context, '/listarTarefas');
              },
            )
          ],
        )),
        body: Stack(
          children: [
            Center(child: Text('Tela Inicial')),
            Padding(
                padding: EdgeInsets.only(bottom: 20, left: 10, right: 20),
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/formulariosTarefas');
                      },
                      child: Icon(Icons.add),
                    )))
          ],
        ));
  }
}
