// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';
import 'package:petcare/src/layers/application/location_service.dart';
import 'package:petcare/src/layers/application/pet_service.dart';
import 'package:petcare/src/layers/data/auth_repository.dart';
import 'package:petcare/src/layers/data/branch_repository.dart';
import 'package:petcare/src/layers/data/grooming_repository.dart';
import 'package:petcare/src/layers/data/insurance_repository.dart';
import 'package:petcare/src/layers/data/order_repository.dart';
import 'package:petcare/src/layers/data/payment_repository.dart';
import 'package:petcare/src/layers/data/staff_repository.dart';
import 'package:petcare/src/layers/data/vaccine_repository.dart';
import 'package:petcare/src/layers/domain/branch.dart';
import 'package:petcare/src/layers/domain/grooming_service.dart';
import 'package:petcare/src/layers/domain/insurance_pack.dart';
import 'package:petcare/src/layers/domain/staff.dart';
import 'package:petcare/src/layers/domain/vaccine.dart';
import 'package:petcare/src/layers/presentation/common_widgets/appbar_with_pet.dart';
import 'package:petcare/src/layers/presentation/common_widgets/calendar_carousel.dart';
import 'package:petcare/src/layers/presentation/common_widgets/card_container.dart';
import 'package:petcare/src/layers/presentation/common_widgets/primary_button.dart';
import 'package:petcare/src/utils/int.dart';

final _branchProvider = StateProvider<String>((ref) => '');
final _staffProvider = StateProvider<String>((ref) => '');
final _dateProvider = StateProvider<DateTime>((ref) => DateTime.now());
final _availabilityProvider = StateProvider<String>((ref) => '');
final _haircutProvider = StateProvider<bool>((ref) => false);
final _bathProvider = StateProvider<bool>((ref) => false);
final _nailProvider = StateProvider<bool>((ref) => false);
final _selectedGroomingIdProvider = StateProvider<List<String>>((ref) => []);
final _selectedGroomingPriceProvider = StateProvider<int>((ref) => 0);
final _itemPriceProvider = StateProvider<int>((ref) => 0);

StateProvider<bool> getGroomingServiceProvider(String serviceName) {
  if (serviceName == 'Haircut') {
    return _haircutProvider;
  } else if (serviceName == 'Bath') {
    return _bathProvider;
  } else {
    return _nailProvider;
  }
}

