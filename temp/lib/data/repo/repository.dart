import 'package:flutter/cupertino.dart';
import 'package:to_do_list/data/source/source.dart';

class Repository<T> extends ChangeNotifier implements DataSource<T>{
  final DataSource<T> localDatasource;

  Repository(this.localDatasource);

  @override
  Future<T> creatOrupdate(T data) async{
   
  final T ithem= await localDatasource.creatOrupdate( data);
   notifyListeners();
   return ithem;
  }

  @override
  Future<void> deleteAll(data) async{
    notifyListeners();
   await localDatasource.deleteAll(data);
  }

  @override
  Future<void> deleteByid(id) async{
    notifyListeners();
   await localDatasource.deleteByid(id);
  
  }

  @override
  Future<void> findeByid(id) {
   return localDatasource.getAll();
  }

  @override
  Future<List<T>> getAll({String searchKeywordNotifire=''}) {
   return localDatasource.getAll(searchKeywordNotifire: searchKeywordNotifire);
  }
  
  @override
  Future<void> delete( data) async{
    notifyListeners();
   await localDatasource.delete(data);
  }



}


