import 'package:flutter/material.dart';
import '../utilities/utility.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Task {
  String task;
  bool? isDone;

  Task({required this.task, this.isDone = false});

  Map<String, dynamic> toJson() => {
        'task': task,
        'isDone': isDone,
      };

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      task: json['task'],
      isDone: json['isDone'],
    );
  }
}

List<String> taskListToJson(List<Task> tasks) {
  return tasks.map((task) => json.encode(task.toJson())).toList();
}

List<Task> taskListFromJson(List<String> tasks) {
  return tasks.map((task) => Task.fromJson(json.decode(task))).toList();
}

Future<void> saveTaskList(List<Task> tasks) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> taskStrings = taskListToJson(tasks);
  await prefs.setStringList('tasklist', taskStrings);
}

Future<List<Task>> getTaskList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? taskStrings = prefs.getStringList('tasklist');
  if (taskStrings != null) {
    return taskListFromJson(taskStrings);
  } else {
    return [];
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> tasklist = [];

  final textcontroller = TextEditingController();

  Future<void> _loadTaskList() async {
    tasklist = await getTaskList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/ic_launcher.png'),
              radius: 22,
            ),
            SizedBox(width: 10),
            Center(child: AppUtility.appbartext),
          ],
        ),
        backgroundColor: AppUtility.appbarcolor,
      ),
      body: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                title: Text(
                  tasklist[index].task,
                  style: AppUtility.tasktextstyle,
                ),
                onTap: () {
                  TextEditingController editor = TextEditingController();
                  editor.text = tasklist[index].task;
                  Get.defaultDialog(
                    titlePadding: const EdgeInsets.symmetric(vertical: 20),
                    contentPadding: const EdgeInsets.all(20),
                    title: "Edit Task",
                    content: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Task",
                      ),
                      controller: editor,
                    ),
                    barrierDismissible: true,
                    actions: [
                      TextButton(
                          onPressed: () => Get.back(),
                          child: const Text("Cancel")),
                      TextButton(onPressed: () async {
                        final pref = await SharedPreferences.getInstance();
                        setState(() {
                          tasklist[index].task = editor.text;
                        });
                        await pref.remove('tasklist');
                        saveTaskList(tasklist);

                        Get.back();

                      }, child: const Text("Done")),
                    ],
                  );
                },
                tileColor: tasklist[index].isDone == true
                    ? const Color.fromARGB(147, 33, 149, 243)
                    : AppUtility().taskbgcolor,
                leading: Checkbox(
                  value: tasklist[index].isDone,
                  onChanged: (val) async {
                    final pref = await SharedPreferences.getInstance();
                    setState(() {
                      tasklist[index].isDone = val!;
                    });
                    await pref.remove('tasklist');
                    saveTaskList(tasklist);
                    setState(() {});
                  },
                ),
                trailing: IconButton(
                  onPressed: () async {
                    final pref = await SharedPreferences.getInstance();
                    setState(() {
                      tasklist.removeAt(index);
                    });
                    await pref.remove('tasklist');
                    saveTaskList(tasklist);
                  },
                  icon: const Icon(Icons.delete),
                ));
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(height: 5, color: Colors.grey),
          itemCount: tasklist.length),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.defaultDialog(
            titlePadding: const EdgeInsets.symmetric(vertical: 20),
            contentPadding: const EdgeInsets.all(20),
            title: "New Task",
            content: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Task",
              ),
              controller: textcontroller,
            ),
            barrierDismissible: false,
            actions: [
              TextButton(
                  onPressed: () => Get.back(), child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    String currenttext = textcontroller.text;
                    bool done = false;
                    if (currenttext.isEmpty) {
                      currenttext = "Untitled task";
                    }
                    Task mytask = Task(task: currenttext, isDone: done);
                    print(
                        "Task name: ${mytask.task} and the task has been done: ${mytask.isDone}");
                    tasklist.add(mytask);
                    saveTaskList(tasklist);
                    setState(() {});
                    textcontroller.clear();
                    Get.back();
                  },
                  child: const Text("Save")),
            ],
          );
        },
        backgroundColor: Colors.cyan,
        child: const Icon(Icons.add_task),
      ),
    );
  }
}