class BookingScreen extends ConsumerWidget {
  final String category;
  final String? itemId;
  const BookingScreen({required this.category, this.itemId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.invalidate(_branchProvider);
    ref.invalidate(_dateProvider);
    ref.invalidate(_availabilityProvider);
    ref.invalidate(_haircutProvider);
    ref.invalidate(_bathProvider);
    ref.invalidate(_nailProvider);
    ref.invalidate(_selectedGroomingIdProvider);
    ref.invalidate(_selectedGroomingPriceProvider);
    ref.invalidate(_itemPriceProvider);

    Future<void> initPaymentSheet({
      required String name,
      required String address,
      required String pin,
      required String city,
      required String state,
      required String country,
      required String amount,
    }) async {
      try {
        final data = await ref
            .read(paymentRepositoryProvider)
            .createStripePaymentIntent(
                name: name,
                address: address,
                pin: pin,
                city: city,
                state: state,
                country: country,
                amount: amount);

        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            // Set to true for custom flow
            customFlow: false,
            // Main params
            merchantDisplayName: 'Pet Guardian',
            paymentIntentClientSecret: data['client_secret'],
            // Customer keys
            customerEphemeralKeySecret: data['ephemeralKey'],
            customerId: data['id'],

            style: ThemeMode.light,
          ),
        );
      } catch (e) {
        Fluttertoast.showToast(msg: "Error: $e", timeInSecForIosWeb: 4);
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppBarWithPet(
              service: '$category Booking',
              isPetProfile: false,
            ),
            Expanded(
              child: StreamBuilder(
                stream: ref.read(branchRepositoryProvider).watchBranches(),
                builder: (BuildContext context, AsyncSnapshot branchSnapshot) {
                  if (branchSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const CupertinoActivityIndicator();
                  } else if (branchSnapshot.hasError) {
                    return Center(
                        child: Text('Error: ${branchSnapshot.error}'));
                  } else {
                    List<Branch> branches = branchSnapshot.data;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ref.read(_branchProvider.notifier).state = branches[0].id;
                    });

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: proportionateHeight(24)),
                          CarouselSlider(
                            options: CarouselOptions(
                              height: proportionateHeight(148),
                              enlargeCenterPage: true,
                              viewportFraction: 0.9,
                              enlargeFactor: 0.1,
                              enableInfiniteScroll: false,
                              onPageChanged: (index, reason) {
                                ref.invalidate(_staffProvider);
                                ref.invalidate(_availabilityProvider);
                                ref.read(_branchProvider.notifier).state =
                                    branches[index].id;
                              },
                            ),
                            items: branches
                                .map((branch) => _BranchCard(branch: branch))
                                .toList(),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: proportionateHeight(20)),
                            child: CalendarCarousel(
                              initialDate: ref.read(_dateProvider),
                              selectedDateProvider: _dateProvider,
                            ),
                          ),
                          const _TitleWidget('Availability'),
                          SizedBox(height: proportionateHeight(16)),
                          const _AvailabilityWidget(),
                          const _Divider(),
                          _TitleWidget(category == "Grooming"
                              ? 'Groomer'
                              : 'Veterinarian'),
                          SizedBox(height: proportionateHeight(16)),
                          _StaffWidget(),
                          const _Divider(),
                          _TitleWidget(
                              category == "Grooming" ? 'Services' : category),
                          if (category == "Grooming") _GroomingWidget(),
                          if (category == "Vaccine") _VaccineWidget(itemId!),
                          if (category == "Insurance")
                            _InsuranceWidget(itemId!),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: proportionateWidth(24),
                            ),
                            child: Text(
                              'Prices are estimative and the payment will be made at the location.',
                              style: AppTextStyles.bodyRegular(
                                  14, AppColors.grey600),
                              maxLines: 5,
                            ),
                          ),
                          const _Divider(),
                          _ConfirmButton(
                            category: category,
                            press: () async {
                              List<String> _items = [];
                              int _total = 0;
                              if (category == "Grooming") {
                                _items = ref.read(_selectedGroomingIdProvider);
                                _total =
                                    ref.read(_selectedGroomingPriceProvider);
                              } else {
                                _items = [itemId!];
                                _total = ref.read(_itemPriceProvider);
                              }
                              List<String> availableTime =
                                  ref.read(_availabilityProvider).split(':');
                              DateTime _dateRequired = DateTime(
                                ref.read(_dateProvider).year,
                                ref.read(_dateProvider).month,
                                ref.read(_dateProvider).day,
                                int.parse(availableTime[0]),
                                int.parse(availableTime[1]),
                              );
                              if (category == "Insurance") {
                                ref
                                    .read(orderRepositoryProvider)
                                    .createOrder(
                                        petId: ref.read(selectedPetIdProvider),
                                        branchId: ref.read(_branchProvider),
                                        itemCategory: category,
                                        items: _items,
                                        total: _total,
                                        dateRequired: _dateRequired,
                                        staffId: ref.read(_staffProvider))
                                    .then((_) => context.pop());
                              } else {
                                try {
                                  await initPaymentSheet(
                                    name: ref
                                        .read(authRepositoryProvider)
                                        .currentUser!
                                        .displayName!,
                                    address: '854 Ta Quang Buu',
                                    pin: '70000',
                                    city: 'Ho Chi Minh',
                                    state: 'VN',
                                    country: 'VN',
                                    amount: _total.toString(),
                                  ).then(
                                    (_) => Stripe.instance
                                        .presentPaymentSheet()
                                        .then(
                                          (_) => ref
                                              .read(orderRepositoryProvider)
                                              .createOrder(
                                                  petId: ref.read(
                                                      selectedPetIdProvider),
                                                  branchId:
                                                      ref.read(_branchProvider),
                                                  itemCategory: category,
                                                  items: _items,
                                                  total: _total,
                                                  dateRequired: _dateRequired,
                                                  paid: true,
                                                  staffId:
                                                      ref.read(_staffProvider))
                                              .then((_) => context.pop()),
                                        ),
                                  );
                                } catch (e) {
                                  print(e);
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TitleWidget extends StatelessWidget {
  final String text;
  final TextStyle? style;
  const _TitleWidget(this.text, {Key? key, this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: proportionateWidth(24)),
        child: Text(
          text,
          style: style ?? AppTextStyles.bodySemiBold(16, AppColors.grey800),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: proportionateHeight(1),
      margin: EdgeInsets.symmetric(
        vertical: proportionateHeight(20),
        horizontal: proportionateWidth(24),
      ),
      color: AppColors.grey150,
    );
  }
}

class _AvailabilityItemWidget extends ConsumerWidget {
  final String text;
  final bool isAvailable;

  const _AvailabilityItemWidget({
    super.key,
    required this.text,
    this.isAvailable = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        if (isAvailable) {
          ref.read(_availabilityProvider.notifier).state = text;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isAvailable
              ? text == ref.watch(_availabilityProvider)
                  ? AppColors.blue100
                  : AppColors.grey0
              : AppColors.grey150,
          border: Border.all(
              color: text == ref.watch(_availabilityProvider)
                  ? AppColors.blue500
                  : AppColors.grey200),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyles.bodyMedium(
                14,
                text == ref.watch(_availabilityProvider)
                    ? AppColors.blue500
                    : AppColors.grey600),
          ),
        ),
      ),
    );
  }
}

class _AvailabilityWidget extends ConsumerWidget {
  const _AvailabilityWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      child: GridView.count(
          padding: EdgeInsets.symmetric(horizontal: proportionateWidth(24)),
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          childAspectRatio: 72.75 / 46,
          children: [9, 10, 11, 12, 13, 14, 15, 16]
              .map(
                (businessHour) => FutureBuilder<bool>(
                  future: ref.read(orderRepositoryProvider).isAvailable(
                        ref.watch(_staffProvider),
                        DateTime(
                          ref.watch(_dateProvider).year,
                          ref.watch(_dateProvider).month,
                          ref.watch(_dateProvider).day,
                          businessHour,
                        ),
                      ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CupertinoActivityIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      return _AvailabilityItemWidget(
                        text: "${(businessHour).toString().padLeft(2, '0')}:00",
                        isAvailable: snapshot.data!,
                      );
                    }
                  },
                ),
              )
              .toList()),
    );
  }
}

