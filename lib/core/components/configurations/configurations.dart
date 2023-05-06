import 'default_config.dart';

class Configurations {
  static String _baseUrl = DefaultConfig.baseUrl;
  static String _name = DefaultConfig.name;
  static String _environment = DefaultConfig.environment;

  void setConfigurationValues(Map<String, dynamic> value) {
    _name = value['name'] ?? DefaultConfig.name;
    _environment = value['environment'] ?? DefaultConfig.environment;
    _baseUrl = value['baseUrl'] ?? DefaultConfig.baseUrl;
  }

  static String get baseUrl => _baseUrl;
  static String get name => _name;
  static String get environment => _environment;
}
