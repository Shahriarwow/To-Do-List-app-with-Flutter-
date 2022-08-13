abstract class DataSource<T> {
 Future <List<T>> getAll({String searchKeywordNotifire});
  Future <void> findeByid(dynamic id);
  Future<void> delete(T data);
   Future <void> deleteAll(T data);
  Future <void> deleteByid(dynamic id);
  Future <T> creatOrupdate(T data);

}