import 'export.dart';

class Club extends CGCObject {
  late String name;
  late String email;
  late String phone;
  late String address;
  late String city;
  late String state;
  late String country;
  late String zipCode;
  late String windDirection;

  Club(String id, bool active, String name, String email, String phone, String address, String city, String state, String country, String zipCode, String windDirection) : super(id, active) {
    this.name = name;
    this.email = email;
    this.phone = phone;
    this.address = address;
    this.city = city;
    this.state = state;
    this.country = country;
    this.zipCode = zipCode;
    this.windDirection = windDirection;
    }

  factory Club.fromJSON(dynamic data) {
    return Club(
      // Graphene appends class name then Base64 encodes any ID.
      data['id'],
      data['active'],
      data["name"],
      data["email"],
      data["phone"],
      data["address"],
      data["city"],
      data["state"],
      data["country"],
      data["zipCode"],
      data["windDirection"]
    );
  }

}
