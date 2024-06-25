// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';
import 'package:petcare/src/layers/application/location_service.dart';
import 'package:petcare/src/layers/domain/branch.dart';
import 'package:petcare/src/layers/presentation/common_widgets/card_container.dart';
import 'package:latlong2/latlong.dart';

class BranchCard extends ConsumerWidget {
  final Branch branch;
  const BranchCard({
    Key? key,
    required this.branch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CardContainer(
      enableShadow: false,
      background: AppColors.blue500,
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: NetworkImage(
                'https://firebasestorage.googleapis.com/v0/b/pet-care-b0d24.appspot.com/o/pet-guardian-icon.png?alt=media&token=f4d29c98-2034-4a2b-8900-af92a6d9f16d'),
            radius: 27,
          ),
          SizedBox(width: proportionateWidth(10)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                branch.name,
                style: AppTextStyles.bodySemiBold(14, AppColors.grey0),
              ),
              SizedBox(
                width: proportionateWidth(170),
                child: Text(
                  branch.address(),
                  style: AppTextStyles.bodyRegular(14, AppColors.grey0),
                ),
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/Location point.svg',
                    height: 18,
                    width: 18,
                    color: AppColors.blue500,
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
                                style: AppTextStyles.bodyRegular(
                                    14, AppColors.grey600),
                              ),
                        loading: () => const CupertinoActivityIndicator(),
                        error: (error, stackTrace) => SizedBox(
                          width: proportionateWidth(150),
                          child: Text(
                            error.toString(),
                            style: AppTextStyles.bodyRegular(
                                14, AppColors.grey600),
                          ),
                        ),
                      )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
