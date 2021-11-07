import 'package:flutter/physics.dart';

class ListData {
  static List<String> getBoxLocations() {
    return [
      'Miami Warehouse',
      'In Transit to Miami Airport',
      'Miami Airport',
      'In Transit to Jamaica',
      'JA Customs',
      'In Transit to Store Warehouse',
      'Ready for Pickup'
    ];
  }

  static List<String> getPackageLocations() {
    return [
      'Miami Warehouse',
      'In Transit to Miami Airport',
      'Miami Airport',
      'In Transit to Jamaica',
      'JA Customs',
      'In Transit to Store Warehouse',
      'Ready for Pickup',
      'Out for Delivery',
      'Delivered'
    ];
  }

  static List<String> getPackageSatuses() {
    return [
      'Received',
      'In Transit',
      'Seized',
      'Lost',
      'Out for Delivery',
      'Ready for Pickup',
      'Delivered'
    ];
  }
}
