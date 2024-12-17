import 'dart:io';

Future<String> getLocalIpv4Address() async {
  try {
    final interfaces = await NetworkInterface.list(type: InternetAddressType.IPv4);
    for (var interface in interfaces) {
      for (var address in interface.addresses) {
        if (!address.isLoopback) {
          // Filter by preferred IP ranges (for example, 192.x.x.x)
          if (address.address.startsWith("192")) {
            return address.address;
          }
        }
      }
    }
    return "No desired local IPv4 address found";
  } catch (e) {
    return "Error:${e.toString()}";
  }
}
String port = "8085";
Future<String> HTTP() async {
  String host = await getLocalIpv4Address();
  String http = 'http://${host}0:';
  return http;
}