// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:petcare/src/constants/app_colors.dart';
// import 'package:petcare/src/constants/app_sizes.dart';
// import 'package:petcare/src/constants/app_text_styles.dart';
// import 'package:petcare/src/layers/data/branch_repository.dart';
// import 'package:petcare/src/layers/data/insurance_repository.dart';
// import 'package:petcare/src/layers/data/order_repository.dart';
// import 'package:petcare/src/layers/data/vaccine_repository.dart';
// import 'package:petcare/src/layers/domain/branch.dart';
// import 'package:petcare/src/layers/domain/insurance_pack.dart';
// import 'package:petcare/src/layers/domain/pet.dart';
// import 'package:petcare/src/layers/domain/vaccine.dart';
// import 'package:petcare/src/layers/presentation/screens/checkout/components/branch_card.dart';
// import 'package:petcare/src/utils/int.dart';
// import 'components/pet_card.dart';
// import 'components/item_card.dart';
// import 'package:petcare/src/common_widgets/appbar_basic.dart';
// import 'package:petcare/src/common_widgets/bottom_button_area.dart';
// import 'package:petcare/src/common_widgets/primary_button.dart';

// enum PaymentMethod { momo, paypal }

// class CheckOutScreen extends ConsumerStatefulWidget {
//   final Pet pet;
//   final String itemCategory;
//   final String itemId;

//   CheckOutScreen({
//     Key? key,
//     required this.pet,
//     required this.itemCategory,
//     required this.itemId,
//   }) : super(key: key);

//   @override
//   _CheckOutScreenState createState() => _CheckOutScreenState();
// }

// class _CheckOutScreenState extends ConsumerState<CheckOutScreen> {
//   PaymentMethod? _paymentMethod = PaymentMethod.momo;

//   @override
//   void initState() {
//     super.initState();
//   }

//   void dispose() {
//     super.dispose();
//   }


//   @override
//   Widget build(BuildContext context) {
//     String selectedBranchId = '';
//     return Scaffold(
//       backgroundColor: AppColors.lightBackground,
//       body: SafeArea(
//         bottom: false,
//         child: StreamBuilder(
//             stream: widget.itemCategory == 'vaccine'
//                 ? ref
//                     .watch(vaccineRepositoryProvider)
//                     .fetchVaccine(widget.itemId)
//                 : ref
//                     .watch(insuranceRepositoryProvider)
//                     .fetchPack(widget.itemId),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const CupertinoActivityIndicator();
//               } else if (snapshot.hasError) {
//                 return Center(child: Text('Error: ${snapshot.error}'));
//               } else {
//                 final item = snapshot.data;
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     const BasicAppBar(title: 'Checkout'),
//                     Expanded(
//                       child: SingleChildScrollView(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: proportionateWidth(24)),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(height: proportionateHeight(16)),
//                             Text('Pet',
//                                 style: AppTextStyles.bodySemiBold(
//                                     16, AppColors.grey800)),
//                             SizedBox(height: proportionateHeight(16)),
//                             PetCard(pet: widget.pet),
//                             SizedBox(height: proportionateHeight(16)),
//                             Text('Branch',
//                                 style: AppTextStyles.bodySemiBold(
//                                     16, AppColors.grey800)),
//                             SizedBox(height: proportionateHeight(16)),
//                             StreamBuilder(
//                               stream: ref
//                                   .watch(branchRepositoryProvider)
//                                   .watchBranches(),
//                               builder: (BuildContext context,
//                                   AsyncSnapshot snapshot) {
//                                 if (snapshot.connectionState ==
//                                     ConnectionState.waiting) {
//                                   return const CupertinoActivityIndicator();
//                                 } else if (snapshot.hasError) {
//                                   return Center(
//                                       child: Text('Error: ${snapshot.error}'));
//                                 } else {
//                                   List<Branch> branchList = snapshot.data;
//                                   selectedBranchId = branchList[0].id;
//                                   return CarouselSlider(
//                                     options: CarouselOptions(
//                                       height: proportionateHeight(100),
//                                       enlargeCenterPage: true,
//                                       enableInfiniteScroll: false,
//                                       onPageChanged: (index, reason) =>
//                                           selectedBranchId =
//                                               branchList[index].id,
//                                     ),
//                                     items: List.generate(
//                                       branchList.length,
//                                       (index) =>
//                                           BranchCard(branch: branchList[index]),
//                                     ),
//                                   );
//                                 }
//                               },
//                             ),
//                             SizedBox(height: proportionateHeight(16)),
//                             Text('Items',
//                                 style: AppTextStyles.bodySemiBold(
//                                     16, AppColors.grey800)),
//                             SizedBox(height: proportionateHeight(16)),
//                             widget.itemCategory == 'insurance'
//                                 ? ItemCard(insurancePack: item as InsurancePack)
//                                 : ItemCard(vaccine: item as Vaccine),
//                             SizedBox(height: proportionateHeight(16)),
//                             Text('Payment Method',
//                                 style: AppTextStyles.bodySemiBold(
//                                     16, AppColors.grey800)),
//                             SizedBox(height: proportionateHeight(16)),
//                             InkWell(
//                               onTap: () {
//                                 setState(() {
//                                   _paymentMethod = PaymentMethod.momo;
//                                 });
//                               },
//                               child: Ink(
//                                 padding: EdgeInsets.all(proportionateWidth(8)),
//                                 height: proportionateHeight(70),
//                                 width: proportionateWidth(100),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(14),
//                                   border: Border.all(
//                                     width: 2,
//                                     color: _paymentMethod == PaymentMethod.momo
//                                         ? AppColors.blue500
//                                         : AppColors.grey200,
//                                   ),
//                                 ),
//                                 child:
//                                     Image.asset('assets/images/momo-logo.png'),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: proportionateHeight(16)),
//                     BottomButtonArea(
//                       height: proportionateHeight(112),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             height: proportionateHeight(54),
//                             width: proportionateWidth(100),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text('Total:',
//                                     style: AppTextStyles.bodyRegular(
//                                         16, AppColors.grey600)),
//                                 Text(
//                                   widget.itemCategory == 'insurance'
//                                       ? (item as InsurancePack)
//                                           .price
//                                           .formatPrice()
//                                       : (item as Vaccine)
//                                           .sellingPrice
//                                           .formatPrice(),
//                                   textAlign: TextAlign.end,
//                                   style: AppTextStyles.bodySemiBold(
//                                       18, AppColors.grey800),
//                                 )
//                               ],
//                             ),
//                           ),
//                           Expanded(
//                             child: PrimaryButton(
//                               text: 'Confirm',
//                               press: () async {
//                                 final int orderTotal =
//                                     widget.itemCategory == 'insurance'
//                                         ? (item as InsurancePack).price
//                                         : (item as Vaccine).sellingPrice;
//                                 final orderRef = await ref
//                                     .read(orderRepositoryProvider)
//                                     .createOrder(
//                                         petId: widget.pet.id,
//                                         branchId: selectedBranchId,
//                                         itemCategory: widget.itemCategory,
//                                         items: [widget.itemId],
//                                         total: orderTotal,
//                                         dateCompleted: DateTime.now()
//                                             .add(const Duration(days: 30)))
//                                     .then((_) => context.pop());
//                               },
//                               enable: true,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 );
//               }
//             }),
//       ),
//     );
//   }
// }
