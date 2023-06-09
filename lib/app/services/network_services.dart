import 'dart:io';
abstract class NetworkServices {
  Future<bool> isConnected();
}

class InternetCheckerLookup implements NetworkServices {
  @override
  Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }
}