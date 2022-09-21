import 'dart:async';
import 'live_data_token.dart';

typedef Transformation<A,B,R> = R Function(A? a, B? b);
typedef LiveDataEvent<A> = void Function(A? a);
typedef LiveDataErrorEvent = void Function(Object a);

class LiveData<T> {
  StreamController<T>? _controller;
  LiveDataToken? _connectedToken;
  final List<LiveDataToken> _registeredLiveData = <LiveDataToken>[];
  T? _value;
  T? get value { return _value; }

  /// Create Live data.
  /// [initValue] optional initial value.
  LiveData({T? initValue}) {
    _value = initValue;
  }

  /// create Live data out of a stream.
  LiveData.fromStream(Stream<T> stream){
    _connectedToken = LiveDataToken(stream.listen((event) {add(event);}));
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

  /// remove registration
  Future<void> unRegister(LiveDataToken token) async{
    await token.cancel();
  }

  void addError(Object error){
    _controller?.addError(error);
  }
  /// post a new value.
  /// will notify sll registered listeners, if exist
  /// value will be stored localy
  /// [value] new value to post.
  void add(T value){
    _value = value;
    var controller = _controller;
    if((controller?.isClosed ?? true)){
      return;
    }
    controller?.add(value);
  }

  /// transform to new LiveData, which bound to changes.
  LiveData<R> map<R>(R Function(T?) to) {
    _createController();
    LiveData<R> mappedLiveData = LiveData<R>(initValue: to(_value));
    mappedLiveData._createController();
    var token = register((event) => mappedLiveData._controller?.add(to(event)),
        onError:(error) { mappedLiveData.addError(error);});

    mappedLiveData._connectedToken = token;
    _registeredLiveData.add(token);

    return mappedLiveData;
  }
  /// transform to new LiveData, which bound to changes.
  /// async transformation
  LiveData<R> mapAsync<R>(FutureOr<R> Function(T? event) to) {
    _createController();
    LiveData<R> mappedLiveData = LiveData<R>();
    mappedLiveData._createController();
    var token = register((event) async => mappedLiveData._controller?.add(await to(event)), onError:(error) { mappedLiveData.addError(error);});
    mappedLiveData._connectedToken = token;
    _registeredLiveData.add(token);

    return mappedLiveData;
  }

  /// combine two LiveData to new Bounded LiveData.
  /// will get notification on both and emit new notification with transform data.
  static LiveData<R?> transform<A,B,R>(LiveData<A?> A, LiveData<B?> B, Transformation<A?,B?,R?> transform, {LiveDataErrorEvent? onError}){

    LiveData<R?> result = LiveData<R>(initValue: transform(A.value,B.value));

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

  /// close all streams and listeners
  dispose(){
    _registeredLiveData.forEach((element) => element.cancel());
    _registeredLiveData.clear();
    _connectedToken?.cancel();
    _connectedToken = null;
    _controller?.close();
    _controller = null;
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
