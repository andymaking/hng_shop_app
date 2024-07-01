import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    ProductPage(),
    CartScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Cart',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}



class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  List<Product> products = [
    Product(name: "Lohri", price: 30, size: "L", image: AppImages.lohr, quantity: 1),
    Product(name: "Burger", price: 50, size: "S", image: AppImages.burger, quantity: 1),
    Product(name: "Chips", price: 30, size: "L", image: AppImages.chips, quantity: 1),
    Product(name: "Fried Plantain", price: 30, size: "L", image: AppImages.friedPlantain, quantity: 1),
    Product(name: "Fast Food", price: 30, size: "L", image: AppImages.fastFood, quantity: 1),
  ];

  addToCart({required Product product}){
    if(product.quantity== null ||(product.quantity??0) < 1){
      showToast(context, "Increase quantity to be more than 0 (Zero) to proceed");
      return;
    }else{
      var newCart = CartProduct(
        name: product.name,
        price: product.price,
        image: product.image,
        size: product.size,
        quantity: product.quantity,
        totalPrice: (product.quantity??0) * (product.price??0)
      );
      bool? anyWhere = cartItems.any((cart) => cart.name == newCart.name && cart.image == newCart.image);
      if(anyWhere==true){
        var news = cartItems.firstWhere((cart) => cart.name == newCart.name && cart.image == newCart.image);
        int index = cartItems.indexOf(news);
        var updated = CartProduct(
            name: news.name,
            price: news.price,
            image: news.image,
            size: news.size,
            quantity: (news.quantity??0) + (newCart.quantity??0),
            totalPrice: (news.totalPrice??0) + (newCart.totalPrice??0)
        );
        cartItems[index] = updated;
        showToast(context, "${product.name} has been updated in your cart", success: true);
      }else{
        cartItems.add(newCart);
      }
      showToast(context, "${product.name} has been added to your cart", success: true);
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: products.length,
        itemBuilder: (_,i){
          num quantity = products[i].quantity??0;

          addQuantity(){
            var news = Product(name: products[i].name, price: products[i].price, size: products[i].size, image: products[i].image, quantity: (quantity += 1));
            products[i] = news;
            setState(() {});
          }

          subtractQuantity(){
            if(quantity == 1){
              return;
            }else{
              var news = Product(name: products[i].name, price: products[i].price, size: products[i].size, image: products[i].image, quantity: (quantity -= 1));
              products[i] = news;
              setState(() {});
            }
          }

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black45, width: 1),
              borderRadius: BorderRadius.circular(16)
            ),
            child: Row(
              children: [
                Container(
                  height: 150,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(products[i].image??"", ),
                      fit: BoxFit.cover
                    )
                  ),
                ),
                SizedBox(width: 16,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(products[i].name??"", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(onPressed: subtractQuantity, icon: Icon(Icons.remove_circle, color: Colors.blueGrey, size: 40,)),
                          const SizedBox(width: 10,),
                          Text(quantity.toString(), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
                          const SizedBox(width: 10,),
                          IconButton(onPressed: addQuantity, icon: Icon(Icons.add_circle, color: Colors.blueGrey, size: 40,)),

                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text("\$ ${(products[i].price??0)*quantity}", style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
                      ),
                      SizedBox(height: 10,),
                      ElevatedButton(onPressed: ()=> addToCart(product: products[i]), child: Text("Add to Cart"))
                    ],
                  ),
                )
              ],
            ),
          );
        }
      ),
    );
  }
}

List<CartProduct> cartItems = [];

remove(CartProduct item){
  cartItems.removeWhere((items) => items.name == item.name && item.image == items.image);
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart Screen"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: cartItems.isEmpty? Center(
              child: Text("No Item in cart"),
            ): ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: cartItems.length,
                itemBuilder: (_,i){

                  return Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black45, width: 1),
                            borderRadius: BorderRadius.circular(16)
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                      image: AssetImage(cartItems[i].image??"", ),
                                      fit: BoxFit.cover
                                  )
                              ),
                            ),
                            const SizedBox(width: 16,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(cartItems[i].name??"", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
                                  Text("Price per unit:  \$${cartItems[i].price}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                                  Text("Quantity:  \$${cartItems[i].quantity}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                                  Text("Total Price:  \$${cartItems[i].totalPrice}", style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),),

                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: (){
                            showDialog(
                              context: context, builder: (_)=> Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 30),
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white
                                    ),
                                    child: Column(
                                      children: [
                                        Text("Remove ${cartItems[i].name}",style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600), ),
                                        const SizedBox(height: 10,),
                                        Text(
                                          "Are you sure you want to remove this ${cartItems[i].name} product from your cart",
                                          style: const TextStyle(fontSize: 13),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 30,),
                                        ElevatedButton(
                                          onPressed: (){
                                            remove(cartItems[i]);
                                            setState(() {});
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Delete Product")
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            );
                          },
                          child: Icon(
                            Icons.cancel, color: Colors.red,
                              size: 40
                          ),
                        ),
                      )
                    ],
                  );
                }
            ),
          ),
          SizedBox(
            height: 16,
          ),
          cartItems.isEmpty? SizedBox(
            height: 0,
          ): OutlinedButton(onPressed: (){
            cartItems.clear();
            setState(() {});
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_)=> const SuccessScreen()), (route) => false);
          }, child: Text("Check Out \$${getTotalPrice()}")),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}


class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(CupertinoIcons.checkmark_alt_circle_fill, size: 150, color: Colors.green,),
            const SizedBox(height: 20,),
            const Text(
              "Your order has been placed successfully",
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white
              ),
              onPressed: (){
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_)=> HomeScreen()), (route) => false);
              },
                child: const Text("Back Home")
            )
          ],
        ),
      ),
    );
  }
}


class AppImages {

  static const lohr = 'assets/images/2151099100.jpg';
  static const burger = 'assets/images/2151433866.jpg';
  static const chips = 'assets/images/2151535321.jpg';
  static const friedPlantain = 'assets/images/2151006047.jpg';
  static const fastFood = 'assets/images/2150849141.jpg';

}

num getTotalPrice() {
  return cartItems.fold(0, (sum, item) => sum + (item.totalPrice ?? 0));
}

class CartProduct {
  final String? name;
  final String? image;
  final num? quantity;
  final String? size;
  final num? price;
  final num? totalPrice;

  CartProduct({
    this.name,
    this.image,
    this.quantity,
    this.size,
    this.price,
    this.totalPrice,
  });
}
class Product {
  final String? name;
  final String? image;
  final String? size;
  final num? price;
  final num? quantity;

  Product({
    this.name,
    this.image,
    this.size,
    this.price,
    this.quantity,
  });
}

void showToast(BuildContext context, String message, {bool? success}) {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  scaffoldMessenger.showSnackBar(
    SnackBar(
      content: Text(message, style: TextStyle(fontWeight: FontWeight.w600),),
      backgroundColor: success == true? null: Colors.red,
      duration: Duration(seconds: 3), // Duration for how long the toast should be visible
    ),
  );
}