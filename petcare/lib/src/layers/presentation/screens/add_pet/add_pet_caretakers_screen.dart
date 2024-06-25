// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:petcare/src/constants/app_colors.dart';
// import 'package:petcare/src/constants/app_sizes.dart';
// import 'package:petcare/src/constants/app_text_styles.dart';
// import 'package:petcare/src/layers/application/contact.dart';
// import 'package:petcare/src/layers/domain/contact.dart';
// import 'package:petcare/src/layers/presentation/controllers/auth/auth_controller.dart';
// import 'package:petcare/src/layers/presentation/controllers/dashboard/dashboard_binding.dart';
// import 'package:petcare/src/layers/presentation/screens/add_pet_profile/components/contact_card.dart';
// import 'package:petcare/src/layers/presentation/screens/components/primary_button.dart';
// import 'package:petcare/src/layers/presentation/screens/dashboard/dashboard_screen.dart';

// import '../components/appbar_with_step.dart';
// import '../components/bottom_button_area.dart';

// class APPCaretakersScreen extends StatefulWidget {
//   static String routeName = "/add_pet_profile_caretakers";

//   @override
//   _APPCaretakersScreenState createState() => _APPCaretakersScreenState();
// }

// class _APPCaretakersScreenState extends State<APPCaretakersScreen> {
//   String searchText = '';
//   List<Contact> contactData = ContactService.addedContactData;

//   List<Contact> filteredContacts() {
//     return contactData.where((contact) {
//       final String lowerCaseSearchText = searchText.toLowerCase();

//       return contact.firstName.toLowerCase().contains(lowerCaseSearchText) ||
//           contact.lastName.toLowerCase().contains(lowerCaseSearchText) ||
//           contact.role.toLowerCase().contains(lowerCaseSearchText) ||
//           contact.email.toLowerCase().contains(lowerCaseSearchText);
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         bottom: false,
//         child: Column(
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(
//                   horizontal: proportionateWidth(24)),
//               child: const AppBarWithStep(
//                 title: 'Add Pet Profile',
//                 stepName: 'Caretakes',
//                 step: 9,
//                 totalStep: 8,
//               ),
//             ),
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: EdgeInsets.symmetric(
//                     horizontal: proportionateWidth(24)),
//                 child: Column(
//                   children: [
//                     SizedBox(height: proportionateHeight(24)),
//                     // Section 1 - Avatar content
//                     Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         SizedBox(
//                           height: proportionateHeight(166),
//                           width: proportionateWidth(166),
//                           child: Image.asset(
//                             'assets/images/pet-avatar-effect.png',
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         CircleAvatar(
//                           radius: proportionateWidth(50),
//                           backgroundImage: AuthController
//                                       .instance.newPet.photoURL ==
//                                   null
//                               ? AssetImage(
//                                       'assets/images/default_pet_avatar.png')
//                                   as ImageProvider<Object>
//                               : FileImage(File(
//                                   AuthController.instance.newPet.photoURL!)),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: proportionateHeight(24)),
//                     // Section 2 - Search bar
//                     SizedBox(
//                       height: proportionateHeight(54),
//                       child: CupertinoSearchTextField(
//                         style: AppTextStyles.bodyRegular(16, AppColors.grey600),
//                         placeholder: 'Search by name, tag, email...',
//                         decoration: BoxDecoration(
//                           border: Border.all(color: AppColors.grey200),
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                         onChanged: (value) {
//                           setState(() {
//                             searchText = value;
//                           });
//                         },
//                       ),
//                     ),
//                     SizedBox(height: proportionateHeight(24)),
//                     Container(
//                       alignment: Alignment.centerLeft,
//                       height: proportionateHeight(20),
//                       child: Text(
//                         "Added contacts",
//                         style:
//                             AppTextStyles.bodySemiBold(14, AppColors.grey800),
//                       ),
//                     ),

//                     // Section 3 - List View
//                     ListView.builder(
//                       physics: const NeverScrollableScrollPhysics(),
//                       shrinkWrap: true,
//                       itemCount: filteredContacts().length,
//                       itemBuilder: (context, index) {
//                         return ContactCard(contact: filteredContacts()[index]);
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Section 4 - Bottom Buttons Area
//             BottomButtonArea(
//               height: proportionateHeight(112),
//               children: [
//                 PrimaryButton(
//                   text: 'Continue',
//                   press: () async {
//                     // AuthController.instance.newPet
//                     //     .setCaretakers(controller.textController.text);
//                     await AuthController.instance.newPet.createOnFirestore();
//                     Get.offAll(
//                       () => DashboardScreen(),
//                       binding: DashboardBinding(),
//                     );
//                   },
//                   enable: true,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
