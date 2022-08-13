import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/data/data.dart';
import 'package:to_do_list/data/repo/repository.dart';
import 'package:to_do_list/main.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;
  const EditTaskScreen({Key? key, required this.task}) : super(key: key);

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
late  final TextEditingController _controller = TextEditingController(text: widget.task.name);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: themeData.colorScheme.surface,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
         
          widget.task.name = _controller.text;
        widget.  task.priority = widget.task.priority;
          final repository=Provider.of <Repository<Task>>(context,listen: false);
          repository.creatOrupdate(widget.task);
          Navigator.of(context).pop();
        },
        label: Row(
          children: const [
            Text('Save Change'),
            SizedBox(
              width: 4,
            ),
            Icon(
              CupertinoIcons.check_mark,
              size: 16,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeData.colorScheme.surface,
        foregroundColor: themeData.colorScheme.onSurface,
        title: const Text('Edit List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Flex(
              direction: Axis.horizontal,
              children: [
                Flexible(
                    flex: 1,
                    child: PriorityCheckBox(
                      onTap: (){
                        setState(() {
                          widget.task.priority=Priority.hight;
                        });

                      },
                      label: 'High',
                      color: primaryColor,
                      isSelected: widget.task.priority == Priority.hight,
                    )),
                const SizedBox(
                  width: 8,
                ),
                Flexible(
                    flex: 1,
                    child: PriorityCheckBox(
                      onTap: (){
                        setState(() {
                          widget.task.priority=Priority.normal;
                        });

                      },
                      label: 'Normal',
                      color: normalPeriority,
                      isSelected: widget.task.priority == Priority.normal,
                    )),
                const SizedBox(
                  width: 8,
                ),
                Flexible(
                    flex: 1,
                    child: PriorityCheckBox(
                      onTap: (){
                        setState(() {
                          widget.task.priority=Priority.low;
                        });

                      },
                      label: 'Low',
                      color: lowPeriority,
                      isSelected: widget.task.priority == Priority.low,
                    )),
              ],
            ),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(label: Text('Add Task For Today...')),
            )
          ],
        ),
      ),
    );
  }
}

class PriorityCheckBox extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final GestureTapCallback onTap;
  const PriorityCheckBox(
      {Key? key,
      required this.label,
      required this.isSelected,
      required this.color, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border:
              Border.all(width: 2, color: secendaryTextColor.withOpacity(0.2)),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(label),
            ),
          Positioned(
            
            top: 0,
            bottom: 0,
            right: 6,
    
            child:
           
            Center(child: 
            _PeriorityCheackShape(value: isSelected, color: color)
            ,)
          ),
          ],
        ),
      ),
    );
  }
}

class _PeriorityCheackShape extends StatelessWidget {
  final bool value;
  final Color color;
  const _PeriorityCheackShape({Key? key, required this.value, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      height: 15 ,
      width: 15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color
           
      ),
      child: value
          ? Icon(
              CupertinoIcons.check_mark,
              size: 12,
              color: themeData.colorScheme.onPrimary,
            )
          : null,
    );
  }
}
