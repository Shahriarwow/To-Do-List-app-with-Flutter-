import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:to_do_list/data/data.dart';
import 'package:to_do_list/data/repo/repository.dart';
import 'package:to_do_list/main.dart';
import 'package:to_do_list/screens/edit/edit.dart';
import 'package:to_do_list/widgets.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({
    Key? key,
  }) : super(key: key);
  final TextEditingController controller = TextEditingController();
  final ValueNotifier<String> searchKeywordNotifire = ValueNotifier('');
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditTaskScreen(
                        task: Task(),
                      )));
            },
            label: Row(
              children: const [
                Text('Add New Task'),
                SizedBox(
                  width: 4,
                ),
                Icon(
                  CupertinoIcons.add,
                  size: 16,
                )
              ],
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: 110,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      themeData.colorScheme.primary,
                      themeData.colorScheme.primaryVariant,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'To Do List',
                            style: themeData.textTheme.headline6!
                                .apply(color: themeData.colorScheme.onPrimary),
                          ),
                          Icon(
                            CupertinoIcons.share,
                            color: themeData.colorScheme.onPrimary,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        height: 38,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(19),
                            color: Colors.white),
                        child: TextField(
                          onChanged: (value) {
                            searchKeywordNotifire.value = controller.text;
                          },
                          controller: controller,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(CupertinoIcons.search),
                              label: Text('Search tasks...')),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ValueListenableBuilder<String>(
                  valueListenable: searchKeywordNotifire,
                  builder: (context, value, child) {
                   
                    return Consumer<Repository<Task>>(
                      builder: (context, repository, child) {
                        return  FutureBuilder<List>(
                        future: repository.getAll(
                            searchKeywordNotifire: controller.text),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.isNotEmpty) {
                              return TaskList(
                                  ithems: snapshot.data, themeData: themeData);
                            } else {
                              return const EmptyState();
                            }
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      );
                      },
                     
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}

class TaskList extends StatelessWidget {
  const TaskList({
    Key? key,
    required this.ithems,
    required this.themeData,
  }) : super(key: key);

  final ithems;
  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: ithems.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today',
                      style: themeData.textTheme.headline6!
                          .apply(fontSizeFactor: 0.9),
                    ),
                    Container(
                      width: 70,
                      height: 4,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        color: themeData.colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ],
                ),
                MaterialButton(
                    elevation: 0,
                    color: const Color(0xffEAEFF5),
                    textColor: secendaryTextColor,
                    onPressed: () {
                      final taskRepository =
                          Provider.of<Repository<Task>>(context,listen: false);
                      taskRepository.deleteAll(Task());
                    },
                    child: Row(
                      children: const [
                        Text('Delete All'),
                        Icon(
                          CupertinoIcons.delete_solid,
                          size: 18,
                        )
                      ],
                    ))
              ],
            );
          } else {
            final Task task = ithems[index - 1];
            return TaskItem(task: task);
          }
        });
  }
}

class TaskItem extends StatefulWidget {
  const TaskItem({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final Color perioritycolor;
    switch (widget.task.priority) {
      case Priority.low:
        perioritycolor = lowPeriority;
        break;

      case Priority.normal:
        perioritycolor = normalPeriority;
        break;

      case Priority.hight:
        perioritycolor = hightPriority;
        break;
    }

    void _showDialog() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Are u sure Delete task ?'),
              content: Row(
                children: [
                  TextButton(
                    onPressed: () {
                     final repository=Provider.of<Repository<Task>>(context,listen: false);
                     repository.delete(widget.task);


                      Navigator.of(context).pop();
                    },
                    child: const Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('No'),
                  )
                ],
              ),
            );
          });
    }

    return InkWell(
      onLongPress: () {
        _showDialog();
      },
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EditTaskScreen(task: widget.task)));
      },
      child: Container(
          height: 84,
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
              color: themeData.colorScheme.surface,
              boxShadow: [
                BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(0.05))
              ],
              borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              MycheckBox(
                value: widget.task.isComplited,
                onTap: () {
                  setState(() {
                    widget.task.isComplited = !widget.task.isComplited;
                  });
                },
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Text(
                  widget.task.name,
                  style: TextStyle(
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                      decoration: widget.task.isComplited
                          ? TextDecoration.lineThrough
                          : null),
                ),
              ),
              Container(
                height: 80,
                width: 6,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8)),
                    color: perioritycolor),
              )
            ],
          )),
    );
  }
}
