import 'dart:io';

Future<String> getLocalIpv4Address() async {
  try {
    final interfaces = await NetworkInterface.list(type: InternetAddressType.IPv4);
    for (var interface in interfaces) {
      for (var address in interface.addresses) {
        if (!address.isLoopback) {
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
  if(!host.endsWith("0")){host = "${host}0"; }
  String http = 'http://$host:';
  return http;
}