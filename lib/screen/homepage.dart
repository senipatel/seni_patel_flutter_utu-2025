import "package:flutter/material.dart";

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  List<Map<String, dynamic>> task = [];
  TextEditingController userInput = TextEditingController();

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
            title: Text(
              data['task'],
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            trailing: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    if (data['bookmark']) {
                      setState(() {
                        data['bookmark'] = false;
                      });
                    } else {
                      setState(() {
                        data['bookmark'] = true;
                      });
                    }
                  },
                  child: Icon(
                    data['bookmark']
                        ? Icons.bookmark_add
                        : Icons.bookmark_add_outlined,
                    size: 25,
                    color: Colors.blue,
                  ),
                ),
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