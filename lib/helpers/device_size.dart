import 'package:flutter/widgets.dart';

import '../enum/device_type.dart';


DeviceType getDeviceType() {
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  return data.size.shortestSide < 550 ? DeviceType.phone : DeviceType.tablet;
} 