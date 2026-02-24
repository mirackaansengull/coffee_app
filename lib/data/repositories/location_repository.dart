import 'package:coffee_app/data/models/delivery_location.dart';
import 'package:flutter/foundation.dart';

class LocationRepository extends ChangeNotifier {
  LocationRepository._();

  static final LocationRepository _instance = LocationRepository._();
  static LocationRepository get instance => _instance;

  DeliveryLocation? _selected;

  DeliveryLocation? get selected => _selected;

  void setLocation(DeliveryLocation? location) {
    _selected = location;
    notifyListeners();
  }

  void clear() {
    _selected = null;
    notifyListeners();
  }
}
