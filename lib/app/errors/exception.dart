class ServerExecption implements Exception {
  final String msg;
  ServerExecption(this.msg);
}

class LocalExecption implements Exception {
  final String msg;
  LocalExecption(this.msg);
}
