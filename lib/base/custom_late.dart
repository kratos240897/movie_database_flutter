import 'package:get/get_rx/src/rx_types/rx_types.dart';

class Late<T> {
  final Rx<bool> _initialization = false.obs;
  final Rx<T?> _val = Rx(null);

  Late([T? value]) {
    if (value != null) {
      val = value;
    }
  }

  get isInitialized {
    return _initialization.value;
  }

  Rx<T?> get observable => _val;

  set val(T val) => this
    .._initialization.value = true
    .._val.value = val;
}
