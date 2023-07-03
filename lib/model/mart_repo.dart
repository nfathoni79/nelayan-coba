import 'package:nelayan_coba/model/cart_product.dart';
import 'package:nelayan_coba/model/fish.dart';
import 'package:nelayan_coba/model/mart.dart';
import 'package:nelayan_coba/model/product.dart';

class MartRepo {
  static List<Mart> martList = [
    const Mart(id: 1, name: 'Perindo Coba'),
    const Mart(id: 2, name: 'Perindo Bacan'),
    const Mart(id: 3, name: 'Perindo Muara Baru'),
    const Mart(id: 4, name: 'Perindo Subang'),
  ];

  static List<Product> productList = [
    const Product(
      id: 1,
      name: 'Indomie Rendang',
      description: 'Mie instan no. 1 di dunia',
      price: 3500,
    ),
    const Product(
      id: 2,
      name: 'ABC Milk Coffee',
      description: 'Kopi susu no. 1 di dunia',
      price: 3000,
    ),
    const Product(
      id: 3,
      name: 'Nu Yogurt Tea',
      description: 'Teh yogurt pertama di dunia',
      price: 6800,
    ),
    const Product(
      id: 4,
      name: 'Nabati Richeese Wafer',
      description: 'Wafer keju no. 1 di dunia',
      price: 8900,
    ),
    const Product(
      id: 5,
      name: 'Oreo Chocolate',
      description: 'Biskuit cokelat no. 1 di dunia',
      price: 9800,
    ),
    const Product(
      id: 6,
      name: 'Piattos Sambal Matah',
      description: 'Keripik kentang dengan rasa otentik Indonesia',
      price: 11800,
    ),
    const Product(
      id: 7,
      name: 'Pisang Cavendish',
      description: 'Pisang kualitas terbaik',
      price: 2400,
    ),
    const Product(
      id: 8,
      name: 'Roma Kelapa',
      description: 'Biskuit kelapa no. 1 di dunia',
      price: 12900,
    ),
    const Product(
      id: 9,
      name: 'Ultra Milk UHT',
      description: 'Susu UHT no. 1 di dunia',
      price: 6000,
    ),
  ];

  static List<Fish> fishList = [
    const Fish(id: 1, name: 'Cakalang', price: 30000),
    const Fish(id: 2, name: 'Tuna', price: 70000),
    const Fish(id: 3, name: 'Deho', price: 22000),
    const Fish(id: 4, name: 'Layang', price: 27000),
    const Fish(id: 5, name: 'Salem', price: 38000),
  ];

  static List<CartProduct> cartProductList = [
    CartProduct(
      id: 1,
      product: productList[0],
      quantity: 1,
    ),
    CartProduct(
      id: 2,
      product: productList[1],
      quantity: 2,
    ),
  ];

  // static String geraiCobaUserUuid = '174ad106-c6f4-4605-9e4a-56c9145cafff';
  // static String pabrikCobaUserUuid = '05161c58-ae94-486c-9995-306c7f27426b';

  static String geraiCobaUserUuid = 'b4642588-e0d4-43e2-8123-d74afb1cb5cd';
  static String pabrikCobaUserUuid = '6ba776ef-6144-4345-9f76-b8c7a5407cf7';
}
