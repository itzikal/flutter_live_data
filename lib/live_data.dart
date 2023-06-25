import 'dart:async';
import 'dart:math';
import 'live_data_token.dart';

part 'mutable_live_data.dart';
part 'list_live_data.dart';

typedef Transformation<A,B,R> = R Function(A a, B b);
typedef TripleTransformation<A,B,C,R> = R Function(A a, B b, C c);
typedef LiveDataEvent<A> = void Function(A a);
typedef LiveDataErrorEvent = void Function(Object a);

class LiveData<T> {
  bool _fromStream = false;
  StreamController<T>? _controller;
  LiveDataToken? _connectedToken;
  final List<LiveDataToken> _registeredLiveData = <LiveDataToken>[];
  T _value;
  T get value { return _value; }

  Object? _error;
  bool get hasError => _error != null;

  /// Create Live data.
  /// [initValue] optional initial value.
  LiveData._({required T initValue}) :
    _value = initValue;


  /// create Live data out of a stream.
  LiveData.fromStream({required Stream<T> stream, required T initValue})
      : _value = initValue{
    _fromStream = true;
    _createController();
    _controller!.addStream(stream);
    _connectedToken = LiveDataToken(_controller!.stream.listen((event) {
      _error = null;
      _value = event;
    },
        onError: (e) => _error = e));
  }

  /// back to stream
  Stream<T> asStream()  {
    _createController();
    return _controller!.stream;
  }

  /// register to changes.
  LiveDataToken register<R>(LiveDataEvent<T> onChange, { LiveDataErrorEvent? onError }) {
     _createController();
     return LiveDataToken(_controller!.stream.listen(onChange, onError: onError));
  }

  /// register to changes, but will notify change with latest value, when registered for first time
  LiveDataToken activeRegister<R>(LiveDataEvent<T> onChange, { LiveDataErrorEvent? onError }) {
    _createController();
    if(hasError) {
        onError?.call(_error!);
    }else{
      onChange(value);
    }
    return LiveDataToken(_controller!.stream.listen(onChange, onError: onError));
  }

  /// remove registration
  Future<void> unRegister(LiveDataToken token) async{
    await token.cancel();
  }

  /// transform to new LiveData, which bound to changes.
  LiveData<R> map<R>(R Function(T) to) {
    MutableLiveData<R> mappedLiveData = MutableLiveData<R>(initValue: to(_value));
    var token = register((event) => mappedLiveData.add(to(event)),
        onError:(error) { mappedLiveData.addError(error);});

    mappedLiveData._connectedToken = token;
    _registeredLiveData.add(token);

    return mappedLiveData;
  }
  // /// transform to new LiveData, which bound to changes.
  // /// async transformation
  // LiveData<R> mapAsync<R>(FutureOr<R> Function(T event) to) {
  //   MutableLiveData<R> mappedLiveData = MutableLiveData<R>(initValue: await to(_value));
  //   var token = register((event) async => mappedLiveData.add(await to(event)), onError:(error) { mappedLiveData.addError(error);});
  //   mappedLiveData._connectedToken = token;
  //   _registeredLiveData.add(token);
  //
  //   return mappedLiveData;
  // }

  /// combine two LiveData to new Bounded LiveData.
  /// will get notification on both and emit new notification with transform data.
  static LiveData<R> transform<A,B,R>(LiveData<A> A, LiveData<B> B, Transformation<A,B,R> transform, {LiveDataErrorEvent? onError}){

    MutableLiveData<R> result = MutableLiveData<R>(initValue: transform(A.value,B.value));

    LiveDataToken tokenA = A.register((event) {
      result.add(transform(event, B.value));
    }, onError: onError);
    LiveDataToken tokenB = B.register((event) {
      result.add(transform(A.value, event));
    }, onError: onError);
    result._registeredLiveData.add(tokenA);
    result._registeredLiveData.add(tokenB);

    return result;
  }

  /// combine two LiveData to new Bounded LiveData.
  /// will get notification on both and emit new notification with transform data.
  static LiveData<R> tripleTransform<A,B,C,R>(LiveData<A> A, LiveData<B> B,LiveData<C> C, TripleTransformation<A,B,C,R> transform, {LiveDataErrorEvent? onError}){

    MutableLiveData<R> result = MutableLiveData<R>(initValue: transform(A.value,B.value, C.value));

    LiveDataToken tokenA = A.register((event) {
      result.add(transform(event, B.value, C.value));
    }, onError: onError);
    LiveDataToken tokenB = B.register((event) {
      result.add(transform(A.value, event, C.value));
    }, onError: onError);
    LiveDataToken tokenC = C.register((event) {
      result.add(transform(A.value, B.value, event));
    }, onError: onError);
    result._registeredLiveData.add(tokenA);
    result._registeredLiveData.add(tokenB);
    result._registeredLiveData.add(tokenC);

    return result;
  }

  /// close all streams and listeners,
  /// kill the controller - after this the live data can't be reuse.
  Future<void> dispose() async{
    _registeredLiveData.forEach((element) => element.cancel());
    _registeredLiveData.clear();
    _connectedToken?.cancel();
    _connectedToken = null;

    if(!_fromStream) {
      _controller?.close();
      _controller = null;
    }
  }

  void _createController(){
    if(_controller == null){
      _controller = StreamController<T>.broadcast();
      _controller?.onCancel = (){
        if(_controller?.hasListener == false){
          var controller = _controller;
          _controller = null;
          controller?.close();

        }
      };
    }
  }
}
