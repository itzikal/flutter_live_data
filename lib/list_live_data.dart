part of 'live_data.dart';

class ListLiveData<T> extends MutableLiveData<List<T>?>{

  ListLiveData({List<T>? initValue}): super(initValue: initValue);

  T operator [](int index) {
    return _initList[index];
  }
  
  List<T> get _initList {
    _value??=[];
    return _value!;
  }
  
  void operator []=(int index, T value) {
    _initList[index] = value;
    notifyDataChanged();
  }

  void addItem(T value) {
    _initList.add(value);
    notifyDataChanged();
  }

  void addItems(Iterable<T> iterable) {
    _initList.addAll(iterable);
    notifyDataChanged();
  }

  bool any(bool Function(T element) test) => _initList.any(test);

  Map<int, T> asMap() => _initList.asMap();

  void clear() {
    _initList.clear();
    notifyDataChanged();
  }

  bool contains(Object? element) => _initList.contains(element);

  T elementAt(int index) => _initList.elementAt(index);

  bool every(bool Function(T element) test) => _initList.every(test);

  T firstWhere(bool Function(T element) test, {T Function()? orElse}) => _initList.firstWhere(test ,orElse: orElse);

  void forEach(void Function(T element) action) => _initList.forEach(action);

  int indexOf(T element, [int start = 0]) => _initList.indexOf(element, start);

  int indexWhere(bool Function(T element) test, [int start = 0]) => _initList.indexWhere(test, start);

  void insert(int index, T element) {
    _initList.insert(index, element);
    notifyDataChanged();
  }

  void insertAll(int index, Iterable<T> iterable) {
    _initList.insertAll(index, iterable);
    notifyDataChanged();
  }

  bool get isEmpty => _initList.isEmpty;

  bool get isNotEmpty => _initList.isNotEmpty;

  Iterator<T> get iterator => _initList.iterator;

  T lastWhere(bool Function(T element) test, {T Function()? orElse}) => _initList.lastWhere(test, orElse: orElse);

  void removeItem(Object? value) {
    _initList.remove(value);
    notifyDataChanged();
  }

  void removeAt(int index) {
    _initList.removeAt(index);
    notifyDataChanged();
  }

  void removeWhere(bool Function(T element) test) {
    _initList.removeWhere(test);
    notifyDataChanged();
  }

  @override
  void shuffle([Random? random]) {
    _initList.shuffle(random);
    notifyDataChanged();
  }

  @override
  void sort([int Function(T a, T b)? compare]) {
    _initList.sort(compare);
    notifyDataChanged();
  }
}