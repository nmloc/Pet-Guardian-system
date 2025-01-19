import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:petcare_staff/src/constants/app_colors.dart';
import 'package:petcare_staff/src/constants/app_sizes.dart';
import 'package:petcare_staff/src/constants/app_text_styles.dart';
import 'package:petcare_staff/src/layers/data/grooming_repository.dart';
import 'package:petcare_staff/src/layers/data/insurance_repository.dart';
import 'package:petcare_staff/src/layers/data/order_repository.dart';
import 'package:petcare_staff/src/layers/data/pet_repository.dart';
import 'package:petcare_staff/src/layers/data/vaccine_repository.dart';
import 'package:petcare_staff/src/layers/domain/grooming_service.dart';
import 'package:petcare_staff/src/layers/domain/insurance_pack.dart';
import 'package:petcare_staff/src/layers/domain/order.dart';
import 'package:petcare_staff/src/layers/domain/vaccine.dart';
import 'package:petcare_staff/src/utils/datetime.dart';

import 'primary_button.dart';

class TaskBottomSheet extends ConsumerWidget {
  final String taskId;
  const TaskBottomSheet(this.taskId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _notesController = TextEditingController();
    Widget section(
        {required String title,
        required Map<dynamic, dynamic> items,
        bool useStream = false,
        String category = '',
        int? maxLines}) {
      Stream getStream(id) {
        if (category == "Grooming") {
          return ref.read(groomingRepositoryProvider).watch(id);
        } else if (category == "Vaccine") {
          return ref.read(vaccineRepositoryProvider).watch(id);
        } else {
          return ref.read(insuranceRepositoryProvider).watch(id);
        }
      }

      String getItemName(Equatable? data) {
        if (category == "Grooming") {
          return (data as GroomingService).name;
        } else if (category == "Vaccine") {
          return (data as Vaccine).name;
        } else {
          return (data as InsurancePack).name;
        }
      }

      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.bodyMedium(14, AppColors.grey800),
            ),
            SizedBox(height: proportionateHeight(12)),
            Row(
              mainAxisAlignment: items.length > 2
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.start,
              children: items.entries
                  .map(
                    (entry) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: entry.key != '' && entry.key is String
                              ? proportionateHeight(42)
                              : proportionateHeight(20),
                          width: 1,
                          color: AppColors.grey150,
                        ),
                        SizedBox(width: proportionateWidth(12)),
                        SizedBox(
                          width: (AppSizes.screenWidth -
                                  proportionateWidth(48) -
                                  proportionateWidth(13) * items.length) /
                              items.length,
                          child: useStream
                              ? StreamBuilder(
                                  stream: getStream(entry.value),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CupertinoActivityIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    } else {
                                      return Text(
                                        getItemName(snapshot.data),
                                        style: AppTextStyles.bodySemiBold(
                                            14, AppColors.grey800),
                                      );
                                    }
                                  },
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (entry.key != '' && entry.key is String)
                                      Text(
                                        entry.key,
                                        style: AppTextStyles.bodyRegular(
                                            14, AppColors.grey700),
                                      ),
                                    Text(
                                      entry.value,
                                      style: AppTextStyles.bodySemiBold(
                                          14, AppColors.grey800),
                                      maxLines: maxLines,
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      );
    }

    return SafeArea(
      bottom: false,
      child: StreamBuilder(
        stream: ref.read(orderRepositoryProvider).watch(taskId),
        builder: (context, taskSnapshot) {
          if (taskSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          } else if (taskSnapshot.hasError) {
            return Center(child: Text('Error: ${taskSnapshot.error}'));
          } else {
            OrderModel order = taskSnapshot.data!;
            return Container(
              color: AppColors.grey0,
              height: order.dateCompleted.isDefault()
                  ? proportionateWidth(470)
                  : proportionateWidth(350),
              padding: EdgeInsets.all(proportionateHeight(24)),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.itemCategory,
                          style:
                              AppTextStyles.bodySemiBold(16, AppColors.grey800),
                        ),
                        SizedBox(height: proportionateHeight(24)),
                        StreamBuilder(
                          stream: ref
                              .read(petRepositoryProvider)
                              .watchPet(order.petId),
                          builder: (context, petSnapshot) {
                            if (petSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CupertinoActivityIndicator());
                            } else if (petSnapshot.hasError) {
                              return Center(
                                child: Text(
                                  "The pet profile was deleted by the pet owner.",
                                  style: AppTextStyles.bodyRegular(
                                      14, AppColors.grey700),
                                ),
                              );
                            } else {
                              return section(
                                title: 'Pet',
                                items: {
                                  'Name': petSnapshot.data!.name,
                                  'Species': petSnapshot.data!.species,
                                },
                              );
                            }
                          },
                        ),
                        SizedBox(height: proportionateHeight(24)),
                        section(
                          title: 'Items',
                          items: order.items.asMap(),
                          useStream: true,
                          category: order.itemCategory,
                        ),
                        SizedBox(height: proportionateHeight(24)),
                        order.dateCompleted.isDefault()
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Notes',
                                    style: AppTextStyles.bodyMedium(
                                        14, AppColors.grey800),
                                  ),
                                  SizedBox(height: proportionateHeight(12)),
                                  TextField(
                                    controller: _notesController,
                                    decoration: InputDecoration(
                                      hintText: 'No bad reaction',
                                      filled: true,
                                      fillColor: AppColors.grey0,
                                    ),
                                    cursorColor: AppColors.grey800,
                                    maxLength: 250,
                                    maxLines: 3,
                                    onTapOutside: (value) {
                                      FocusScopeNode currentNode =
                                          FocusScope.of(context);
                                      if (currentNode.focusedChild != null &&
                                          !currentNode.hasPrimaryFocus) {
                                        FocusManager.instance.primaryFocus!
                                            .unfocus();
                                      }
                                    },
                                  ),
                                ],
                              )
                            : section(
                                title: 'Notes',
                                items: {'': order.notes},
                                maxLines: 6,
                              ),
                        SizedBox(height: proportionateHeight(12)),
                      ],
                    ),
                  ),
                  if (order.dateCompleted.isDefault())
                    PrimaryButton(
                      text: 'Complete',
                      press: () {
                        ref.read(orderRepositoryProvider).update(
                            order.id,
                            _notesController.text,
                            order.itemCategory == "Insurance"
                                ? order.dateRequired
                                    .add(const Duration(days: 30))
                                : null);
                        context.pop();
                      },
                      enable: true,
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
