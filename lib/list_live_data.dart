part of 'live_data.dart';

class ListLiveData<T> extends MutableLiveData<List<T>>{

  ListLiveData({List<T>? initValue}): super(initValue: []);

  T operator [](int index) {
    return _value[index];
  }

  void operator []=(int index, T value) {
    _value[index] = value;
    notifyDataChanged();
  }

  void addItem(T value) {
    _value.add(value);
    notifyDataChanged();
  }

  void addItems(Iterable<T> iterable) {
    _value.addAll(iterable);
    notifyDataChanged();
  }

  bool any(bool Function(T element) test) => _value.any(test);

  Map<int, T> asMap() => _value.asMap();

  void clear() {
    _value.clear();
    notifyDataChanged();
  }

  bool contains(Object? element) => _value.contains(element);

  T elementAt(int index) => _value.elementAt(index);

  bool every(bool Function(T element) test) => _value.every(test);

  T firstWhere(bool Function(T element) test, {T Function()? orElse}) => _value.firstWhere(test ,orElse: orElse);

  void forEach(void Function(T element) action) => _value.forEach(action);

  int indexOf(T element, [int start = 0]) => _value.indexOf(element, start);

  int indexWhere(bool Function(T element) test, [int start = 0]) => _value.indexWhere(test, start);

  void insert(int index, T element) {
    _value.insert(index, element);
    notifyDataChanged();
  }

  void insertAll(int index, Iterable<T> iterable) {
    _value.insertAll(index, iterable);
    notifyDataChanged();
  }

  bool get isEmpty => _value.isEmpty;

  bool get isNotEmpty => _value.isNotEmpty;

  Iterator<T> get iterator => _value.iterator;

  T lastWhere(bool Function(T element) test, {T Function()? orElse}) => _value.lastWhere(test, orElse: orElse);

  void removeItem(Object? value) {
    _value.remove(value);
    notifyDataChanged();
  }

  void removeAt(int index) {
    _value.removeAt(index);
    notifyDataChanged();
  }

  void removeWhere(bool Function(T element) test) {
    _value.removeWhere(test);
    notifyDataChanged();
  }

  @override
  void shuffle([Random? random]) {
    _value.shuffle(random);
    notifyDataChanged();
  }

  @override
  void sort([int Function(T a, T b)? compare]) {
    _value.sort(compare);
    notifyDataChanged();
  }
}