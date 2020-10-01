import 'package:geolocator/geolocator.dart';

class Location{

  double latitude;
  double longitude;


 Future <void> getCurrentLocation() async{
    try{
      Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      // Position position = await GeolocatorPlatform.instance.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      //Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      latitude = position.latitude;
      longitude = position.longitude;
      print("$latitude --fucks-- $longitude");
    }catch(e)
    {
      print(" ekhon amra catch e asi");
    }


}

  }


