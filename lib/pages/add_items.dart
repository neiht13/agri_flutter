import 'package:agriplant/data/products.dart';
import 'package:agriplant/widgets/custom_btn.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../widgets/added_items.dart';

class AddItemsPage extends StatefulWidget {
  const AddItemsPage({super.key});

  @override
  State<AddItemsPage> createState() => _AddItemsPageState();
}

class _AddItemsPageState extends State<AddItemsPage> {
  final cartItems = products.take(4).toList();

  @override
  Widget build(BuildContext context) {
    final total =
        cartItems.map((cartItem) => cartItem.price).reduce((value, element) => value + element).toStringAsFixed(2);
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
             BounceInDown(child: CustomBtn(icon: Icons.add, text: "Add Items",onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddItemsField())),)),
            const SizedBox(height: 20,),
            ...List.generate(
              cartItems.length,
              (index) {
                final cartItem = cartItems[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: AddItems(cartItem: cartItem),
                );
              },
            ),
            const SizedBox(height: 15),
            
          ],
        ),
      ),
    );
  }
}

class AddItemsField extends StatelessWidget {
  const AddItemsField({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 250,
                            width: MediaQuery.of(context).size.width * 0.8,
                            margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.09),
                            child: Image.asset("assets/login.png"),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // InputField(hintText: "Name"),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // InputField(hintText: "Category"),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // InputField(hintText: "Unit"),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // InputField(hintText: "Quantity"),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // InputField(hintText: "Price"),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // InputField(hintText: "Duration"),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Description",
                  border: InputBorder.none,

                ),
              ),
            )
            ),
            const SizedBox(
                            height: 10,
                          ),
                         BounceInUp(child: const CustomBtn(icon: Icons.upload, text: "Upload"))
                         
                        ],
                      ),
                    ),
                  ),
    );
  }
}