class _ConfirmButton extends ConsumerWidget {
  final String category;
  final void Function() press;

  const _ConfirmButton({
    super.key,
    required this.category,
    required this.press,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: proportionateWidth(24)),
      child: PrimaryButton(
        text: 'Confirm booking',
        press: press,
        enable: category == "Grooming"
            ? (ref.watch(_haircutProvider) ||
                    ref.watch(_bathProvider) ||
                    ref.watch(_nailProvider)) &&
                ref.watch(_availabilityProvider) != ''
            : ref.watch(_availabilityProvider) != '',
      ),
    );
  }
}

class _BranchCard extends ConsumerWidget {
  final Branch branch;

  const _BranchCard({
    super.key,
    required this.branch,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(14)),
      child: Container(
        width: proportionateWidth(327),
        color: AppColors.blue500,
        child: Stack(
          children: [
            Positioned(
              right: -25,
              top: -35,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grey0.withOpacity(0.08),
                      spreadRadius: 10,
                    ),
                    BoxShadow(
                      color: AppColors.grey0.withOpacity(0.04),
                      spreadRadius: 25,
                    ),
                    BoxShadow(
                      color: AppColors.grey0.withOpacity(0.04),
                      spreadRadius: 40,
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/images/grooming-background.png'),
                  radius: 50,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: proportionateWidth(20),
                vertical: proportionateHeight(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: proportionateWidth(210),
                    child: Text(
                      branch.name,
                      style: AppTextStyles.bodySemiBold(20, AppColors.grey0),
                    ),
                  ),
                  SizedBox(height: proportionateHeight(6)),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 26,
                        color: AppColors.grey150,
                      ),
                      SizedBox(height: proportionateHeight(6)),
                      SizedBox(
                        width: proportionateWidth(220),
                        child: Text(
                          branch.address(),
                          style:
                              AppTextStyles.bodyMedium(14, AppColors.grey100),
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: proportionateHeight(6)),
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.location,
                        size: 20,
                        color: AppColors.grey150,
                      ),
                      SizedBox(width: proportionateWidth(4)),
                      ref.watch(locationServiceProvider).when(
                            data: (data) => data == null
                                ? SizedBox(
                                    width: proportionateWidth(150),
                                    child: Text(
                                      "Please grant location permission",
                                      style: AppTextStyles.bodyRegular(
                                          14, AppColors.grey600),
                                    ),
                                  )
                                : Text(
                                    "${const Distance().as(
                                      LengthUnit.Kilometer,
                                      LatLng(branch.lat_long.latitude,
                                          branch.lat_long.longitude),
                                      LatLng(data.latitude!, data.longitude!),
                                    )} km",
                                    style: AppTextStyles.bodyMedium(
                                        14, AppColors.grey100),
                                  ),
                            loading: () => const CupertinoActivityIndicator(),
                            error: (error, stackTrace) => SizedBox(
                              width: proportionateWidth(150),
                              child: Text(
                                error.toString(),
                                style: AppTextStyles.bodyMedium(
                                    14, AppColors.grey100),
                              ),
                            ),
                          )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroomingItemWidget extends ConsumerWidget {
  final String id;
  final String name;
  final int price;
  final StateProvider<bool> provider;

  const _GroomingItemWidget({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    required this.provider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        if (name == 'Haircut') {
          ref.read(_haircutProvider.notifier).state =
              !ref.read(_haircutProvider);
          if (ref.read(_haircutProvider)) {
            ref.read(_selectedGroomingIdProvider.notifier).state.add(id);
            ref.read(_selectedGroomingPriceProvider.notifier).state += price;
          } else {
            ref.read(_selectedGroomingIdProvider.notifier).state.remove(id);
            ref.read(_selectedGroomingPriceProvider.notifier).state -= price;
          }
        } else if (name == 'Bath') {
          ref.read(_bathProvider.notifier).state = !ref.read(_bathProvider);
          if (ref.read(_bathProvider)) {
            ref.read(_selectedGroomingIdProvider.notifier).state.add(id);
            ref.read(_selectedGroomingPriceProvider.notifier).state += price;
          } else {
            ref.read(_selectedGroomingIdProvider.notifier).state.remove(id);
            ref.read(_selectedGroomingPriceProvider.notifier).state -= price;
          }
        } else {
          ref.read(_nailProvider.notifier).state = !ref.read(_nailProvider);
          if (ref.read(_nailProvider)) {
            ref.read(_selectedGroomingIdProvider.notifier).state.add(id);
            ref.read(_selectedGroomingPriceProvider.notifier).state += price;
          } else {
            ref.read(_selectedGroomingIdProvider.notifier).state.remove(id);
            ref.read(_selectedGroomingPriceProvider.notifier).state -= price;
          }
        }
      },
      child: CardContainer(
        height: proportionateHeight(56),
        child: Row(
          children: [
            ref.watch(provider)
                ? Container(
                    height: proportionateHeight(18),
                    width: proportionateWidth(16),
                    decoration: BoxDecoration(
                      color: AppColors.blue500,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      String.fromCharCode(Icons.check.codePoint),
                      style: TextStyle(
                        inherit: false,
                        color: AppColors.grey0,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        fontFamily: Icons.check.fontFamily,
                        package: Icons.check.fontPackage,
                      ),
                    ),
                  )
                : Container(
                    height: proportionateHeight(18),
                    width: proportionateWidth(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.grey300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
            SizedBox(width: proportionateWidth(10)),
            Expanded(
              child: Text(
                name,
                style: AppTextStyles.bodySemiBold(14, AppColors.grey800),
              ),
            ),
            Text(
              price.formatPrice(),
              style: AppTextStyles.bodySemiBold(20, AppColors.grey900),
            ),
            SizedBox(width: proportionateWidth(10)),
            Text(
              'VND',
              style: AppTextStyles.bodyRegular(12, AppColors.grey900),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroomingWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<GroomingService>>(
        stream: ref.read(groomingRepositoryProvider).watchServices(),
        builder: (context, groomingServiceSnapshot) {
          if (groomingServiceSnapshot.connectionState ==
              ConnectionState.waiting) {
            return const CupertinoActivityIndicator();
          } else if (groomingServiceSnapshot.hasError) {
            return Center(
                child: Text('Error: ${groomingServiceSnapshot.error}'));
          } else {
            List<GroomingService> groomingServiceList =
                groomingServiceSnapshot.data!;
            return Container(
              padding: EdgeInsets.symmetric(
                vertical: proportionateHeight(16),
                horizontal: proportionateWidth(24),
              ),
              height: proportionateHeight(232),
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                separatorBuilder: (context, index) =>
                    SizedBox(height: proportionateHeight(16)),
                itemBuilder: (context, index) => _GroomingItemWidget(
                  id: groomingServiceList[index].id,
                  name: groomingServiceList[index].name,
                  price: groomingServiceList[index].price,
                  provider: getGroomingServiceProvider(
                      groomingServiceList[index].name),
                ),
              ),
            );
          }
        });
  }
}

class _VaccineWidget extends ConsumerWidget {
  final String vaccineId;
  const _VaccineWidget(this.vaccineId);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<Vaccine>(
      stream: ref.read(vaccineRepositoryProvider).watch(vaccineId),
      builder: (context, vaccineSnapshot) {
        if (vaccineSnapshot.connectionState == ConnectionState.waiting) {
          return const CupertinoActivityIndicator();
        } else if (vaccineSnapshot.hasError) {
          return Center(child: Text('Error: ${vaccineSnapshot.error}'));
        } else {
          Vaccine vaccine = vaccineSnapshot.data!;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(_itemPriceProvider.notifier).state = vaccine.price;
          });
          // ref.read(_itemPriceProvider.notifier).state = vaccine.price;
          return CardContainer(
            height: proportionateHeight(56),
            margin: EdgeInsets.symmetric(
              horizontal: proportionateWidth(24),
              vertical: proportionateHeight(16),
            ),
            child: Row(
              children: [
                Image.network(vaccine.photoURL),
                SizedBox(width: proportionateWidth(10)),
                Expanded(
                  child: Text(
                    vaccine.name,
                    style: AppTextStyles.bodySemiBold(14, AppColors.grey800),
                    maxLines: 2,
                  ),
                ),
                SizedBox(width: proportionateWidth(10)),
                Text(
                  vaccine.price.formatPrice(),
                  style: AppTextStyles.bodySemiBold(20, AppColors.grey900),
                ),
                SizedBox(width: proportionateWidth(10)),
                Text(
                  'VND',
                  style: AppTextStyles.bodyRegular(12, AppColors.grey900),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class _InsuranceWidget extends ConsumerWidget {
  final String packId;
  const _InsuranceWidget(this.packId);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<InsurancePack>(
      stream: ref.read(insuranceRepositoryProvider).watch(packId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CupertinoActivityIndicator();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          InsurancePack pack = snapshot.data!;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(_itemPriceProvider.notifier).state = pack.price;
          });
          // ref.read(_itemPriceProvider.notifier).state = vaccine.price;
          return CardContainer(
            height: proportionateHeight(56),
            margin: EdgeInsets.symmetric(
              horizontal: proportionateWidth(24),
              vertical: proportionateHeight(16),
            ),
            child: Row(
              children: [
                Image.network(pack.photoURL),
                SizedBox(width: proportionateWidth(10)),
                Expanded(
                  child: Text(
                    pack.name,
                    style: AppTextStyles.bodySemiBold(14, AppColors.grey800),
                    maxLines: 2,
                  ),
                ),
                SizedBox(width: proportionateWidth(10)),
                Text(
                  pack.price.formatPrice(),
                  style: AppTextStyles.bodySemiBold(20, AppColors.grey900),
                ),
                SizedBox(width: proportionateWidth(10)),
                Text(
                  'VND',
                  style: AppTextStyles.bodyRegular(12, AppColors.grey900),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class _StaffItemWidget extends StatelessWidget {
  final Staff staff;
  const _StaffItemWidget(this.staff, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: proportionateHeight(80),
      padding: EdgeInsets.symmetric(
        horizontal: proportionateWidth(16),
        vertical: proportionateHeight(13),
      ),
      decoration: BoxDecoration(
        color: AppColors.grey0,
        border: Border.all(color: AppColors.grey150),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            foregroundImage: staff.photoURL == ''
                ? const AssetImage('assets/images/default_user_avatar.jpg')
                    as ImageProvider
                : NetworkImage(staff.photoURL),
            radius: proportionateHeight(27),
          ),
          SizedBox(width: proportionateWidth(10)),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  staff.displayName,
                  style: AppTextStyles.bodySemiBold(14, AppColors.grey800),
                ),
                SizedBox(height: proportionateHeight(2)),
                Text(
                  staff.email,
                  style: AppTextStyles.bodyRegular(14, AppColors.grey600),
                ),
              ],
            ),
          ),
          Image.asset(
            "assets/images/signature.png",
            height: proportionateHeight(45),
            width: proportionateWidth(80),
          )
        ],
      ),
    );
  }
}

class _StaffWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<Staff>>(
      stream: ref
          .read(staffRepositoryProvider)
          .watchStaffs(ref.watch(_branchProvider)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CupertinoActivityIndicator();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Staff> staffs = snapshot.data!;
          if (staffs.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(_staffProvider.notifier).state = staffs[0].uid;
            });
          }
          return staffs.isEmpty
              ? Center(
                  child: Text(
                    "This store is temporarily not recruiting any staffs.",
                    style: AppTextStyles.bodyRegular(
                      14,
                      AppColors.grey600,
                    ),
                    maxLines: 2,
                  ),
                )
              : CarouselSlider(
                  options: CarouselOptions(
                    height: proportionateHeight(78),
                    enlargeCenterPage: true,
                    viewportFraction: 0.85,
                    enlargeFactor: 0.25,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      ref.invalidate(_availabilityProvider);
                      ref.read(_staffProvider.notifier).state =
                          staffs[index].uid;
                    },
                  ),
                  items:
                      staffs.map((staff) => _StaffItemWidget(staff)).toList(),
                );
        }
      },
    );
  }
}
