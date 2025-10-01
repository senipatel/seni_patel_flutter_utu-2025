import "dart:convert";

import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  List<Map<String, dynamic>> task = [];
  TextEditingController userInput = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskList = prefs.getStringList('tasks');
    if (taskList != null) {
      setState(() {
        task = taskList.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
      });
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskList = task.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList('tasks', taskList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TO-DO list", style: TextStyle(fontSize: 25)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey.shade400,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Add task"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: userInput,
                      decoration: InputDecoration(
                        hint: Text(
                          "enter your task",
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: () {
                        if (userInput.text.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  "Please enter a data !",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.red,
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          Map<String, dynamic> userInsert = {
                            "task": userInput.text,
                            "bookmark": false,
                          };
                          setState(() {
                            task.add(userInsert);
                          });
                          _saveTasks();
                          userInput.clear();
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(fontSize: 15, color: Colors.purple),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add, color: Colors.black),
      ),

      body: task.isEmpty
          ? Center(child: Text("No tasks yet",style: TextStyle(color: Colors.grey.shade500,fontSize: 20),),)
          :
      ListView.builder(
        itemCount: task.length,
        itemBuilder: (_, index) {
          final data = task[index];
          return ListTile(
            leading: GestureDetector(
              onTap: () {
                setState(() {
                  data['bookmark'] = !data['bookmark'];
                });
                _saveTasks();
              },
              child: Icon(
                data['bookmark']
                    ? Icons.check_box_outlined
                    : Icons.check_box_outline_blank_rounded,
                size: 25,
                color: Colors.blue,
              ),
            ),
            title: Text(
              data['task'],
              style: TextStyle(fontSize: 20, color: Colors.black, decoration: data['bookmark'] ? TextDecoration.lineThrough: TextDecoration.none ),
            ),
            trailing: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [

                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Delete"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Title: ${data['task']}",
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(height: 15),
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    task.removeAt(index);
                                  });
                                  _saveTasks();
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Delete",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Icon(Icons.delete, size: 25, color: Colors.red),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
