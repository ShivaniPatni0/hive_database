import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_database/boxes/boxes.dart';
import 'package:hive_database/models/note_model.dart';
import 'package:hive_flutter/adapters.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Hive Database'),
        backgroundColor: Colors.blue,
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
          valueListenable: Boxes.getData().listenable(),
          builder: (context, box, _) {
            var data = box.values.toList().cast<NotesModel>();
            return ListView.builder(
                reverse: true,
                shrinkWrap: true,
                itemCount: box.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data[index].title),
                            Text(data[index].description),
                          ],
                        ),
                        const Spacer(),
                        InkWell(
                            onTap: () {
                              delete(data[index]);
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                            onTap: () {
                              _editDialog(data[index], data[index].title,
                                  data[index].description);
                            },
                            child: const Icon(Icons.edit)),
                      ],
                    ),
                  ));
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showMyDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void delete(NotesModel notesModel) async {
    await notesModel.delete();
  }

  Future<void> _editDialog(
      NotesModel notesModel, String title, String description) async {
    titleController.text = title;
    descriptionController.text = description;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit Notes'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                        hintText: 'Enter Title', border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                        hintText: 'Enter Description',
                        border: OutlineInputBorder()),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () async {
                    notesModel.title = titleController.text;
                    notesModel.description = descriptionController.text;

                    notesModel.save();
                    titleController.clear();
                    descriptionController.clear();

                    Navigator.pop(context);
                  },
                  child: const Text('Edit'))
            ],
          );
        });
  }

  Future<void> _showMyDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Notes'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                        hintText: 'Enter Title', border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                        hintText: 'Enter Description',
                        border: OutlineInputBorder()),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    final data = NotesModel(
                        descriptionController.text, titleController.text);
                    final box = Boxes.getData();
                    box.add(data);
                    //data.save();
                    titleController.clear();
                    descriptionController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text('Add'))
            ],
          );
        });
  }
}
