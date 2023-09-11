import '../Utils/Functions.dart';

List<PlacesModel> placesjson = [
  PlacesModel(name: "All Places", icon: getplacename("allplaces")),
  PlacesModel(name: "Airports", icon: getplacename("airport")),
  PlacesModel(name: "ATMs", icon: getplacename("atm")),
  PlacesModel(name: "Banks", icon: getplacename("bank")),
  PlacesModel(name: "Building", icon: getplacename("building")),
  PlacesModel(name: "Book Store", icon: getplacename("bookstore")),
  PlacesModel(name: "Cinemas", icon: getplacename("cinemas")),
  PlacesModel(name: "Crossing", icon: getplacename("crossing")),
  PlacesModel(name: "Factory", icon: getplacename("factory")),
  PlacesModel(name: "Gas Stations", icon: getplacename("gasstation")),
  PlacesModel(name: "Gyms", icon: getplacename("gym")),
  // PlacesModel(name: "Graveyard", icon: getplacename("places")),
  PlacesModel(name: "Temple", icon: getplacename("temple")),
  PlacesModel(name: "Homes", icon: getplacename("homes")),
  PlacesModel(name: "Hospitals", icon: getplacename("hospitals")),
  PlacesModel(name: "Market", icon: getplacename("market")),
  PlacesModel(name: "Mosques", icon: getplacename("mosque")),
  PlacesModel(name: "Museums", icon: getplacename("museum")),
  PlacesModel(name: "Offices", icon: getplacename("office")),
  PlacesModel(name: "Parking", icon: getplacename("parking")),
  PlacesModel(name: "Parks", icon: getplacename("park")),
  PlacesModel(name: "Pharmacy", icon: getplacename("pharmacy")),
  PlacesModel(name: "Plots", icon: getplacename("plots")),

  PlacesModel(name: "Police Station", icon: getplacename("policestation")),
  PlacesModel(name: "Post Offices", icon: getplacename("postoffice")),
  PlacesModel(name: "Railway Station", icon: getplacename("railway")),
  PlacesModel(name: "Restaurants", icon: getplacename("restaurant")),
  PlacesModel(name: "Schools", icon: getplacename("school")),

  PlacesModel(name: "Shopping Malls", icon: getplacename("shoppingmall")),
  PlacesModel(name: "Universities", icon: getplacename("university")),
  PlacesModel(name: "Others", icon: getplacename("others")),
];

class PlacesModel {
  String name;
  String icon;
  PlacesModel({required this.name, required this.icon});
}
