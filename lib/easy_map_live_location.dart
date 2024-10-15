import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// import '../../feature/home/map_controller.dart';

class MapWidget extends StatelessWidget{

  Stream<Position>? positionStream;
  LatLng currentpos = LatLng(31.119318, -99.245435);

  Future<void> getCurrentPos(GoogleMapController mapController) async {





    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get the position stream
    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high, // High accuracy
        distanceFilter: 10, // Update if user moves 10 meters
      ),
    );

    positionStream!.listen((Position position) {

      // currentPosition = position;
      currentpos=LatLng(position.latitude, position.longitude);

      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: currentpos,
            zoom: 14, // You can change the zoom level here
          ),
        ),
      );





    });


  }




  // LatLng currentpos = LatLng(31.119318, -99.245435);
  final double height;
  final double width;

  MapWidget({super.key, required this.height, required this.width});



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: height,
      width: width,
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: GoogleMap(
        //initialCameraPosition: _kGoogle,
        markers: {
          Marker(
            markerId: MarkerId("Source"),
            position: currentpos,
          ),
        },
        mapType: MapType.normal,
        myLocationEnabled: true,
        compassEnabled: true,
        initialCameraPosition: CameraPosition(
          target: currentpos,
          zoom: 13,
        ),
        onMapCreated: (GoogleMapController controller) {

          getCurrentPos(controller);
          //_controller.complete(controller);
        },
      ),
    );
  }

}
