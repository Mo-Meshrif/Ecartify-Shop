import 'dart:async';

import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lottie;

import '../../../../../app/common/widgets/custom_sliding_up_pannel.dart';
import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../../app/helper/navigation_helper.dart';
import '../../../../../app/services/services_locator.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../../../main/auth/domain/entities/user.dart';
import '../../domain/entities/address.dart';
import '../controller/address_bloc.dart';
import '../widgets/address_bottom_widget.dart';
import '../widgets/custom_marker_widget.dart';

class AddEditAddressScreen extends StatefulWidget {
  final bool disableGestures;
  final bool forceDefault;
  final Address? address;
  const AddEditAddressScreen({
    Key? key,
    this.disableGestures = false,
    this.forceDefault = false,
    this.address,
  }) : super(key: key);

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
  late TextEditingController _addressName, _addressDetails;

  @override
  void initState() {
    checkPermission().then(
      (permission) {
        if (permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse) {
          _controller = Completer<GoogleMapController>();
          _addressName = TextEditingController();
          _addressDetails = TextEditingController();
          if (widget.address != null) {
            _loading = false;
            _addressName.text = widget.address!.name;
            updateLocation(
              LatLng(
                widget.address!.lat,
                widget.address!.lon,
              ),
              oldAddress: widget.address!,
            );
          } else {
            Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
            ).then(
              (value) {
                _loading = false;
                updateLocation(
                  LatLng(
                    value.latitude,
                    value.longitude,
                  ),
                );
              },
            );
          }
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

  updateLocation(LatLng latLng, {Address? oldAddress}) async {
    setState(
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
        if (oldAddress != null) {
          _addressName.text = oldAddress.name;
          _addressDetails.text = oldAddress.details;
        } else {
          getAddressDetailsFromLoc(latLng).then((val) {
            _addressDetails.text = val;
          });
        }
      },
    );
  }

  Future<String> getAddressDetailsFromLoc(LatLng latLng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      latLng.latitude,
      latLng.longitude,
    );
    return placemarks.isEmpty
        ? ''
        : placemarks[0].country == null
            ? placemarks[0].subAdministrativeArea == null
                ? placemarks[0].street ?? ''
                : placemarks[0].subAdministrativeArea! +
                    ',' +
                    (placemarks[0].street ?? '')
            : placemarks[0].subAdministrativeArea != null
                ? placemarks[0].country! +
                    ',' +
                    placemarks[0].subAdministrativeArea! +
                    ',' +
                    (placemarks[0].street ?? '')
                : placemarks[0].country! + ',' + (placemarks[0].street ?? '');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: CustomText(
            data: widget.disableGestures
                ? AppStrings.deliveryAddress.tr()
                : isEdit
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
                collapsed: widget.disableGestures
                    ? const SizedBox()
                    : Card(
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
                pannel: widget.disableGestures
                    ? const SizedBox()
                    : AddressBottomWidget(
                        address: widget.address,
                        addressName: _addressName,
                        addressDetails: _addressDetails,
                        forceDefault: widget.forceDefault,
                        onClickButton: (isDefault) {
                          LatLng latLng = _currentPosition!.target;
                          Address address = Address(
                            id: widget.address?.id,
                            name: _addressName.text,
                            details: _addressDetails.text,
                            lat: latLng.latitude,
                            lon: latLng.longitude,
                            isDefault: widget.forceDefault ? true : isDefault,
                          );
                          if (isEdit) {
                            sl<AddressBloc>().add(
                              EditAddressEvent(
                                address: address,
                              ),
                            );
                          } else {
                            sl<AddressBloc>().add(
                              AddAddressEvent(
                                address: address,
                              ),
                            );
                          }
                        },
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
                    onTap: (newLoc) {
                      if (!widget.disableGestures) {
                        updateLocation(newLoc);
                      }
                    },
                    onMapCreated: (controller) => _controller.complete(
                      controller,
                    ),
                  ),
                ),
              ),
      );
}
