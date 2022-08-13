import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_list/data/data.dart';
import 'package:to_do_list/data/source/source.dart';

class HiveTaskSource implements DataSource<Task> {
  final Box<Task> box;

  HiveTaskSource(this.box);

  @override
  Future<Task> creatOrupdate(Task data) async {
    if (data.isInBox) {
      data.save();
    } else {
      data.id = await box.add(data);
    }
    return data;
  }

  @override
  Future<void> deleteAll(Task data) {
    return box.clear();
  }

  @override
  Future<void> deleteByid(id) {
    return box.delete(id);
  }

  @override
  Future<Task> findeByid(id) async {
    return box.values.firstWhere((element) => element.id == id);
  }

  @override
  Future<List<Task>> getAll({String searchKeywordNotifire = ''}) async {
  if(searchKeywordNotifire.isNotEmpty) {
    return box.values
        .where((task) => task.name.contains(searchKeywordNotifire))
        .toList();
  }else{
   return box.values.toList();
  }
  }

  @override
  Future<void> delete(Task data) async {
    return data.delete();
  }
}
