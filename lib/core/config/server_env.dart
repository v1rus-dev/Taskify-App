enum ServerEnv {
  dev(baseUrl: 'http://82.40.38.39:80/'),
  localhostDev(baseUrl: 'http://192.168.100.2:80/'),
  prod(baseUrl: 'https://api.example.com/');

  const ServerEnv({required this.baseUrl});

  final String baseUrl;
}
