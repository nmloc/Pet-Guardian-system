// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:petcare_store_owner/src/constants/app_colors.dart';
// import 'package:petcare_store_owner/src/constants/app_sizes.dart';
// import 'package:petcare_store_owner/src/layers/application/pet.dart';
// import 'package:petcare_store_owner/src/layers/application/product.dart';
// import 'package:petcare_store_owner/src/layers/domain/pet.dart';
// import 'package:petcare_store_owner/src/layers/domain/product.dart';

// import '../components/item_card.dart';
// import '../dashboard/components/drawer.dart';

// class ShopScreen extends StatefulWidget {
//   static String routeName = "/shop";
//   @override
//   _ShopScreenState createState() => _ShopScreenState();
// }

// class _ShopScreenState extends State<ShopScreen> {

//   @override
//   Widget build(BuildContext context) {
//     List<Product> productData = ProductService.productData;
//     List<String> advertisementList = [
//       'assets/images/advertisement_1.jpg',
//       'assets/images/advertisement_2.jpg',
//     ];

//     List<Pet> petList = PetService.petData;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Profile"),
//         actions: [
//           IconButton(
//               onPressed: () {},
//               icon: const Icon(IconData(0xe3dc, fontFamily: 'MaterialIcons')))
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: proportionateHeight(20)),
//               CarouselSlider(
//                 options: CarouselOptions(
//                   height: proportionateHeight(120),
//                   autoPlay: true, // Auto-play the carousel
//                   enlargeCenterPage: true, // Make the centered item larger
//                 ),
//                 items: advertisementList.map((photoURL) {
//                   return Builder(
//                     builder: (BuildContext context) {
//                       return Container(
//                         width: MediaQuery.of(context).size.width,
//                         margin: EdgeInsets.symmetric(horizontal: 5.0),
//                         child: Image.asset(
//                           photoURL,
//                           fit: BoxFit.cover,
//                         ),
//                       );
//                     },
//                   );
//                 }).toList(),
//               ),
//               SizedBox(height: proportionateHeight(20)),
//               Text(
//                 'Select your pet',
//                 style: TextStyle(
//                     color: AppColors.lightGray,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w400),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 child: Wrap(
//                   spacing: 16,
//                   runSpacing: 16,
//                   children: List.generate(
//                     productData.length,
//                     (index) => ItemCard(
//                       product: productData[index],
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//       // drawer: DrawerWidget(),
//     );
//   }
// }
