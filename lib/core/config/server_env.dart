enum ServerEnv {
  dev(baseUrl: 'http://82.40.38.39:9080/'),
  localhostDev(baseUrl: 'http://192.168.100.2:9080/'),
  prod(baseUrl: 'https://api.example.com/');

  const ServerEnv({required this.baseUrl});

  final String baseUrl;
}
