import 'dart:async';

import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lottie;

import '../../../../../app/common/widgets/custom_sliding_up_pannel.dart';
import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../../app/helper/navigation_helper.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../../../main/auth/domain/entities/user.dart';
import '../../domain/entities/address.dart';
import '../widgets/address_bottom_widget.dart';
import '../widgets/custom_marker_widget.dart';

class AddEditAddressScreen extends StatefulWidget {
  final Address? address;
  const AddEditAddressScreen({Key? key, this.address}) : super(key: key);

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  AuthUser user = HelperFunctions.getSavedUser();
  late bool isEdit = widget.address != null;
  bool _loading = true;
  Set<Marker> _markers = {};
  late Completer<GoogleMapController> _controller;
  CameraPosition? _currentPosition;

  @override
  void initState() {
    checkPermission().then(
      (permission) {
        if (permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse) {
          Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
              .then(
            (value) {
              _loading = false;
              _controller = Completer<GoogleMapController>();
              updateLocation(
                LatLng(
                  value.latitude,
                  value.longitude,
                ),
              );
            },
          );
        } else {
          setState(() {
            _loading = false;
          });
        }
      },
    );
    super.initState();
  }

  Future<LocationPermission?> checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        return permission;
      } else if (permission == LocationPermission.deniedForever) {
        NavigationHelper.pop(context);
        Geolocator.openLocationSettings();
        return null;
      } else {
        return Geolocator.requestPermission();
      }
    } else {
      return null;
    }
  }

  updateLocation(LatLng latLng) => setState(
        () {
          _currentPosition = CameraPosition(
            zoom: 14.4746,
            target: latLng,
          );
          _markers = {
            Marker(
              markerId: const MarkerId('loc'),
              position: _currentPosition!.target,
            ),
          };
        },
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: CustomText(
            data: isEdit
                ? AppStrings.editAddress.tr()
                : AppStrings.addNewAddress.tr(),
          ),
        ),
        body: _loading || _currentPosition == null
            ? Center(
                child: !_loading
                    ? const Icon(Icons.error)
                    : lottie.Lottie.asset(
                        JsonAssets.loading,
                        height: AppSize.s200,
                        width: AppSize.s200,
                      ),
              )
            : CustomSlidingUpPanel(
                collapsed: Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppSize.s25.r),
                      topRight: Radius.circular(AppSize.s25.r),
                    ),
                  ),
                  child: Container(
                    width: 1.sw,
                    padding: EdgeInsets.symmetric(
                      vertical: AppPadding.p20.h,
                    ),
                    child: CustomText(
                      textAlign: TextAlign.center,
                      data: AppStrings.swipeToFillAddressDetails.tr(),
                      fontWeight: FontWeight.bold,
                      fontSize: AppSize.s25.sp,
                    ),
                  ),
                ),
                pannel: AddressBottomWidget(
                  address: widget.address,
                ),
                body: CustomGoogleMapMarkerBuilder(
                  customMarkers: _markers
                      .map(
                        (e) => MarkerData(
                          marker: e,
                          child: CustomMarkerWidget(
                              symbol: user.name[0].toUpperCase()),
                        ),
                      )
                      .toList(),
                  builder: (p0, markers) => GoogleMap(
                    markers: markers ?? {},
                    initialCameraPosition: _currentPosition!,
                    myLocationButtonEnabled: false,
                    onTap: (newLoc) => updateLocation(newLoc),
                    onMapCreated: (controller) => _controller.complete(
                      controller,
                    ),
                  ),
                ),
              ),
      );
}
