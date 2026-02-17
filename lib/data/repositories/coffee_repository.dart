import 'package:coffee_app/data/models/coffee.dart';

class CoffeeRepository {
  CoffeeRepository._();

  static final CoffeeRepository _instance = CoffeeRepository._();
  static CoffeeRepository get instance => _instance;

  List<Coffee> getCoffees() => [];

  List<Coffee> getCoffeesByCategory(String categoryId) => [];
}
