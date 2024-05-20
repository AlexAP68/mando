import 'package:network_info_plus/network_info_plus.dart';

class NetworkUtils {
  static final NetworkInfo _networkInfo = NetworkInfo();

  Future<String> getDeviceIP() async {
    String? wifiIP = await _networkInfo.getWifiIP();
    if (wifiIP != null) {
      return wifiIP;
    } else {
      return "Failed to get IP address";
    }
  }
}
