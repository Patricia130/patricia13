import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/home_bloc.dart';

class ServicesModuleWidget extends StatelessWidget {
  final HomeBloc home;

  const ServicesModuleWidget({super.key, required this.home});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: home,
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          final homeBloc = context.read<HomeBloc>();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.width * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (homeBloc.rideModules.length > 1)
                    Row(
                      children: [
                        const Icon(Icons.grid_view_rounded, size: 20),
                        const SizedBox(width: 5),
                        MyText(
                          text: AppLocalizations.of(context)!.service,
                          textStyle: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  // View All Services
                  if (homeBloc.rideModules.length > 4)
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return BlocProvider.value(
                                value: homeBloc,
                                child:
                                    viewAllServices(size, context, homeBloc));
                          },
                        );
                      },
                      child: MyText(
                        text: AppLocalizations.of(context)!.viewAll,
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(
                                fontSize: 14,
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
              SizedBox(height: size.width * 0.025),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    homeBloc.rideModules.length > 4
                        ? 4
                        : homeBloc.rideModules.length,
                    (index) {
                      final module = homeBloc.rideModules.elementAt(index);
                      return InkWell(
                        onTap: () {
                          if (homeBloc.pickupAddressList.isNotEmpty) {
                            if (module.serviceType == 'normal') {
                              if (module.transportType == 'delivery') {
                                homeBloc.add(ServiceTypeChangeEvent(
                                    transportType: module.transportType,
                                    serviceTypeIndex: 1));
                              } else {
                                homeBloc.add(ServiceTypeChangeEvent(
                                    transportType: module.transportType,
                                    serviceTypeIndex: 0));
                              }
                            } else if (module.serviceType == 'rental') {
                              homeBloc.add(ServiceTypeChangeEvent(
                                  transportType: module.transportType,
                                  serviceTypeIndex: 2));
                            } else if (module.serviceType == 'outstation') {
                              homeBloc.add(ServiceTypeChangeEvent(
                                  transportType: module.transportType,
                                  serviceTypeIndex: 3));
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 3),
                          child: Container(
                            width: size.width * 0.2,
                            decoration: BoxDecoration(
                              color: module.name ==
                                      homeBloc.selectedServiceType!.name
                                  ? Theme.of(context)
                                      .primaryColor
                                      .withAlpha((0.2 * 256).toInt())
                                  : Theme.of(context).scaffoldBackgroundColor,
                              border: Border.all(
                                width: module.name ==
                                        homeBloc.selectedServiceType!.name
                                    ? 1.5
                                    : 1,
                                color: module.name ==
                                        homeBloc.selectedServiceType!.name
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).dividerColor,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: module.menuIcon,
                                  fit: BoxFit.fill,
                                  height: size.width * 0.1,
                                  width: size.width * 0.1,
                                  placeholder: (context, url) => const Center(
                                    child: Loader(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Center(
                                    child: Text(""),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                MyText(
                                  text: module.name,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: AppColors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 2),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget viewAllServices(Size size, BuildContext context, HomeBloc homeBloc) {
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(width: size.width * 0.01),
                    const Icon(Icons.grid_view_rounded, size: 20),
                    const SizedBox(width: 5),
                    MyText(
                      text: AppLocalizations.of(context)!.service,
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.cancel_outlined))
              ],
            ),
            SizedBox(height: size.width * 0.05),
            Wrap(
              children: List.generate(
                homeBloc.rideModules.length,
                (index) {
                  final module = homeBloc.rideModules.elementAt(index);
                  return Padding(
                    padding: const EdgeInsets.only(right: 10, bottom: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        if (homeBloc.pickupAddressList.isNotEmpty) {
                          if (module.serviceType == 'normal') {
                            if (module.transportType == 'delivery') {
                              homeBloc.add(ServiceTypeChangeEvent(
                                  transportType: module.transportType,
                                  serviceTypeIndex: 1));
                            } else {
                              homeBloc.add(ServiceTypeChangeEvent(
                                  transportType: module.transportType,
                                  serviceTypeIndex: 0));
                            }
                          } else if (module.serviceType == 'rental') {
                            homeBloc.add(ServiceTypeChangeEvent(
                                transportType: module.transportType,
                                serviceTypeIndex: 2));
                          } else if (module.serviceType == 'outstation') {
                            homeBloc.add(ServiceTypeChangeEvent(
                                transportType: module.transportType,
                                serviceTypeIndex: 3));
                          }
                        }
                      },
                      child: Container(
                        width: size.width * 0.2,
                        decoration: BoxDecoration(
                          color: Theme.of(context).splashColor,
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          children: [
                            CachedNetworkImage(
                              imageUrl: module.menuIcon,
                              fit: BoxFit.fill,
                              height: size.width * 0.1,
                              width: size.width * 0.1,
                              placeholder: (context, url) => const Center(
                                child: Loader(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Center(
                                child: Text(""),
                              ),
                            ),
                            const SizedBox(height: 2),
                            MyText(
                              text: module.name,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 2),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: size.width * 0.2),
          ],
        ),
      ),
    );
  }
}
