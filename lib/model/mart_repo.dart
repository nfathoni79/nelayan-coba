import 'package:nelayan_coba/model/cart_product.dart';
import 'package:nelayan_coba/model/fish.dart';
import 'package:nelayan_coba/model/mart.dart';
import 'package:nelayan_coba/model/product.dart';
import 'package:nelayan_coba/model/wallet.dart';

class MartRepo {
  static List<Mart> martList = [
    const Mart(id: 1, name: 'Perindo Bacan'),
    const Mart(id: 2, name: 'Perindo Muara Baru'),
    const Mart(id: 3, name: 'Perindo Subang'),
  ];

  static List<Product> productList = [
    const Product(id: 1, name: 'Indomie Rendang', price: 3500),
    const Product(id: 2, name: 'ABC Milk Coffee', price: 3000),
    const Product(id: 3, name: 'Nu Yogurt Tea', price: 6800),
    const Product(id: 4, name: 'Indomie Rendang', price: 3500),
    const Product(id: 5, name: 'ABC Milk Coffee', price: 3000),
    const Product(id: 6, name: 'Nu Yogurt Tea', price: 6800),
    const Product(id: 7, name: 'Indomie Rendang', price: 3500),
    const Product(id: 8, name: 'ABC Milk Coffee', price: 3000),
    const Product(id: 9, name: 'Nu Yogurt Tea', price: 6800),
  ];

  static List<Fish> fishList = [
    const Fish(id: 1, name: 'Cakalang'),
    const Fish(id: 2, name: 'Tuna'),
    const Fish(id: 3, name: 'Deho'),
    const Fish(id: 4, name: 'Layang'),
    const Fish(id: 5, name: 'Salem'),
  ];

  static List<Wallet> walletList = [
    const Wallet(id: 1, user: 'Candra Dwi'),
    const Wallet(id: 2, user: 'Eka Fira'),
    const Wallet(id: 3, user: 'Gandi Harto'),
    const Wallet(id: 4, user: 'Candra Dwi'),
    const Wallet(id: 5, user: 'Eka Fira'),
    const Wallet(id: 6, user: 'Gandi Harto'),
    const Wallet(id: 7, user: 'Candra Dwi'),
    const Wallet(id: 8, user: 'Eka Fira'),
    const Wallet(id: 9, user: 'Gandi Harto'),
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
}
