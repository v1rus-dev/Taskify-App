import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get hasInternet;
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl(this._connectivity);

  final Connectivity _connectivity;

  @override
  Future<bool> get hasInternet async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult.any(
      (result) => result != ConnectivityResult.none,
    );
  }
}
