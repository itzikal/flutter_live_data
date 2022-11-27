import 'package:stream_live_data/live_data.dart';

class ListLiveData<T> extends MutableLiveData<List<T>>{
  List<T> get _list => value == null ? [] : value!;


  ListLiveData({List<T>? initValue}): super(initValue: initValue);

  void sort([int compare(T a, T b)?]){
    _list.sort(compare);
    add(_list);
  }

  void reversed(){
    add(_list.reversed.toList());
  }

  void addItem(T item){
    List<T> list =  _list;
    list.add(item);
    add(list);
  }

  void addItems(List<T> items){
    List<T> list =  _list;
    list.addAll(items);
    add(list);
  }

  void clear(){
    add([]);
  }

  void notifyChanged(){
    add(_list);
  }






}